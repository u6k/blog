---
title: "Redmineをwar化 (1) とりあえずRedmine+JRubyを動かす"
tags: ["Redmine", "Setup", "JRuby", "redmine-war"]
date: 2012-10-12 21:34:00+09:00
published: false
parmalink: "redminewar-1-redminejruby"
postID: 2419468321490200772
---

Redmineのセットアップは面倒！　でも、JRubyでwarblerを使うとwar化できる！　というわけで、Redmineを簡単セットアップできるように、war化したいと思います。とりあえずJRuby+Redmineを動作させます。

<!-- more -->

# 前提

以下の環境で作業しました。

* Windows 7 64bit
* Java SDK 1.6.0_34
    * SDKじゃなくてもいいはず。
* JRuby 1.7.0 RC 2

# 作業手順

基本的にはRedmine 2.1を[CentOS 6.3にインストールする手順 | Redmine.JP Blog](http://blog.redmine.jp/articles/redmine-2_1-installation_centos/)に沿って進めます。ただし、Linux特有の手順や不必要な手順は実施しません。

## bundlerをインストール

Redmineが使用するGemを一括インストールするためのツール、bundlerをインストールします。

```
>jgem install bundler --no-rdoc --no-ri
```

## Redmineをダウンロード、展開

Redmineを[RubyForge: Redmine: ファイルリスト](http://rubyforge.org/frs/?group_id=1850)からダウンロードします。

ダウンロードした`redmine-2.1.2.zip`を展開します。以降、Redmineを展開したフォルダを`%REDMINE_HOME%`と表記します。

## Redmineを設定

### データベース接続を設定

今回は簡単セットアップを意識して、データベースはSQLite3を使用します。`%REDMINE_HOME%\config\database.yml`を以下のように作成します。

```
production:
  adapter: sqlite3
  database: db/production.sqlite3
```

### メールサーバー接続を設定

とりあえずメールサーバーを使用しない設定とします。`%REDMINE_HOME%\config\configuration.yml`を以下のように作成します。

```
production:
```

添付ファイルのアップロード先フォルダなどその他の設定もデフォルトとします。

### Gemパッケージをインストール

bundlerを使用してGemパッケージをインストールします。`%REDMINE_HOME%`で以下のコマンドを実行します。

```
>bundle install --without development test postgresql mysql
```

今回はデータベースにSQLiteを使用するため、`--without`に`mysql`を指定しています。

### Redmineの初期設定、およびデータベースのテーブルを作成

セッションデータ暗号化用鍵の生成と、データベースのテーブルの作成を行います。`%REDMINE_HOME%`で以下のコマンドを実行します。

```
>rake generate_secret_token
>SET RAILS_ENV=production
>rake db:migrate
```

以上で設定は完了です。

## いよいよRedmineを起動

`%REDMINE_HOME%`で以下のコマンドを実行します。

```
>jruby script/rails server webrick -e production
```

正しく起動できたら、以下のように表示されます。

```
>jruby script/rails server webrick -e production
=> Booting WEBrick
=> Rails 3.2.8 application starting in production on http://0.0.0.0:3000
=> Call with -d to detach
=> Ctrl-C to shutdown server
D:/temp/redmine/lib/redmine.rb:26 warning: already initialized constant FCSV
[2012-10-11 18:46:17] INFO  WEBrick 1.3.1
[2012-10-11 18:46:17] INFO  ruby 1.9.3 (2012-10-09) [java]
[2012-10-11 18:46:17] INFO  WEBrick::HTTPServer#start: pid=27448 port=3000
```

Webブラウザで[](http://localhost:3000/)にアクセスします。

![](http://4.bp.blogspot.com/-yGfZdHVBwck/UHaPq6BRn8I/AAAAAAAAADI/vfrYd3w1Mak/s1600/001.png)

ちゃんと表示されました！　この後、ユーザー作成、チケット作成、ファイルアップロードを行いましたが、ちゃんと動作しました！　Yeah!

今回はとりあえずここまで。
