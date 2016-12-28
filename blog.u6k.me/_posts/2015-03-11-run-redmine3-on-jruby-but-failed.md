---
layout: post
title: "Redmine 3.0.0をJRubyで動かす→ダメだった…"
tags:
  - "Redmine"
date: 2015-03-11 22:00:00 +09:00
redirect_from:
  - /2015/03/redmine-300jruby.html
---

昔に[Redmineをwar化 (1) とりあえずRedmine+JRubyを動かす](http://u6k-apps.blogspot.jp/2012/10/redminewar-1-redminejruby.html)なんてことをやりましたが、[Redmine 3.0.0がリリースされた](http://redmine.jp/redmine_today/2015/02/redmine-3_0_0-released/)ということで、この最新バージョンでRedmine on JRubyを試してみました。

# 結論

途中で詰まってしまいました…

なので、この文書は「試したけどダメだったログ」になります。

<!-- more -->

# 前提

* Windows
	* Macでも問題ないはず。
* Vagrant
	* chef/centos-7.0を使用

# Vagrantを起動

`chef/centos-7.0`を使用するように、Vagrantを初期化・起動します。

```
>vagrant init chef/centos-7.0
>vagrant up
>vagrant ssh
```

`vagrant ssh`は、Windowsでは`ssh`コマンドがインストールされていないため失敗します。`Cygwin`などで`ssh`コマンドをインストールするか、任意のsshクライアント(TeraTermなど)を使用してください。

# 各種パッケージを更新、インストール

インストール済みソフトウェアを最新化します。

```
$ sudo yum -y update
```

開発パッケージ群をインストールします。

```
$ sudo yum -y groupinstall "Development tools"
```

Java SDKをインストールします。

```
$ sudo yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel
```

# JRubyをインストール

JRubyをインストールします。パッケージインストールではなく手動インストールします。

```
$ cd /usr/local/src/
$ sudo wget https://s3.amazonaws.com/jruby.org/downloads/9.0.0.0.pre1/jruby-bin-9.0.0.0.pre1.zip
$ sudo unzip jruby-bin-9.0.0.0.pre1.zip
$ sudo mv jruby-9.0.0.0.pre1/ ../lib/
$ sudo ln -s /usr/local/lib/jruby-9.0.0.0.pre1/bin/jruby.sh /usr/bin/jruby
$ cd
```

動作確認をします。

```
$ jruby -v
```

`bundler`をインストールします。

```
$ sudo jruby -S gem install bundler --no-rdoc --no-ri
```

# Redmineをダウンロード、展開

Redmineをダウンロード、展開します。

```
$ wget http://www.redmine.org/releases/redmine-3.0.0.zip
$ unzip redmine-3.0.0.zip
$ cd redmine-3.0.0
```

# Redmine設定を作成

データベース設定を作成します。

```
$ vi config/database.yml
```

SQLite3を使用するように作成します。

```
production:
  adapter: sqlite3
  database: db/production.sqlite3
```

共通設定を作成します。

```
$ vi config/configuration.yml
```

メールサーバーは使用しない、その他はデフォルト設定として作成します。

```
production:
```

# Gemパッケージをインストール

Redmineが使用するGemパッケージをインストールします。

```
$ jruby -S bundle install --without development test postgresql mysql
```

# データベース初期化

セッションデータ暗号化用鍵の生成を行います。

```
$ jruby -S rake generate_secret_token
```

エラーになってしまいました…

```
NOTE: ActiveRecord 4.2 is not (yet) fully supported by AR-JDBC, please help us finish 4.2 support - check http://bit.ly/jruby-42 for starters
```

# NOTE: ActiveRecord 4.2 is not (yet) fully supported by AR-JDBC

[http://bit.ly/jruby-42](http://bit.ly/jruby-42)にアクセスしましたが、正直良く分かりません…

[jruby/activerecord-jdbc-adapter](https://github.com/jruby/activerecord-jdbc-adapter)にアクセスすると、以下の文章を見つけました。

> Extending AR-JDBC
> You can create your own extension to AR-JDBC for a JDBC-based database that core AR-JDBC does not support. We've created an example project for the Intersystems Cache database that you can examine as a template. See the cachedb-adapter project for more information.

"core AR-JDBC does not support"と言われてしまっているので、とりあえずここまででギブアップします。


# おわりに

これが成功したら、次は1jarでRedmineを使用できるようにしたいなぁ。Dropwizardとかで。
