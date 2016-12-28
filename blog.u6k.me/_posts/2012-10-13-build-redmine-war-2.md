---
layout: post
title: "Redmineをwar化 (2) warblerでwar化する"
tags:
  - "Redmine"
  - "Setup"
  - "JRuby"
  - "redmine-war"
date: 2012-10-13 00:33:00+09:00
redirect_from:
  - /2012/10/redminewar-2-warblerwar.html
---

[前回](http://u6k-apps.blogspot.jp/2012/10/redminewar-1-redminejruby.html)、Redmine+JRubyを動かすところまで作業を行いました。次はこの環境をwar化して、Apache TomcatなどのServletコンテナーに簡単に配置できるようにします。

<!-- more -->

## 作成したwarファイル

前回・今回の作業で作成したファイルは、以下で配布しています。

* [u6kapps / redmine-war / Downloads](https://bitbucket.org/u6kapps/redmine-war/downloads)
    * `redmine-yyyymmdd-for-2.1.2.war`というファイルです。

# ライセンス

[GNU General Public License v2](http://www.gnu.org/licenses/gpl-2.0.html)とします。[JRubyがCPL v1.0/GPL v2/LGPL v2.1](https://github.com/jruby/jruby/blob/master/COPYING)、[RedmineがGPL v2](http://www.redmine.org/)であるためです。

# war化する作業手順

Railsアプリをwar化するwarblerというgemがありますので、これを使用します。

## warblerをインストール

以下のコマンドを実行して、warblerをインストールします。

```
>jgem install warbler
```

## warbler設定ファイルを作成

どのファイルをwarファイルに含めるか、どのgemを含めるかなどを指定する、warbler設定ファイルを作成します。

まず、`%REDMINE_HOME%`で以下のコマンドを実行して、warbler設定ファイルの雛形を生成します。

```
>warble config
```

`%REDMINE_HOME%\config\warble.rb`が作成されます。開くと色々書かれていますが、dbフォルダ、filesフォルダ、pluginsフォルダをwarファイルに含めるため、`config.dirs`に`db files plugins`を追記します。

```
config.dirs = %w(app config lib log vendor tmp db files plugins)
```

## war化

`%REDMINE_HOME%`で以下のコマンドを実行して、warファイルを生成します。

```
>warble
```

`%REDMINE_HOME%\redmine.war`ファイルが生成されます。

## Tomcatにredmine.warを配置 - 失敗

warファイルを作成したので、これをTomcatに配置します。なお、Tomcatはあらかじめ起動できる状態にしておいてください。

起動したら、[](http://localhost:8080/redmine/)にアクセスします。問題なければ、Redmineのトップページが表示されるはずです。

![](http://1.bp.blogspot.com/-iCBPPkQQbZE/UHgdxCQuH2I/AAAAAAAAABM/ir5qvK_sEoE/s1600/001.PNG)

Oh...エラーになってしまいました。Tomcatのコンソールを確認すると、以下のように表示されていました。

```
[31mCould not find jdbc-mysql-5.1.13 in any of the sources [0m
[33mRun `bundle install` to install missing gems. [0m
```

何か文字が化けていますが、jdbc-mysqlのgemが足りないと言われています。今回はsqlite3を使用するのでmysqlは関係ないのですが…

## もう一度、bundlerを実行、warファイルを作成

mysql(とついでにpostgresql)のgemを含めるため、以下のコマンドを実行します。

```
>bundle install --without development test
```

前回は`mysql`と`postgresql`を`--without`で指定しましたが、その指定を無くしました。

これでgemの問題は解決したはずなので、以下のコマンドでwarファイルを生成します。

```
>warble
```

## Tomcatにredmine.warを配置 - 成功

生成した`redmine.war`をTomcatに配置して、再度、[](http://localhost:8080/redmine/)にアクセスします。

![](http://1.bp.blogspot.com/-DMlkgktvSRM/UHghmyqiS1I/AAAAAAAAABk/vFkJRqYqqrc/s1600/002.PNG)

Redmineのトップページが表示されました！　この後、以下の作業を行いましたが、問題なく動作しました。

* 設定を日本語環境に変更
* `test`ユーザーを作成
* `admin`ユーザーをロック
* プロジェクトを作成
* チケットを作成、添付ファイルつき

![](http://3.bp.blogspot.com/-ub_peMoNTME/UHgjpEFoQyI/AAAAAAAAAB4/y4trSfATa-E/s1600/003.PNG)

# CentOSにファイルを移動、Tomcatで動作

次に、先ほど作成した`redmine.war`をCentOSに移動し、CentOS上のTomcatに配置、動作させてみます。また、動作確認したファイルも動作確認します。これにより、OS関係なくServletコンテナーがあれば動作することを確認します。

なお、CentOSはあらかじめ以下のように設定してください。

* Java SDKをインストール
* 8080番ポートを開放(またはiptablesを無効化)
* Apache Tomcatが動作することを確認

## CentOS上のTomcatに`redmine.war`を配置

Tomcatにwarファイルを配置します。

![](http://1.bp.blogspot.com/-uHxHtmK5vKU/UHgxrvV-7pI/AAAAAAAAACY/fpaUaWFFkCs/s1600/991.PNG)

`/redmine`が初期状態のRedmine、`/redmine_test`が動作確認したRedmineです。

まず、/redmineにアクセスしてみます。

![](http://1.bp.blogspot.com/-DMlkgktvSRM/UHghmyqiS1I/AAAAAAAAABk/vFkJRqYqqrc/s1600/002.PNG)

Redmineのトップページが表示されました。

次に、`/redmine_test`にアクセスしてみます。

![](http://3.bp.blogspot.com/-KGgtD1fWrZQ/UHgxroU2hcI/AAAAAAAAACU/Bd6Fy5fXdo0/s1600/002.PNG)

Redmineのトップページが表示され、登録したプロジェクトが表示されています。

![](http://3.bp.blogspot.com/-ub_peMoNTME/UHgjpEFoQyI/AAAAAAAAAB4/y4trSfATa-E/s1600/003.PNG)

登録したチケットも表示できました。

チケットの登録ができることも確認します。

![](http://4.bp.blogspot.com/-bsXX1sbviW0/UHgywWyVaNI/AAAAAAAAACw/nhVMQd4AAeg/s1600/003.PNG)

チケットが登録できました。

これで、Tomcatに展開するだけで使用可能なRedmineを作成できました！　Yeah!
