---
layout: post
title: "Zabbixをインストールして簡単に動作確認を行う"
tags:
  - "Zabbix"
  - "Vagrant"
date: 2015-02-22 05:34:00+09:00
---

# ちょっと長めの前置き

自分用のWebアプリケーションをいくつか動作させていて、それらが正常動作しているかの確認に[AlertMe](http://www.securestar.jp/alertme/)を利用しています。定期的にアプリにHTTPアクセスを行い、時間がかかりすぎると障害としてメールが飛んできます。

AlertMeは簡単に設定できて非常に便利に使っていますが、CPU使用率、ディスク容量など他の項目も柔軟に監視したいと思い、別の監視サービスを利用しようと思います。自宅ではRaspberry Piを動作させているので、これのCPU温度やHDD健康状態も監視したいですね。

~~私はOpenShiftをよく使っており、[dkanbier/openshift-zabbix-quickstart](https://github.com/dkanbier/openshift-zabbix-quickstart)を使ってZabbix Serverをインストールし、RPi側にはZabbix Agentをインストールして監視しようとしましたが、どうにも「Zabbix agent on {HOST_NAME} is unreachable for 5 minutes」というエラーが解消できませんでした。~~ OpenShiftにZabbix Serverを建てる方向は諦めました。後述。

そこで、とりあえず普通にインストールした場合にZabbixをどのように設定すればよいのかを試すため、VagrantにZabbix ServerとZabbix Agentをセットアップして動作を確認したいと思います。

<!-- more -->

# 前提

Zabbixのインストールは、[4 ソースからのインストール [Zabbix Documentation 2.2]](https://www.zabbix.com/documentation/2.2/jp/manual/installation/install)の手順で行います。

Vagrantを使用するので、あらかじめ使用可能にしてください。

PCはMacBookProを使用していますが、Windowsでも適宜読み替えれば問題無いはずです。

## NOTE: vagrant-vbox-snapshot

Vagrantで作業する時は、`vagrant-vbox-snapshot`を使うと便利。各ステップごとにスナップショットを取得しておくと、手順を間違えたりした時にすぐに戻せます。

- [dergachev/vagrant-vbox-snapshot](https://github.com/dergachev/vagrant-vbox-snapshot)
- [vagrantの便利に使えるプラグイン6選 - Qiita](http://qiita.com/succi0303/items/e06bca7db5a0c3de96af)
- [Vagrantにスナップショット機能を加えるplugin、vagrant-vbox-snapshotの紹介 - Qiita](http://qiita.com/takuan_osho/items/682b776b41989f0b016f)

# VagrantでCentOSを使用する

ここでは`chef/centos-6.5`を使用しますが、好きなOSを使用すれば良いです。

```
$ vagrant init chef/centos-6.5
```

ゲストOS側の80番ポートをホストOSの10080番ポートにフォワードする設定を`Vagrantfile`に追記します。

```bash:Vagrantfile
config.vm.network "forwarded_port", guest: 80, host: 10080
```

Vagrantを起動します。

```
$ vagrant init chef/centos-6.5
```

起動したCentOSにsshでログインします。

```
$ vagrant ssh
```

*NOTE: Windowsの場合、sshコマンドが無いため失敗するはずです。Cygwinを入れるとか、TeraTermで接続するとかしてください。*

# 前提パッケージのインストール

インストール済みのパッケージを最新化します。

```
$ sudo yum -y update
```

開発ツールをインストールします。

```
$ sudo yum -y groupinstall "Development tools"
```

DBエンジンとしてMySQLを使用したいので、開発用ファイルも含めてインストールします。DBとしては他にPostgreSQL、Oracle、DB2、SQLiteが使えるようです。

```
$ sudo yum -y install mysql-server mysql-devel
$ sudo chkconfig mysqld on
$ sudo service mysqld start
```

Zabbixが必要とするソフトウェアをインストールします。これは、後で行う`./configure`のエラーを見ながらつどインストールしたほうが良いかもしれません。

```
$ sudo yum -y install libxml2 libxml2-devel net-snmp net-snmp-devel curl libcurl libcurl-devel
```

# Zabbixソースコードのダウンロード

インストールパッケージが提供されていますが、今回はソースコードからインストールすることにします。ソースコードはSourceForge.netで提供されているので、そこからダウンロードリンクを取得して、wgetなどでダウンロードします。

```
$ wget http://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/2.2.8/zabbix-2.2.8.tar.gz?r=http%3A%2F%2Fwww.zabbix.com%2Fdownload.php&ts=1424460111&use_mirror=tcpdiag
```

*NOTE: `zabbix-2.2.8.tar.gz`というファイル名になれば良いですが、クエリパラメータも含めた変なファイル名になってしまうことがあるので、リネームします。*

展開します。

```
$ tar zxvf zabbix-2.2.8.tar.gz
```

# Zabbix用ユーザーを作成する

Zabbixが使用するユーザーを作成します。とりあえずここでは`zabbix`というユーザーを作成しますが、セットアップ手順に注意事項が書いてあるので、それを熟読したほうが良いです。

```
$ sudo groupadd zabbix
$ sudo useradd -g zabbix zabbix
```

# DBを作成する

DBを作成し、zabbixに用意されているSQLスクリプトを実行します。

まず、DBを作成します。

```
mysql> create database zabbix character set utf8 collate
```

次にzabbixに用意されているSQLスクリプトを実行します。

```
$ mysql -u root -p zabbix < database/mysql/schema.sql
$ mysql -u root -p zabbix < database/mysql/images.sql
$ mysql -u root -p zabbix < database/mysql/data.sql
```

# ソースを設定し、インストールする

`./configure`を実行し、ソースを設定します。インストールするソフトウェアや使用するDBエンジンによって設定方法が異なりますが、ここではZabbix ServerとZabbix AgentをインストールしてMySQLを使用するよう設定します。

```
$ ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2
```

関連ソフトウェアが揃っていれば、エラーが表示されず終了します。

```
***********************************************************
*            Now run 'make install'                       *
*                                                         *
*            Thank you for using Zabbix!                  *
*              <http://www.zabbix.com>                    *
***********************************************************
```

設定が成功しました。言われた通り、`make install`を実行します。

```
$ sudo make install
```

インストールが完了しました。

## NOTE: 関連ソフトウェアがインストールされていない場合

関連ソフトウェアがインストールされていないと、エラーになります。

```
configure: error: LIBXML2 library not found
```

LIBXML2が見つからないため、`yum search libxml2`を実行してそれっぽいパッケージを探し、インストールします。

```
$ sudo yum -y install libxml2 libxml2-devel
```

`./configure`を再実行します。

```
configure: error: Invalid Net-SNMP directory - unable to find net-snmp-config
```

Net-SNMPが見つからないため、`yum search net-snmp`を実行してそれっぽいパッケージを探し、インストールします。

```
$ sudo yum -y install net-snmp net-snmp-devel
```

`./configure`を再実行します。

```
configure: error: Curl library not found
```

Curlライブラリが見つからないため、`yum search curl`を実行してそれっぽいパッケージを探し、インストールします。

```
$ sudo yum -y install curl libcurl libcurl-devel
```

`./configure`を再実行します。

```
***********************************************************
*            Now run 'make install'                       *
*                                                         *
*            Thank you for using Zabbix!                  *
*              <http://www.zabbix.com>                    *
***********************************************************
```

設定が成功しました。

# 設定ファイルの編集

Zabbix Serverの設定ファイルは`/usr/local/etc/zabbix_server.conf`にあります。

Zabbix Agentの設定ファイルは`/usr/local/etc/zabbix_agentd.conf`にあります。

とりあえず今回は編集することがないので、そのままにしておきます。

*NOTE: `zabbix_agent.conf`というファイルもありますが、こちらは使用しないようです。*

# Zabbix ServerとZabbix Agentを起動

Zabbix Serverを起動します。

```
$ zabbix_server
```

Zabbix Agentを起動します。

```
$ zabbix_agentd
```

コンソールには何も出力されないですが、これで起動します。`ps aux | grep zabbix`で起動していることが確認できます。

# Webインターフェイスをインストール

Zabbix ServerはWebインターフェイスを持ちますが、これは何らかのWebサーバーでPHPアプリケーションとして動作します。なので、まずApache HTTP ServerとPHPをインストールします。

```
$ sudo yum -y install httpd php
$ sudo chkconfig httpd on
$ sudo service httpd start
```

Webインターフェイスをインストールします。単にWeb公開フォルダに配置するだけです。

```
$ sudo mkdir /var/www/html/zabbix
$ cd frontends/php/
$ sudo cp -a . /var/www/html/zabbix/
$ sudo chown -R apache:apache /var/www/html/zabbix/
```

Webブラウザから[http://localhost:10080/zabbix/](http://localhost:18080/zabbix/)にアクセスします。

![Zabbix Web Interface Installation 1](https://lh3.googleusercontent.com/FUG8EYqhvJdMQXlYJ7m9Vr7zULErktJXWOAxo5uLKpI=s0 "Installation.png")

「Next」をクリックします。

![Zabbix Web Interface Installation 2](https://lh3.googleusercontent.com/uk69JD6kb9Iw1N4gyZNtL2CnQC_j28rCDq8vchZwLeU=s0 "Installation 2.png")

必要要件がチェックされます。要件を満たしていない場合、「Fail」が表示されます。「Fail」にカーソルをポイントすると、どうすれば良いかが表示されます。

![Zabbix Web Interface Installation 3](https://lh3.googleusercontent.com/i--5Pk31z_KZJH1MXtBdtKlBo0g9zV_OVMOzyaj4Ym0=s0 "Installation 3.png")

ここでは、以下の項目が「Fail」になりました。

* PHP option post_max_size
* PHP option max_execution_time
* PHP option max_input_time
* PHP time zone
* PHP databases support
* PHP bcmath
* PHP mbstring
* PHP gd
* PHP gd PNG support
* PHP gd JPEG support
* PHP gd FreeType support
* PHP xmlwriter
* PHP xmlreader

これを解消します。

まずPHPオプションを設定するため、`/var/www/html/zabbix/.htaccess`ファイルを作成し、内容を以下のようにします。

```apache:/var/www/html/zabbix/.htaccess
php_value post_max_size 16M
php_value max_execution_time 300
php_value max_input_time 300
php_value date.timezone Asia/Tokyo
```

`.htaccess`が禁止されている場合、`/etc/httpd/conf/httpd.conf`を編集します。

```apache:/etc/httpd/conf/httpd.conf
AllowOverride All
```

次に、PHPモジュールをインストールします。不足しているモジュールを「Fail」をクリックして調べて、`yum`でインストールしていきます。

```
$ sudo yum -y install php-mysql php-bcmath php-mbstring gd gd-devel php-gd php-xml
```

Apache HTTP Serverを再起動します。

```
$ sudo service httpd graceful
```

Webブラウザに戻り、「Retry」ボタンをクリックします。必要要件を満たしていれば、全て「OK」になります。まだ「Fail」が表示されている場合、個別に解消方法を調べてください。

![Zabbix Web Interface Installation 4](https://lh3.googleusercontent.com/oa5rGRBfHGEwDBdY0jPqCeBEbrQZhWxKxTL43pvxwDU=s0 "Installation 4.png")

「Next」をクリックします。

![Zabbix Web Interface Installation 5](https://lh3.googleusercontent.com/SjfxdLj5ymNtWTrM9Fm9PJXNg2PaXDsshC0RyGsk_ko=s0 "Installation 5.png")

DB接続を設定します。設定を入力し、「Test connection」をクリックすることでDB接続を確認できます。ここは変更はしません。設定に問題が無ければ、「OK」が表示されます。

![Zabbix Web Interface Installation 6](https://lh3.googleusercontent.com/wPmE4rtkAnBN0kM4m6Asv52v8hTN0sz9iJJHyqltBcs=s0 "Installation 6.png")

「Next」をクリックします。

![Zabbix Web Interface Installation 7](https://lh3.googleusercontent.com/YLCN3ERum1ZW-vjyOgBjk9BvsHD4Z7dss4H6uIXMNlk=s0 "Installation 7.png")

Zabbix Serverの設定を入力します。ここでは何も変更しませんので、そのまま「Next」をクリックします。

![Zabbix Web Interface Installation 8](https://lh3.googleusercontent.com/UnkXEyLAZ7SDAEHDl_c78JZe0a68LPPe4_d5y4CyEC4=s0 "Installation 8.png")

「Next」をクリックします。

![Zabbix Web Interface Installation 9](https://lh3.googleusercontent.com/QU1ZCOrJDyHolfSH-EP92HellIxXGon3tV2fEsSf75U=s0 "Installation 9.png")

設定ファイルが作成され、問題無ければ「OK」が表示されます。「Finish」をクリックすることで、インストールが完了します。

# Zabbixにログインし、Zabbix Server自体の監視を開始

![Login](https://lh3.googleusercontent.com/QotQsKt2IocZaF41NDO83ANUo7RMDD81DOMuzZoLwDQ=s0 "Zabbix.png")

インストールが完了すると、ログインページが表示されます。初期ユーザーは「Admin」、パスワードは「zabbix」になっていますので、入力して「Sign in」をクリックします。

![Dashboard](https://lh3.googleusercontent.com/nVMk9fbQrQTS8w5X-mNHgHiA5zUBHg_Z4HCdmtgUWHQ=s0 "Dashboard.png")

ログインすると、ダッシュボードが表示されます。すぐにAdminユーザーのパスワード変更や、作業ユーザーの作成などを行うべきですが、ここではとりあえずスキップします。

Zabbix Server自体の監視を有効にするため、メニューの「Configuration」→「Hosts」をクリックします。

![Hosts](https://lh3.googleusercontent.com/9aDlRIT_0Isbf3SVJvPMSJBW-DwM9HdU41zpQVNI5r4=s0 "Configuration_of_hosts.png")

リストに「Zabbix server」が表示されますので、クリックします。

![Hosts](https://lh3.googleusercontent.com/OblId2ojU61NaRfWh9CfrKUH52pvTCGYMGg15eV0IKY=s0 "Configuration_of_hosts 2.png")

「Status」を「Monitored」に変更して、「Save」をクリックして設定を保存します。

![Hosts](https://lh3.googleusercontent.com/mBr0_KAexPrcIVPF3Uqe-dTsF6NuN4c7_9nupAqMkEo=s0 "Configuration_of_hosts 3.png")

リストの「Zabbix server」の「Status」が「Monitored」に変わっていることがわかります。

メニューの「Monitoring」→「Graphs」をクリックして、「Graph」を適当に、例えば「CPU load」に設定すると、グラフが表示されて監視できていることがわかります。

![Graph](https://lh3.googleusercontent.com/oCPI4YGjpOS4zsiqEJPte_xCPXyP8hG6mUNIkNR49Qw=s0 "Custom_graphs__refreshed_every_30_sec__.png")

# おわりに

これでZabbixの簡単な動作が確認できたので、次はOpenShiftにZabbix Server、RPiにZabbix Agentをセットアップして監視をしたいと思います。

## NOTE: Zabbix Server on OpenShiftを諦めたわけ

OpenShiftではポートを開けられないっぽい。`rhc port-forward`はローカル→OpenShiftのsshフォワーディングであり用途が違うし…

* 参考
    * [Getting Started with Port Forwarding on OpenShift – OpenShift Blog](https://blog.openshift.com/getting-started-with-port-forwarding-on-openshift/)

AWSかDigitalOceanにZabbix Serverを建てる方向で検討します。
