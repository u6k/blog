---
title: "Scala学習のため、DockerでScala動作確認環境を構築しました"
tags: ["Scala", "Docker"]
date: 2016-07-15 07:00:00+09:00
published: false
parmalink: "hello-scala-docker"
postID:
---

長い間、主にJavaを使ってきましたが、もっと軽く簡単にコードを書けないかなと思い、重い腰を上げて新しい言語を学ぼうと考えました。以前に少し調べたPlayFrameworkがScalaを扱えることを思い出し、他言語も合わせて考えてみましたが、Scalaを学習対象にしました。学習するために動作確認環境が必要となるため、動作確認環境を構築しました。

<!-- more -->

# 前提

Scalaとは

簡単に環境の再現ができるDocker上に構築する

普通はsbtを使うと思うが、最終的にはPlayFrameworkでWebアプリケーションを作成したいので、Typesafe Activatorを使用する。

CoreOS環境で作業をしたが、Dockerが動作すればホストOSは問わないはず。

# できあがる環境

JavaSDK 8

Typesafe Activator v1.3.10

Scala 2.11.7

vim

# 環境構築手順

## Dockerfileを作成

[Dockerfile](https://github.com/u6k/scala-docker/blob/v1.0.0/Dockerfile)を作成します。

```
FROM java:8
MAINTAINER u6k.apps@gmail.com

RUN mkdir -p /usr/local/src/
WORKDIR /usr/local/src/

RUN curl -OL https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip && \
    unzip typesafe-activator-1.3.10-minimal.zip && \
    mkdir -p /opt/ && \
    mv activator-1.3.10-minimal/ /opt/activator && \
    chmod a+x /opt/activator/bin/activator && \
    ln -s /opt/activator/bin/activator /usr/local/bin/activator

WORKDIR /root/

RUN activator new my-app minimal-scala && \
    cd my-app/ && \
    activator run && \
    cd .. && \
    rm -rf my-app/

CMD ["/bin/bash"]
```

内容を説明します。

```
FROM java:8
```

ScalaはJavaVM環境で動作するため、ベースイメージに指定します。

```
RUN mkdir -p /usr/local/src/
WORKDIR /usr/local/src/
```

ソフトウェアのインストールを`/usr/local/src/`で行うため、ディレクトリを作成して、作業ディレクトリを移動します。

```
RUN curl -OL https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip && \
    unzip typesafe-activator-1.3.10-minimal.zip && \
    mkdir -p /opt/ && \
    mv activator-1.3.10-minimal/ /opt/activator && \
    chmod a+x /opt/activator/bin/activator && \
    ln -s /opt/activator/bin/activator /usr/local/bin/activator
```

Typesafe Activatorをセットアップします。Typesafe Activatorはzipで配布されているため、ダウンロード、展開、`/usr/local/bin/`にシンボリック・リンクを作成します。

```
WORKDIR /root/
```

Dockerコンテナに入った時に`/root/`を作業ディレクトリとしたいので、作業ディレクトリを指定します。

```
RUN activator new my-app minimal-scala && \
    cd my-app/ && \
    activator run && \
    cd .. && \
    rm -rf my-app/
```

`activator`コマンドは、初回起動時に必要リソースを取得するため、時間がかかります。そこで、Dockerイメージ構築時にいくつかのコマンドを実行して、リソースをキャッシュしておきます。ここでは、`minimal-scala`プロジェクトを作成して、実行しています。作成したプロジェクトは実行後は不要なので、削除します。

```
CMD ["/bin/bash"]
```

`docker run`で`bash`を実行してコンテナに入りたいので、指定します。

## docker-compose.ymlを作成

単純に`docker build`→`dockdr run`しても良いです。

https://github.com/u6k/scala-docker/blob/v1.0.0/docker-compose.yml

```
version: '2'

services:
  scala-app:
    build: .
```

単純にビルドするだけです。Dockerコンテナ内で作業したファイルを残したい場合は、`volumes`を指定すると良いです。

```
    volumes:
      - .:/root/work/
```

## Dockerイメージ���築

```
docker-compose build
```

# 使い方 - ScalaでHello, world!

```
docker-compose run scala-app
```

Dockerコンテナを起動して、コンテナ内に入ります。

```
activator new my-app minimal-scala
```

`minimal-scala`プロジェクトを作成します。

```
cd my-app/src/main/scala/
rm -r com/
vi hello.scala
```

ソースコードは`${PROJECT}/src/main/scala/`以下に書くので、移動します。サンプルコードがあるので、削除します。`hello.scala`ファイルを以下のように作成します。

```
object Main {
  def main(args:Array[String]):Unit = {
    println("hello")
  }
}
```

プロジェクトのルート・ディレクトリに戻って、実行します。

```
cd ../../../
activator run
```

`hello`が表示され、正常終了するはずです。

# リンク

GitHub

Redmine
