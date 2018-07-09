---
layout: single
title: "自宅Raspberry PiをZabbix Server on DigitalOceanで監視"
tags:
  - "Zabbix"
  - "Raspberry Pi"
date: 2015-03-10 19:00:00+09:00
redirect_from:
  - /2015/03/raspberry-pizabbix-server-on.html
---

自宅Raspberry Piが正常に動作しているかを確認したく、外部にZabbix Serverを構築して監視するようにしました。ただこれは過渡期で、将来的にはRaspberry PiでZabbix Serverを動作させ、外部からはAlertMe監視のみにします。
この文書では、試行錯誤して構築した作業を記録します。

## パッケージインストール→失敗

インストールできるか確認するため、qemu for Windows上でRaspbianを動作させ、そこで動作確認をしています。

[3 パッケージからのインストール [Zabbix Documentation 2.2]](https://www.zabbix.com/documentation/2.2/jp/manual/installation/install_from_packages)の手順を試したところ、`aptitude update`に失敗しました。

```
$ wget http://repo.zabbix.com/zabbix/2.2/debian/pool/main/z/zabbix-release/zabbix-release_2.2-1+wheezy_all.deb
$ sudo dpkg -i zabbix-release_2.2-1+wheezy_all.deb
$ sudo aptitude update
(中略)
W: Failed to fetch http://repo.zabbix.com/zabbix/2.2/debian/dists/wheezy/Release: Unable to find expected entry 'main/binary-armhf/Packages' in Release file (Wrong sources.list entry or malformed file)
E: Some index files failed to download. They have been ignored, or old ones used instead.
E: Couldn't rebuild package cache
```

## ソースコードからインストール

ソースコードをダウンロード、`--enable-agentd`のみにしたら`configure`が成功しました。そのまま、`make install`も成功しました。

## Zabbix Server on OpenShiftを構築→失敗

下記でインストールしました。

- [dkanbier/openshift-zabbix-quickstart](https://github.com/dkanbier/openshift-zabbix-quickstart)

Zabbix Agent on RPiとの接続を設定して認識はできましたが、`Zabbix agent on {HOST_NAME} is unreachable for 5 minutes`というエラーが表示されました。自宅側のポートフォワーディングは設定していてポート開放も確認済みなので、OpenShift側を疑いました。

- [Getting Started with Port Forwarding on OpenShift – OpenShift Blog](https://blog.openshift.com/getting-started-with-port-forwarding-on-openshift/)

```
$ rhc port-forward zabbix
Checking available ports ... done
Forwarding ports ...
Address already in use - bind(2) while forwarding port 3306. Trying local port
3307

To connect to a service running on OpenShift, use the Local address

Service   Local                OpenShift
--------- --------------- ---- -------------------
httpd     127.0.0.1:8080   =>  127.11.30.129:8080
mysql     127.0.0.1:3307   =>  127.11.30.130:3306
zabbix_ag 127.0.0.1:15050  =>  127.11.30.129:15050
zabbix_se 127.0.0.1:15051  =>  127.11.30.129:15051
```

Zabbixは通常、10050番、10051番ポートを使用しますが、15050番、15051番ポートが使用されているっぽい。ダッシュボードからZabbixサーバーの状態を見ると、15050番ポートで動作していることが分かります。

- [3 Zabbixエージェント（UNIX) [Zabbix Documentation 2.2]](https://www.zabbix.com/documentation/2.2/jp/manual/appendix/config/zabbix_agentd)

ここを見ると、`Server`と`ServerActive`でZabbix ServerのIPアドレス(またはホスト名)を指定しますが、ポート番号がデフォルトとは異なる場合、`ServerActive`でポート番号も指定する必要があるみたい。

→指定したけどダメだった。障害のまま。と言うかZabbix Server on OpenShiftをポート開放確認してみたけど、到達できないっぽい。なんで？

→`rhc port-forward`はローカルPC→OpenShiftのsshフォワーディングっぽい。よって、この方法は断念。

## DigitalOceanのCentOSにZabbixをインストール

OpenShiftにZabbix Serverを構築するのは諦めて、DigitalOceanに構築することにしました。

### Dropletを作成する

- Droplet Hostname
	- zabbix
- Select Size
	- $5/mo
- Select Region
	- New York
- Select Image
	- CENTOS 6.5 x64

### 作業ユーザーを作成する

`root`でsshログインします。

```
# adduser u6k
# passwd u6k
```

```
# visudo
```

追記

```
u6k ALL=(ALL) NOPASSWD: ALL
```

### ローカルPCで鍵を作成し、公開鍵を作業ユーザーに設定する

PUTTYgenで作成しました。

ローカルPCで実行。

```
ssh-copy-id -i id_rsa_digital_ocean.pub u6k@104.131.110.177
```

以降、`u6k`ユーザーで作業します。

#### NOTE: ssh-copy-idが失敗することがある

```
$ ssh-copy-id -i id_rsa_digital_ocean.pub u6k@104.131.110.177
/usr/local/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed

/usr/local/bin/ssh-copy-id: WARNING: All keys were skipped because they already exist on the remote system.
```

結局、手動でコピーしたほうが良いかも。

### sshdの設定を変更する

```
$ sudo vi /etc/ssh/sshd_config
```

```
RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PermitRootLogin no
RhostsRSAAuthentication no
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
Port 23347
```

```
$ sudo service sshd restart
```

新規にsshセッションを起動し、rootログイン出来ないこと、パスワード認証できないこと、新しいポート番号で接続できること、を確認します。万が一、設定に失敗してssh接続できなくなると非常に困るので、この確認ができるまではsshセッションは切断しないように注意します。

### ufwでファイアウォールを設定する

```
$ sudo yum -y install wget
```

[ufw in Launchpad](https://launchpad.net/ufw/)でダウンロードURLを確認します。

```
$ wget https://launchpad.net/ufw/0.33/0.33/+download/ufw-0.33.tar.gz

$ tar zxvf ufw-0.33.tar.gz
$ cd ufw-0.33
$ sudo python ./setup.py install
$ sudo chmod -R g-w /etc/ufw/ /lib/ufw/ /etc/default/ufw /usr/sbin/ufw
$ cd ../
$ sudo rm -r ufw-0.33*
```

ファイアウォールの設定をリセットします。

```
$ sudo ufw reset
```

現状を確認します。

```
$ sudo ufw status
Status: inactive
```

HTTP(80)、HTTPS(443)、ssh(23347)、Zabbix(10051)を許可します。

```
$ sudo ufw default DENY
$ sudo ufw allow 80
$ sudo ufw allow 443
$ sudo ufw allow 23347
$ sudo ufw allow 10051
$ sudo ufw enable
$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
80                         ALLOW       Anywhere
443                        ALLOW       Anywhere
23347                      ALLOW       Anywhere
10051                      ALLOW       Anywhere
80 (v6)                    ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)
23347 (v6)                 ALLOW       Anywhere (v6)
10051 (v6)                 ALLOW       Anywhere (v6)
```

* 参考
	* [ufwをcentosにインストール - Qiita](http://qiita.com/soramugi/items/d0514895340fc8fa3430)

### 開発パッケージをインストールする

```
$ sudo yum -y update
$ sudo yum -y groupinstall "Development tools"
```

### MySQLをインストールする

```
$ sudo yum -y install mysql-server mysql-devel
$ sudo chkconfig mysqld on
$ sudo service mysqld start
```

試しに接続してみます。

```
$ mysql -u root
```

### Zabbixをパッケージでインストールする

* 参考
	* [3 パッケージからのインストール [Zabbix Documentation 2.2]](https://www.zabbix.com/documentation/2.2/jp/manual/installation/install_from_packages)

Zabbixパッケージをインストールします。

```
$ sudo rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm
$ sudo yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent
```

MySQLデータベースを作成します。

```
$ mysql -u root
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
mysql> exit;
```

データをインポートします。

```
$ cd /usr/share/doc/zabbix-server-mysql-2.2.8/create/
$ mysql -u root zabbix < schema.sql
$ mysql -u root zabbix < images.sql
$ mysql -u root zabbix < data.sql
```

Zabbixサーバーの設定を編集します。

```
$ sudo vi /etc/zabbix/zabbix_server.conf
```

```
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```

Zabbixサーバーを起動します。

```
$ sudo chkconfig zabbix-server on
$ sudo service zabbix-server start
```

Zabbix Webインターフェイス(以降、Zabbix管理サイト)の設定を編集します。

```
$ sudo vi /etc/httpd/conf.d/zabbix.conf
```

一部の設定はされています。

```
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
# php_value date.timezone Europe/Riga
```

`date.timezone`をコメントインして、正しく設定します。

```
php_value date.timezone Asia/Tokyo
```

Apache HTTP Serverを起動します。

```
$ sudo chkconfig httpd on
$ sudo service httpd start
```

[http://xxx/zabbix](http://xxx/zabbix)にアクセスすると、Zabbix管理サイトのセットアップページが表示されます。設定が正しければ、「Next」ボタンをクリックしていってセットアップを完了できます。セットアップ完了後、ログインページが表示されます。アカウントは、ユーザーID: Admin、パスワード: zabbix。

続いて、Zabbixエージェントの設定を編集します。

```
$ sudo vi /etc/zabbix/zabbix_agentd.conf
```

既に同一マシン上のZabbixサーバーと接続する設定がされているので、編集は必要ありません。

Zabbixエージェントを起動します。

```
$ sudo chkconfig zabbix-agent on
$ sudo service zabbix-agent start
```

Zabbix管理サイトに戻り、`Admin`ユーザーのパスワードを変更します。

次に、`Zabbix server`のStatusを`Monitored`に変更し、監視を開始します。しばらくしてからグラフを表示して、監視が正常動作していることを確認します。

### NOTE: Lack of free swap space on Zabbix server

Zabbixはスワップ領域を監視しますが、`Lack of free swap space on Zabbix server`はスワップ領域が不足している or 存在しないことを表すエラーです。

小さなスワップ領域を作成することで回避します。

```
$ sudo dd if=/dev/zero of=/var/swapfile bs=1M count=2048
$ sudo chmod 600 /var/swapfile
$ sudo mkswap /var/swapfile
$ echo /var/swapfile none swap defaults 0 0 | sudo tee -a /etc/fstab
$ sudo swapon -a
```

問題が解消されていることを確認します。

* 参考
	* [ZabbixでLack of free swap spaceのエラーが出るときの対処 | Scribble](http://scribble.washo3.com/linux/zabbix%E3%81%A7lack-of-free-swap-space%E3%81%AE%E3%82%A8%E3%83%A9%E3%83%BC%E3%81%8C%E5%87%BA%E3%82%8B%E3%81%A8%E3%81%8D%E3%81%AE%E5%AF%BE%E5%87%A6.html)

## Raspberry PiにZabbix Agentをインストール

### Zabbix管理サイトにホストを追加する

Zabbix管理サイトのホストにRaspberry Piを追加します。この時点では、Zabbixエージェントが動作していないので、監視が失敗します。

### Zabbixエージェントをソースコードからインストールする

Zabbixソースコードをダウンロードし、展開します。

```
$ tar zxvf zabbix-2.2.8.tar.gz
```

ユーザーを作成します。

```
$ sudo groupadd zabbix
$ sudo useradd -g zabbix zabbix
```

ソースコードを設定し、インストールします。

```
$ ./configure --enable-agent
$ sudo make install
$ cd ../
$ sudo rm -r zabbix-2.2.8*
```

Zabbixエージェント設定を編集します。

```
$ sudo vi /usr/local/etc/zabbix_agentd.conf
```

```
Server=104.131.110.177
ServerActive=104.131.110.177:10050
Hostname=RPi
```

Zabbixエージェントを起動します。

```
$ sudo /usr/local/sbin/zabbix_agentd
```

しばらくして、Zabbix管理サイトのステータスを確認します。

### Zabbix Agentのログ

`/tmp/zabbix_agentd.log`に出力されます。`/var/log/`以下でないことに注意(多くのサイトでは`/var/log/zabbix/`以下で説明されていますが、なぜ違うのだろう…)。

### Zabbix監視が問題のまま

`Received empty response from Zabbix Agent at Assuming that agent dropped connection because of access permission`

[zabbix_getの返り値が空白 | ZABBIX-JP](http://www.zabbix.jp/node/1088)

パッケージインストールした場合、`zabbix-get`はインストールされないので、インストールします。

```
$ sudo yum -y install zabbix-get
```

```
$ zabbix_get -s u6kapps.dip.jp -p 10050 -k agent.version
2.2.8
```

Zabbix管理サイトを見たら、状況が変化していました。

`Lack of free swap space on 自宅Raspberry Pi`が出力されたので、Zabbixサーバーと同様に解消しました。

## Zabbix Agentをサーバー起動時に起動

`zabbix_agentd`を停止するには`kill -TERM`するしかなさそうです。また、このままではサーバー起動時にZabbix Agentが起動しません。これを解決するため、`zabbix_agentd`の起動スクリプトを作成します。

`/etc/init.d/zabbix_agentd`を以下のように作成します。

```
$ cat /etc/init.d/zabbix_agentd
#!/bin/sh
### BEGIN INIT INFO
# Provides: zabbix-agentd
# Required-Start: $network $syslog
# Required-Stop: $network
# chkconfig: 2345 99 1
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Start or stop the Zabbix-Agent
### END INIT INFO

case $1 in
    start)
        /usr/local/sbin/zabbix_agentd
        ;;
    stop)
        kill -TERM `cat /tmp/zabbix_agentd.pid`
        ;;
    restart)
        $0 stop
        sleep 3
        $0 start
        ;;
    *)
        echo "Usage: $0 start|stop|restart"
        exit 1
esac
```

実行権限を与えます。

```
$ sudo chmod +x /etc/init.d/zabbix_agentd
```

サービスとして登録します。

```
$ sudo chkconfig --add zabbix_agentd
```

試しに起動、停止してみます。

```
$ sudo service zabbix_agentd start
$ sudo service zabbix_agentd stop
```

* 参考
	* [ZABBIXエージェントの停止方法（AIXエージェント） | ZABBIX-JP](http://www.zabbix.jp/node/557)

## Raspberry PiのCPU温度をZabbix Serverに送信

`zabbix_sender`を使用してRaspberry PiのCPU温度をZabbix Serverに送信します。

Zabbix ServerのRPiホストにアイテムを追加します。

- Name: cpu_temp
- Type: Zabbix.trapper
- Key: system.cpu.temp
- Type of information: Numeric (unsigned)
- Data type: Decimal

グラフを追加します。

- Name: CPU Temperature
- Graph type: Normal
- Items: cpu_tempを追加

RaspberryPiで以下のコマンドを実行します。

```
$ zabbix_sender -z 104.131.110.177 -s RPi -k system.cpu.temp -o `cat /sys/class/thermal/thermal_zone0/temp`
```

グラフを見て、値が登録されていることを確認します。

問題なければ、上記コマンドをcrontabやJenkinsなどで定期実行するように設定します。

## 参考リンク

- [Introducing Zabbix Monitoring Cartridges for OpenShift – OpenShift Blog](https://blog.openshift.com/introducing-zabbix-monitoring-cartridges-for-openshift/)
- [Zabbix on the Raspberry Pi (OS Raspbian) - Zabbix.org](https://www.zabbix.org/wiki/Zabbix_on_the_Raspberry_Pi_(OS_Raspbian))
- [連載記事 「ZABBIXで脱・人手頼りの統合監視」](http://www.atmarkit.co.jp/flinux/index/indexfiles/zabbixindex.html)
- [「クラウド＆DevOps時代の運用をZabbixで」最新記事一覧 - ITmedia Keywords](http://www.atmarkit.co.jp/ait/kw/devops_zabbix.html)
