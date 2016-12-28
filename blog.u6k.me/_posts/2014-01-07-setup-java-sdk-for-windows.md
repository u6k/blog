---
layout: post
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

![](http://3.bp.blogspot.com/-do98XkvpSOA/UstbKOuFDPI/AAAAAAAAAWY/urtSmepT66A/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.00.54_010714_100152_AM.jpg)

「Java SE Development Kit」というボックスがあり、ライセンスを許諾するか選択するチェックボックスがあります。問題無ければ「Accept License Agreement」をチェックします。

![](http://2.bp.blogspot.com/-rS-0RmttTeE/UstbKDSjz8I/AAAAAAAAAWU/miSZvrrg6oA/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.02.02_010714_100234_AM.jpg)

チェックすると、その下の各OSごとのダウンロードリンクが有効になります。Windowsへのインストールなので、「Windows x86」(32bitの場合)または「Windows x64」(64bitの場合)の右側のリンクをクリックします。インストーラーのダウンロードが始まります。

# 2. インストールする。

ダウンロードした`jdk-xxx-windows-yyy.exe`を実行すると、インストールが始まります。インストールは、JDKとJREの2個が実行されます。通常は設定を変更する必要はないので、「次へ」「閉じる」をクリックしていきます。

![](http://3.bp.blogspot.com/-ocjz7ei2ItM/Usqlnw9FA7I/AAAAAAAAAWA/dktYtLJYIHM/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.05.22.png)

![](http://1.bp.blogspot.com/-MsJKwaTD5vY/UsqlowK_YaI/AAAAAAAAAWA/-Ai_2kK27SQ/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.05.33.png)

![](http://3.bp.blogspot.com/--7dlDFzfc1c/UsqlpLqSuWI/AAAAAAAAAWA/tLxZfIuJPiY/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.05.38.png)

![](http://3.bp.blogspot.com/-iAnULNXZCyo/UsqlpSCmvQI/AAAAAAAAAWA/cjiOCvAaRO8/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.05.55.png)

![](http://4.bp.blogspot.com/-KxqKxwP_Pcs/Usqlpv8JjZI/AAAAAAAAAWA/HUgAqPQlpDY/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.06.00.png)

![](http://3.bp.blogspot.com/-EcGe80kL6tQ/UsqlqK9pv-I/AAAAAAAAAWA/jYKMyi2RbmE/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.06.05.png)

# 3. `JAVA_HOME`環境変数、`PATH`環境変数を設定する。

通常のソフトウェアとは違いこれだけでは終わらず、環境変数を設定する必要があります(設定しなくてもだいたい動作しますが)。

環境変数を設定するには、まず「コントロールパネル」→「システム」を開きます。

![](http://4.bp.blogspot.com/-PuZG198bK1Q/UstbKA8hihI/AAAAAAAAAW0/aEklD3Ob2C4/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.06.41_010714_100321_AM.jpg)

「システムの詳細設定」をクリックして、「システムのプロパティ」を開きます。

![](http://2.bp.blogspot.com/-jloFhIX11u8/UstbKuh5TgI/AAAAAAAAAWg/dy1GUG7iKuo/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.06.47_010714_101131_AM.jpg)

「詳細設定」タブの「環境変数」ボタンをクリックします。

![](http://1.bp.blogspot.com/-P7FSSZ4LKLs/UstbK2Xt1NI/AAAAAAAAAWo/uucYZLXrxD0/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.06.54_010714_101155_AM.jpg)

ユーザー環境変数側の「新規」ボタンをクリックします。

![](http://4.bp.blogspot.com/-sC_X48Yor_s/UstcpecLsFI/AAAAAAAAAXI/zsOAwWppTiU/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.07.10_010714_104712_AM.jpg)

「変数名」に`JAVA_HOME`、「変数値」にJava SDKをインストールしたフォルダのパスを設定します。

![](http://3.bp.blogspot.com/-whuJI3f1bHU/UsqlsQ3lD4I/AAAAAAAAAWA/BwfGsFx3DQM/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.07.52.png)

通常、Java SDKは`C:\Program Files\Java\jdkxxx`のようなフォルダにインストールされますので、エクスプローラで開いて確認します。設定したら「OK」をクリックします。

![](http://4.bp.blogspot.com/-MXhvXg-KOBs/UstbLSQAQzI/AAAAAAAAAWw/84DR-VSylfs/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588_2014-01-05_12.07.39_010714_101305_AM.jpg)

もう一度「新規」ボタンをクリックして、次は変数名`PATH`と変数値`%JAVA_HOME%\bin;`を設定します。

既に`PATH`環境変数が存在する場合は「編集」ボタンをクリックして、変数値の先頭に`%JAVA_HOME%\bin;`を追加します。

![](http://3.bp.blogspot.com/-0Z1NMY2qqYA/Usqlsnf_n3I/AAAAAAAAAWA/nqHfjcak3ak/s1600/%25E3%2582%25B9%25E3%2582%25AF%25E3%2583%25AA%25E3%2583%25BC%25E3%2583%25B3%25E3%2582%25B7%25E3%2583%25A7%25E3%2583%2583%25E3%2583%2588+2014-01-05+12.08.18.png)

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
