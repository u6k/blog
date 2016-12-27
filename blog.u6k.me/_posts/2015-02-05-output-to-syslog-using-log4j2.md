---
layout: post
title: "Log4j2でsyslogに出力"
tags:
  - "Java"
  - "Log4j"
  - "Logging"
date: 2015-02-05 14:46:00+09:00
---

[Apache Log4j 2](http://logging.apache.org/log4j/2.x/)を使ってsyslogにログを出力する設定手順をメモします。

<!-- more -->

# 前提

- 作業環境はWindowsでEclipse+Maven 2です。Mavenが使えればOSやIDEは何でも良いです。
- 動作環境はRaspbianです。他のLinuxでも同様のはずです。

```bash
$ cat /etc/issue
Raspbian GNU/Linux 7 \n \l
```

```bash
$ java -version
java version "1.8.0"
Java(TM) SE Runtime Environment (build 1.8.0-b132)
Java HotSpot(TM) Client VM (build 25.0-b70, mixed mode)
```

# Log4j2を使えるように設定

プロジェクトを作成します。Eclipseで"Maven Project"を作成するか、`mvn archetype:create`を実行します。

"pom.xml"に依存関係を追加します。具体的なバージョンは、[Maven Repository: Search/Browse/Explore](http://mvnrepository.com/)で調べると良いです。

```xml:pom.xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.1</version>
</dependency>
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-api</artifactId>
    <version>2.1</version>
</dependency>
```

"/src/main/resources/log4j2.xml"を以下のように作成します。

```xml:log4j2.xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{yyy/MM/dd HH:mm:ss.SSS} %-5level - %msg%n" />
        </Console>
    </Appenders>
    <Loggers>
        <Root level="trace">
            <AppenderRef ref="console" />
        </Root>
    </Loggers>
</Configuration>
```

適当なjavaファイルを作成し、以下のように記述します。

```java
private static final Logger L = LogManager.getLogger(Main.class);

public static void main(String[] args) {
    L.info("info");
}
```

実行します。コンソールに以下のように出力されたら、設定は成功です。

```bash
2015/02/05 12:32:40.179 INFO  - info
```

# 514/udpでログを受信できるようにrsyslogを設定

Raspbianはrsyslogが動作していますが、udp・tcpともに受信できるように設定されていません。これを設定し、rsyslogを再起動します。

rsyslogの設定は"/etc/rsyslog.conf"にあるので、これを以下のように編集します。

```bash:rsyslog.conf(修正前)
# provides UDP syslog reception
#$ModLoad imudp
#$UDPServerRun 514

# provides TCP syslog reception
#$ModLoad imtcp
#$InputTCPServerRun 514
```

```bash:rsyslog.conf(修正後)
# provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514

# provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

rsyslogを再起動します。

```bash
$ sudo service rsyslog restart
```

"/var/log/syslog"を見て、エラーが出力されていなければ成功です。

# Log4j2からsyslogに出力するように設定

先ほどの"log4j2.xml"は標準出力にログを出力するように設定しました。ここに、syslogにも出力するように設定を追加します。

```xml:log4j2.xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
    <Appenders>
        <Console name="console" target="SYSTEM_OUT">
            <PatternLayout pattern="%d{yyy/MM/dd HH:mm:ss.SSS} %-5level - %msg%n" />
        </Console>
        <Syslog name="syslog" host="localhost" port="514" protocol="UDP" />
    </Appenders>
    <Loggers>
        <Root level="trace">
            <AppenderRef ref="console" />
            <AppenderRef ref="syslog" />
        </Root>
    </Loggers>
</Configuration>
```

実行します。コンソールに先ほどのように出力され、"/var/log/syslog"にも以下のように出力されていれば成功です。

```bash:syslog
Feb  5 12:14:29 localhost  raspberrypi info
```

出力されていない場合、以下の点が原因かもしれません。

- rsyslogが起動していない。
	- `chkconfig --list`などでrsyslogが起動しているか確認する。
- "rsyslog.conf"の設定が間違えている。
	- "/var/log/syslog"にエラーが出力されていないか確認する。
	- "rsyslog.conf"の設定を見直す。
- 514番ポートが他のアプリで使われてしまっている。
	- `netstat -an`などでポート番号の使用状況を確認する。
