---
layout: single
title: "Scala学習のため、DockerでScala動作確認環境を構築しました"
tags:
  - "Scala"
  - "Docker"
date: 2016-07-18 07:00:00+09:00
redirect_from:
  - /2016/07/hello-scala-docker.html
---

長い間、主にJavaを使ってきましたが、もっと軽く簡単にコードを書けないかなと思い、重い腰を上げて新しい言語を学ぼうと考えました。以前に少し調べたPlayFrameworkがScalaを扱えることを思い出し、他言語も合わせて考えてみましたが、Scalaを学習対象にしました。学習するために動作確認環境が必要となるため、動作確認環境を構築しました。

## 前提

Scalaについては、以下のページを参照してください。

* [Scala - Wikipedia](https://ja.wikipedia.org/wiki/Scala)
* [スケーラブルで関数型でオブジェクト指向なScala入門](http://www.atmarkit.co.jp/fjava/index/index_scala.html)

Scala環境の構築や破棄が簡単にできるように、Docker上に構築します。あわせてDocker Composeも使用します。このため、Linuxの基本的な操作方法を理解している必要があります。

Scalaアプリケーションの実行には、通常はsbtを使うと思いますが、最終的にPlayFrameworkでWebアプリケーションを作成したいので、Typesafe Activatorを使用します。

作業はCoreOS環境で行いましたが、Dockerが動作すればホストOSは問わないはずです。

## Scala環境構築手順

Scala環境を構築する手順を説明します。

### Dockerfileを作成

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

ScalaはJavaVM環境で動作するため、ベースイメージに`java`を指定します。

```
FROM java:8
```

ソフトウェアのインストールを`/usr/local/src/`で行うため、ディレクトリを作成して、作業ディレクトリを移動します。

```
RUN mkdir -p /usr/local/src/
WORKDIR /usr/local/src/
```

Typesafe Activatorをセットアップします。

```
RUN curl -OL https://downloads.typesafe.com/typesafe-activator/1.3.10/typesafe-activator-1.3.10-minimal.zip && \
    unzip typesafe-activator-1.3.10-minimal.zip && \
    mkdir -p /opt/ && \
    mv activator-1.3.10-minimal/ /opt/activator && \
    chmod a+x /opt/activator/bin/activator && \
    ln -s /opt/activator/bin/activator /usr/local/bin/activator
```

Typesafe Activatorはzipで配布されているため、ダウンロードして展開することでセットアップを行います。それだけだとパスが通らないので、`/usr/local/bin/`にシンボリック・リンクを作成します。

Dockerコンテナに入った時に`/root/`を作業ディレクトリとしたいので、作業ディレクトリを指定します。

```
WORKDIR /root/
```

`activator`コマンドを実行して、依存ライブラリをキャッシュします。

```
RUN activator new my-app minimal-scala && \
    cd my-app/ && \
    activator run && \
    cd .. && \
    rm -rf my-app/
```

`activator`コマンドは、初回起動時に必要リソースを取得するため、時間がかかります。そこで、Dockerイメージ構築時にいくつかのコマンドを実行して、リソースをキャッシュしておきます。ここでは、`minimal-scala`プロジェクトを作成して、実行しています。作成したプロジェクトは実行後は不要なので、削除します。

`docker run`で`bash`を実行してコンテナに入れるようにします。

```
CMD ["/bin/bash"]
```

### docker-compose.ymlを作成

単純に`docker build`->`dockdr run`しても良いのですが、後を考えて[docker-compose.yml](https://github.com/u6k/scala-docker/blob/v1.0.0/docker-compose.yml)を作成します。

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

### Dockerイメージ構築

ビルドします。

```
docker-compose build
```

## 使い方 - ScalaでHello, world!

Dockerコンテナを起動して、コンテナ内に入ります。

```
docker-compose run scala-app
```

`minimal-scala`プロジェクトを作成します。

```
activator new my-app minimal-scala
```

ソースコードを作成します。

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

## おわりに

まずは単純に"Hello, world!"したかっただけなので、簡素な環境を構築しました。開発ツールが不足しているので充実させつつ、RDBと連携できるように育てます。
