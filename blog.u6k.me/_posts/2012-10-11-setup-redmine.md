---
layout: post
title: "Redmineセットアップ"
tags:
  - "Redmine"
  - "Setup"
date: 2012-10-11 23:37:00+09:00
---

何故か、何度かRedmineをセットアップしたことがありますが、はっきり言って面倒くさい！　なんか色々依存関係はあるし、少しバージョンが異なるとすぐに動かなくなるし…

というわけで、JRuby+Redmine+Tomcatという環境を作って、直ぐに展開できる状態にしたいと思います。展開するだけで使用可能！

ただその前に、もう一度Redmineのセットアップをおさらいすることで、セットアップ過程を再確認するとともに理解を深めたいと思います。

<!-- more -->

# 前提

* CentOS 6.3
* Redmine 2.1.2
* MySQL 5.1.61
* Apache HTTP Server 2.2.15

いずれも、2012/10/11時点の最新バージョンです。CentOSは、OSセットアップ直後に近い状態です(作業ユーザーの追加、ネットワーク設定などを行いました)。

# 参考ページ

ほとんど[Redmine 2.1をCentOS 6.3にインストールする手順 | Redmine.JP Blog](http://blog.redmine.jp/articles/redmine-2_1-installation_centos/)を参考にしています。以下の手順も、参考ページに沿って進めます。

# セットアップ手順

## SELinuxを無効に設定

`/etc/sysconfig/selinux`を開きます。

```
$ sudo vi /etc/sysconfig/selinux
```

`SELINUX`の値を`disabled`に変更します。

```
SELINUX=enforcing
↓
SELINUX=disabled
```

変更後、OSを再起動します。

```
$ sudo reboot
```

再起動後、getenforceコマンドを実行してSELinuxが無効に設定されたことを確認します。

```
$ getenforce
Disabled
```

## iptablesでHTTPを許可

`/etc/sysconfig/iptables`を開きます。

```
$ sudo vi /etc/sysconfig/iptables
```

80/tcpへの接続を許可する設定を追記します。

```
# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
# ↓追記
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT
```

設定を変更後、iptablesを再起動します。

```
$ sudo service iptables restart
```

## EPELリポジトリを登録

以下のページで、最新のepel-releaseパッケージのURLを確認します。

* [RepoView: "Fedora EPEL 6 - x86_64"](http://dl.fedoraproject.org/pub/epel/6/x86_64/repoview/epel-release.html)

URLを確認したら、以下のようにrpmコマンドを実行します。yumリポジトリにEPELが追加されます。

```
$ sudo rpm -Uvh <epel-releaseパッケージのURL>
```

## 開発ツール類をインストール

```
$ sudo yum groupinstall "Development Tools"
```

## RubyとPassengerのビルドに必要なヘッダーファイルなどをインストール

```
$ sudo yum install openssl-devel readline-devel zlib-devel curl-devel libyaml-devel
```

## MySQLとヘッダーファイルをインストール

```
$ sudo yum install mysql-server mysql-devel
```

## Apacheとヘッダーファイルをインストール

```
$ sudo yum install httpd httpd-devel
```

## ImageMagickとヘッダーファイルをインストール

```
$ sudo yum install ImageMagick ImageMagick-devel
```

## Rubyをインストール

### ソースコードをダウンロード

以下のページからRubyのソースコードをダウンロードします。

* [ダウンロード - Ruby](http://www.ruby-lang.org/ja/downloads/)

wgetを使用してダウンロードします。

```
$ wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.zip
```

### ソースコードをビルド

```
$ unzip ruby-1.9.3-p194.zip
$ cd ruby-1.9.3-p194
$ ./configure
$ make
$ sudo make install
$ make clean
```
インストール後、rubyコマンドを実行してバージョンを表示することで、正しくインストールされたことを確認します。

```
$ ruby -v
ruby 1.9.3p194 (2012-04-20 revision 35410) [i686-linux]
```

### bundlerをインストール

Redmineが使用するGemを一括インストールするためのツール、bundlerをインストールします。

```
# gem install bundler --no-rdoc --no-ri
```

## MySQLを設定

### デフォルトキャラクターセットをutf8に設定

`/etc/my.cnf`を開きます。

```
$ sudo vi /etc/my.cnf
```

`[mysqld]`セクションに`character-set-server=utf8`を、`[mysql]`セクションに`default-character-set=utf8`を追記します。

```
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

character-set-server=utf8

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid

[mysql]
default-character-set=utf8
```

変更したら、MySQLを起動します。ついでに、OS再起動時にもMySQLが自動起動するように設定します。

```
$ sudo service mysqld start
$ sudo chkconfig mysqld on

$ chkconfig --list | grep mysqld
mysqld          0:off   1:off   2:on    3:on    4:on    5:on    6:off
```

`my.cnf`への設定が反映されていることを確認します。MySQLに接続して、`show variables like 'character_set%';`を実行します。表示された値のうち、`character_set_filesystem`と`character_sets_dir`以外の値が全てutf8に設定されていることを確認します。

```
$ mysql -u root
mysql> show variables like 'character_set%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8                       |
| character_set_connection | utf8                       |
| character_set_database   | utf8                       |
| character_set_filesystem | binary                     |
| character_set_results    | utf8                       |
| character_set_server     | utf8                       |
| character_set_system     | utf8                       |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
8 rows in set (0.00 sec)
```

## rootユーザーのパスワードを変更

```
mysql> set password for root@localhost=password('新しいrootのパスワード');
```

一度、MySQLをログアウトして、rootでログインし直してみます。パスワード無しではログインに失敗し、先ほど設定したパスワードだとログインできることを確認します。

```
$ mysql -u root
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)

$ mysql -u root -p
Enter password:
```

## 匿名ユーザーを削除

```
mysql> delete from mysql.user where user = '';
mysql> flush privileges;
```

### Redmine用のデータベース、ユーザーを作成

```
mysql> create database db_redmine default character set utf8;
mysql> grant all on db_redmine.* to user_redmine identified by 'user_redmineのパスワード';
mysql> flush privileges;
```

## Redmineをインストール

### Redmineをダウンロード

[RubyForge: Redmine: ファイルリスト](http://rubyforge.org/frs/?group_id=1850)からRedmineをダウンロードします。

```
$ wget http://rubyforge.org/frs/download.php/76497/redmine-2.1.2.zip
```

### Redmineを展開、配置

ダウンロードしたアーカイブを展開します。

```
$ unzip redmine-2.1.2.zip
```

展開したRedmineを配置先ディレクトリに移動します。ここでは、配置先を`/var/lib/redmine`として説明します。

```
$ sudo mv redmine-2.1.2 /var/lib/redmine
```

以降、Redmineの配置先ディレクトリを*$REDMINE_HOME*と表記します。

### データベース接続を設定

`$REDMINE_HOME/config/database.yml`を開きます。

```
$ vi /var/lib/redmine/config/database.yml
```

`database.yml`を以下のように作成します。同ディレクトリに`database.yml.example`があるので、設定の参考にしてください。

```
production:
  adapter: mysql2
  database: db_redmine
  host: localhost
  username: user_redmine
  password: MySQLのパスワード
  encoding: utf8
```

### メールサーバー接続を設定

`$REDMINE_HOME/config/configuration.yml`を開きます。

```
$ vi /var/lib/redmine/config/configuration.yml
```

以下のように作成します。同ディレクトリに`configuration.yml.example`があるので、設定の参考にしてください。

```
production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: "localhost"
      port: 25
      domain: 'example.com'
```

実際は、ご利用のメール環境に合わせて設定してください。また、`configuration.yml`には、アップロードされたファイルの保管場所、データベース暗号化などの設定があります。詳細は[configuration.ymlによるRedmineの設定](http://blog.redmine.jp/articles/configuration_yml/)をご覧ください。

> tips: GMailのSMTPサーバーを利用する場合の設定
> ```
> production:
>   email_delivery:
>     delivery_method: :smtp
>     smtp_settings:
>       enable_starttls_auto: true
>       address: "smtp.gmail.com"
>       port: 587
>       domain: "smtp.gmail.com"
>       authentication: :login
>       user_name: "your_email@gmail.com"
>       password: "your_password"
> ```

## Gemパッケージをインストール

bundlerを使用して、Redmineで使用するGemを一括でインストールします。*$REDMINE_HOME* で以下のコマンドを実行します。

```
# bundle install --without development test postgresql sqlite
```

## Redmineの初期設定とデータベースのテーブルを作成

セッションデータ暗号化用鍵の生成と、データベースのテーブルの作成を行います。*$REDMINE_HOME* で以下のコマンドを実行します。

```
# rake generate_secret_token
# RAILS_ENV=production rake db:migrate
```

## Passengerをインストール

```
# gem install passenger --no-rdoc --no-ri
```

## PassengerのApache用モジュールをインストール

```
# passenger-install-apache2-module
```

インストールが完了すると、Apacheに設定する内容が表示されます。以下の表示の`LoadModule`から`PassengerRuby`の行までを控えておきます。表示内容は、`passenger-install-apache2-module --snippet`で後から確認することができます。

```
The Apache 2 module was successfully installed.

Please edit your Apache configuration file, and add these lines:

   LoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.17/ext/apache2/mod_passenger.so
   PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.17
   PassengerRuby /usr/local/bin/ruby

After you restart Apache, you are ready to deploy any number of Ruby on Rails
applications on Apache, without any further Ruby on Rails-specific
configuration!
```

## Apacheを設定

### Passengerを設定

Passengerの設定をApacheに追加します。`httpd.conf`に直接追加すると紛らわしくなるので、別ファイルで設定します。`/etc/httpd/conf.d/passenger.conf`を先ほど表示された内容を使用して作成します。

```
LoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.17/ext/apache2/mod_passenger.so
PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.17
PassengerRuby /usr/local/bin/ruby
```

設定したら、Apacheを起動します。ついでに、OS起動時にApacheが自動起動するように設定します。

```
$ sudo service httpd start
$ sudo chkconfig httpd on

$ chkconfig --list | grep httpd
httpd           0:off   1:off   2:on    3:on    4:on    5:on    6:off
```

### ファイルオーナーを変更

Redmineの配置先ディレクトリのファイルを、Apacheを実行するユーザー・グループ(CentOSの場合は`apache`)で読み書きできるよう、ファイルオーナーを変更します。

```
$ sudo chown -R apache:apache /var/lib/redmine
```

### Redmine公開設定(サブディレクトリで公開)

ここでは、Redmineをサブディレクトリで公開する方法を説明します。

Apacheの公開ディレクトリに、*$REDMINE_HOME* に対するシンボリックリンクを作成します。シンボリックリンクの名前が、URLのディレクトリ名の部分になります。

```
$ sudo ln -s /var/lib/redmine/public /var/www/html/redmine
```

`passenger.conf`に以下の設定を追加します。

```
RackBaseURI /redmine
```

> tips: 説明元ページには`RailsBaseURI`と記述されていますが、自分の環境ではInternal Server Errorになりました。詳細は[Passenger error - PhusionPassenger::ClassicRails::ApplicationSpawner::Error](http://stackoverflow.com/questions/4430847/passenger-error-phusionpassengerclassicrailsapplicationspawnererror)をご覧ください。

Apache設定に間違いが無いことを確認し、再起動します。

```
$ service httpd configtest
Syntax OK
$ sudo service httpd graceful
```

以上で、Redmineを動作させる設定は完了です。

インストール後は、[Redmineを使い始めるための初期設定](http://redmine.jp/tech_note/first-step/admin/)を参考にして初期設定を行います。

さて、次回はいよいよJRuby+Redmineをセットアップします。まずはTomcat無しで直接起動してみる予定です。
