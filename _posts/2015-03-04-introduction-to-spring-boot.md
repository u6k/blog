---
layout: single
title: Spring Boot入門
tags:
  - "Spring Boot"
date: 2015-03-06 20:00:00+09:00
redirect_from:
  - /2015/03/spring-boot.html
---

[以前](http://u6k-apps.blogspot.jp/2015/02/dropwizard.html)、Dropwizard入門を書きましたが、Dropwizardの関連情報がちょっと少なすぎて、Spring Bootの方が良いんじゃないかなと思い始めました。

というわけで、Spring Bootを使用してみようと、ハローワールド的アプリを作成してみます。

## Spring Bootとは

ココらへんを参照。

- [Spring Bootで高速アプリ開発 ｜ Developers.IO](http://dev.classmethod.jp/server-side/java/springboot/)
- [Spring Boot 入門 TECHSCORE BLOG](http://www.techscore.com/blog/2014/05/01/spring-boot-introduction/)
- [Spring BootによるWebアプリお手軽構築 - Taste of Tech Topics](http://acro-engineer.hatenablog.com/entry/2014/06/03/120128)
- [Spring Boot Reference Guide](http://docs.spring.io/spring-boot/docs/1.2.2.RELEASE/reference/htmlsingle/)

## 前提

- Java 8系
- Maven 3系

## Mavenプロジェクトを作成

`mvn`でプロジェクトを作成します。

```
$ mvn -B archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=jp.gr.java_conf.u6k.sample_spring_boot -DartifactId=sample-spring-boot
```

コンパイル確認、Eclipseプロジェクト作成を行います。

```
$ cd sample-spring-boot
$ mvn compile
$ mvn eclipse:eclipse
```

`.gitignore`を作成します。

```
/target/
.project
.classpath
```

`pom.xml`を修正します。

```
<?xml version="1.0" encoding="UTF-8"?>
<project
    xmlns="http://maven.apache.org/POM/4.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>jp.gr.java_conf.u6k.sample_spring_boot</groupId>
    <artifactId>sample-spring-boot</artifactId>
    <packaging>jar</packaging>
    <version>0.1.0-SNAPSHOT</version>
    <name>sample-spring-boot</name>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.2.2.RELEASE</version>
    </parent>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <configuration>
                    <mainClass>jp.gr.java_conf.u6k.sample_spring_boot.App</mainClass>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

## 文字列を返すだけのアプリを作成

`App.java`を修正します。

```
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@EnableAutoConfiguration
public class App {

    @RequestMapping("/")
    @ResponseBody
    public String home() {
        return "Hello, sample-spring-boot!";
    }

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}
```

## ビルド

パッケージングします。

```
$ mvn clean package
```

## 実行

実行します。

```
>java -jar target/sample-spring-boot-0.1.0-SNAPSHOT.jar
```

[http://localhost:8080/](http://localhost:8080/)にアクセスして、以下のレスポンスが返ることを確認します。

```
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Content-Type: text/html;charset=UTF-8
Content-Length: 26
Date: Wed, 04 Mar 2015 10:58:46 GMT

Hello, sample-spring-boot!
```

## 停止

`Ctrl + C`で停止します。

## おわりに

Dropwizardに比べて手順が少ない、Springの知識が生かせる、ということでDropwizardよりSpring Bootの方が良いかなー、と思っています。

## ソースコード

- [u6k/sample-spring-boot at 0.1.0](https://github.com/u6k/sample-spring-boot/tree/0.1.0)
