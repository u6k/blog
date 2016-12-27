---
layout: post
title: "Spring Bootアプリケーションのバージョン情報を外部から確認したい"
tags:
  - "Spring Boot"
  - "Java"
date: 2016-01-26 07:00:00+09:00
---

動作しているSpring Bootアプリのバージョンが何かを外部から確認したい場合がありますが、infoエンドポイントで簡単にバージョン情報などを返すことができます。

今回のサンプルコードは[u6k/sample-display-version](https://github.com/u6k/sample-display-version)にあります。

<!-- more -->

## infoエンドポイントにアクセスしてみる

spring-boot-actuatorを有効化しただけの状態でinfoエンドポイントにアクセスすると、`200 OK`が返ってはきますが、ボディは空JSONになります。

```
$ curl -v http://localhost:8080/info
> GET /info HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.45.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: Apache-Coyote/1.1
< X-Application-Context: application
< Content-Type: application/json;charset=UTF-8
< Transfer-Encoding: chunked
< Date: Mon, 25 Jan 2016 08:21:37 GMT
<
{}
```

## 設定ファイルにinfoで返す値を記載する

infoエンドポイントで返す値は、`application.properties`に`info.`で始まるプロパティを記述することで設定できます。`maven-resources-plugin`で`pom.xml`のプロパティで`application.properties`を置換することで、アプリ名やバージョン情報をinfoエンドポイントで返すことが出来ます。

`application.properties`に以下を記載します。

```
info.name=${project.artifactId}
info.version=${project.version}
```

先程と同様にinfoエンドポイントにアクセスすると、今度はアプリ名とバージョン情報が返ることが確認できます。

```
$ curl -v http://localhost:8080/info
> GET /info HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.45.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: Apache-Coyote/1.1
< X-Application-Context: application
< Content-Type: application/json;charset=UTF-8
< Transfer-Encoding: chunked
< Date: Mon, 25 Jan 2016 08:26:15 GMT
<
{"name":"sample-display-version","version":"1.0-SNAPSHOT"}
```
