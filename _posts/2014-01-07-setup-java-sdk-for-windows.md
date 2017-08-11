---
layout: single
title: "WindowsにJava SDKをセットアップする"
tags:
  - "Java"
  - "Setup"
date: 2014-01-07 19:00:00+09:00
redirect_from:
  - /2014/01/windowsjava-sdk.html
---

たまにJava SDKのセットアップ手順を説明する機会があるので、せっかくなので記しておきます。やることは難しくなく、

1. インストーラーをダウンロードする。
2. インストールする。
3. `JAVA_HOME`環境変数、`PATH`環境変数を設定する。
4. 簡単に動作確認を行う。

です。

<!-- more -->

# 1. インストーラーをダウンロードする。

[http://www.oracle.com/technetwork/java/javase/downloads/index.html](http://www.oracle.com/technetwork/java/javase/downloads/index.html)を開きます。

ページ中程の「JDK」という文字の近くにあるDOWNLOADボタンをクリックします。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/001.jpg)

「Java SE Development Kit」というボックスがあり、ライセンスを許諾するか選択するチェックボックスがあります。問題無ければ「Accept License Agreement」をチェックします。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/002.jpg)

チェックすると、その下の各OSごとのダウンロードリンクが有効になります。Windowsへのインストールなので、「Windows x86」(32bitの場合)または「Windows x64」(64bitの場合)の右側のリンクをクリックします。インストーラーのダウンロードが始まります。

# 2. インストールする。

ダウンロードした`jdk-xxx-windows-yyy.exe`を実行すると、インストールが始まります。インストールは、JDKとJREの2個が実行されます。通常は設定を変更する必要はないので、「次へ」「閉じる」をクリックしていきます。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/003.png)

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/004.png)

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/005.png)

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/006.png)

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/007.png)

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/008.png)

# 3. `JAVA_HOME`環境変数、`PATH`環境変数を設定する。

通常のソフトウェアとは違いこれだけでは終わらず、環境変数を設定する必要があります(設定しなくてもだいたい動作しますが)。

環境変数を設定するには、まず「コントロールパネル」→「システム」を開きます。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/009.jpg)

「システムの詳細設定」をクリックして、「システムのプロパティ」を開きます。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/010.jpg)

「詳細設定」タブの「環境変数」ボタンをクリックします。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/011.jpg)

ユーザー環境変数側の「新規」ボタンをクリックします。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/012.jpg)

「変数名」に`JAVA_HOME`、「変数値」にJava SDKをインストールしたフォルダのパスを設定します。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/013.png)

通常、Java SDKは`C:\Program Files\Java\jdkxxx`のようなフォルダにインストールされますので、エクスプローラで開いて確認します。設定したら「OK」をクリックします。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/014.jpg)

もう一度「新規」ボタンをクリックして、次は変数名`PATH`と変数値`%JAVA_HOME%\bin;`を設定します。

既に`PATH`環境変数が存在する場合は「編集」ボタンをクリックして、変数値の先頭に`%JAVA_HOME%\bin;`を追加します。

![](/assets/img/2014-01-07-setup-java-sdk-for-windows/015.png)

セットアップはこれで終わりです。

# 4. 簡単に動作確認を行う。

正常にセットアップできたことを簡単に確認します。コマンドプロンプトを開いて、`java -version`、`javac -version`コマンドを実行します。

```
C:\Users\xxx>java -version
java version "1.7.0_45"

Java(TM) SE Runtime Environment (build 1.7.0_45-b18)

Java HotSpot(TM) 64-Bit Server VM (build 24.45-b08, mixed mode)

C:\Users\xxx>javac -version
javac 1.7.0_45
```

セットアップしたバージョンが表示されればOKです。

異なるバージョンが表示されたり、`javac`コマンドがエラーとなった場合、別バージョンのJavaがインストールされていたり、環境変数の設定が失敗している可能性が高いです。
