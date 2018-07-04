---
layout: single
title: "Redmineをwar化 (3) Tomcat上で動作させる"
tags:
  - "Apache Tomcat"
  - "Redmine"
  - "redmine-war"
  - "Setup"
date: 2012-10-16 18:06:00+09:00
redirect_from:
  - /2012/10/redminewar-3-tomcat.html
---

[前回](http://u6k-apps.blogspot.jp/2012/10/redminewar-2-warblerwar.html)、Redmine+JRubyをwar化しました。その過程でTomcat上で動作確認を行いましたが、その手順を詳細に説明します。

なお、ページ下部からTomcat同梱版のRedmine-warをダウンロードできます。

## 前提

以下の環境で作業しました。

* Windows 7 64bit
    * 32bitでも問題ありません。
* Java SDK 1.6.0_34
    * Java SDK 1.6か1.7をあらかじめインストールしてください。
    * `JAVA_HOME`環境変数を設定してください。

## Tomcat上で動作させる手順

### Tomcatをセットアップ

Tomcatをダウンロードするため、[Apache Tomcat](http://tomcat.apache.org/)にアクセスします。

![](/assets/img/2012-10-16-build-redmine-war-3/001.png)

左メニューにTomcatのバージョンがいくつか並んでいますが、現時点の最新を使用するため、Downloadの`Tomcat 7.0`をクリックします。

![](/assets/img/2012-10-16-build-redmine-war-3/002.png)

いくつかリンクがありますが、[Binary Distributions]→[Core]→[zip]をクリックして、Tomcatのzipファイルをダウンロードします。このzipファイルを適当な場所で展開すれば、Tomcatのセットアップは終わりです。以降、展開先を`%CATALINA_HOME%`と表記します。

### redmine-warをセットアップ

セットアップと言っても、やることは簡単で、`redmine.war`を`%CATALINA_HOME%\webapps`にコピーするだけです。

> **note:** warファイルの名前がURLのパスとなるため、`redmine.war`の場合は[](http://localhost:8080/redmine/)にアクセスすることになります。例えば[](http://localhost:8080/bts/)としたい場合、`bts.war`にリネームします。

### Tomcatを起動、Redmineにアクセス

`%CATALINA_HOME%\bin\startup.bat`(Linuxの場合は`startup.sh`)を実行します。初回はwarファイルの展開に時間がかかります(1～3分程度)。以下のように、コマンドプロンプトに"Server startup"と表示されたら、起動完了です。

```
2012/10/16 18:55:25 org.apache.catalina.startup.Catalina start
情報: Server startup in 69189 ms
```

Webブラウザで[](http://localhost:8080/redmine/)にアクセスします。

![](/assets/img/2012-10-16-build-redmine-war-3/003.png)

Redmineのトップページが表示されたら成功です! Yeah!

> **note:** 例えばWindowsの場合、`startup.bat`を実行してコマンドプロンプトが一瞬だけ表示されて消えてしまう場合、Tomcatの起動に失敗しています。原因は様々考えられますが、まずはログを見ます。ログは`%CATALINA_HOME%\logs`に出力されます。Tomcatが標準出力に出力するログは、`catalina.yyyy-mm-dd.log`に出力されます(`yyyy-mm-dd`はログ出力年月日)。これを開いてエラーを見ます(Java例外の読み方に関する知識が必要になります)。よくあるエラーは、以下のように"Address already in use"と表示されるものです。
```
致命的: Failed to initialize end point associated with ProtocolHandler ["http-bio-8080"]
java.net.BindException: Address already in use: JVM_Bind <null>:8080
 at org.apache.tomcat.util.net.JIoEndpoint.bind(JIoEndpoint.java:406)
 at org.apache.tomcat.util.net.AbstractEndpoint.init(AbstractEndpoint.java:610)
 at org.apache.coyote.AbstractProtocol.init(AbstractProtocol.java:429)
 at org.apache.coyote.http11.AbstractHttp11JsseProtocol.init(AbstractHttp11JsseProtocol.java:119)
 at org.apache.catalina.connector.Connector.initInternal(Connector.java:981)
 at org.apache.catalina.util.LifecycleBase.init(LifecycleBase.java:102)
 at org.apache.catalina.core.StandardService.initInternal(StandardService.java:559)
 at org.apache.catalina.util.LifecycleBase.init(LifecycleBase.java:102)
 at org.apache.catalina.core.StandardServer.initInternal(StandardServer.java:814)
 at org.apache.catalina.util.LifecycleBase.init(LifecycleBase.java:102)
 at org.apache.catalina.startup.Catalina.load(Catalina.java:633)
 at org.apache.catalina.startup.Catalina.load(Catalina.java:658)
 at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:39)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:25)
 at java.lang.reflect.Method.invoke(Method.java:597)
 at org.apache.catalina.startup.Bootstrap.load(Bootstrap.java:281)
 at org.apache.catalina.startup.Bootstrap.main(Bootstrap.java:450)
```
> 上記は「8080番ポートが既に使用されている」というもので、OSにインストールされている何らかのミドルウェアが8080番ポートを使用済みということを表しています。この場合、Tomcatのポート番号を変更することで、エラーを解消することができます。
>
> Tomcatのポート番号は、`%CATALINA_HOME%\conf\server.xml`に記述されていますので、これを開きます(XMLの知識が必要になります)。テキストを、既に使用済みと言われてしまった"8080"で検索すると、以下のような記述が見つかります。
```
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443" />
```
> この`port="8080"`という記述がポート番号の設定ですので、例えば`port="18080"`のように修正します。修正が終わったら、再び`startup.bat`を実行して、Tomcatの起動を試みます。
>
> なお、Tomcatは複数のポート番号を使用するため(8005, 8009, 8080)、何回か設定の変更が必要になるかもしれません。

## Tomcat同梱版Redmine-war

上記のようなセットアップを行うのも面倒なので、Tomcatを同梱したRedmine-warを作成しました。以下のページからダウンロードできます。

* [u6k-apps / redmine-war / Downloads - Bitbucket](https://bitbucket.org/u6kapps/redmine-war/downloads)
    * `redmine-war-yyyymmdd-for-2.1.2-with-tomcat.zip`というファイルです。

使い方は簡単で、ダウンロードして展開して`startup.bat`を実行するだけです。[](http://localhost:8080/redmine/)でアクセスできます。

ファイルの内容は、上記の手順でセットアップした内容に加え、以下を行いました。

* `webapps`内の余分なファイルを削除。
* `bin`内の`*.sh`ファイルに実行権限を付与。
* `redmine.war`を`webapps`に展開済み。
