---
title: "Snappy Ubuntu Core on VirtualBoxでDockerを動かしてみる"
tags: ["Docker"]
date: 2016-03-11 07:00:00+09:00
published: false
parmalink: "docker-on-snappy-ubuntu-core-on-virtualbox"
postID: 5125429155898956351
---

Raspberry PiでDockerを動かしたい、となるとOSはSnappy Ubuntu Coreになります([Docker Pirates ARMed with explosive stuff](http://blog.hypriot.com/)というのもありますが)。Snappy Ubuntu Coreは触ったことがないので、お試しとしてVirtualBox(Vagrant)上のSnappy Ubuntu CoreでDockerを動かしてみます。

<!-- more -->

# 確認したいこと

* VagrantでSnappy Ubuntu Coreを動作させます。
* Snappy Ubuntu Core上でDockerfileをビルドします。
* Dockerイメージを実行します。

今回は簡単な動作確認なので、GitHubリポジトリは作成していません。

# 前提条件

* Surface Pro 4 + Windows 10
    * VirtualBox(Vagrant)が使えれば、他OSでも問題無いはずです。
* VirtualBox + Vagrant
    * VirtualBoxはVagrantで操作します。

# 確認手順

## Snappy Ubuntu Coreを起動する

`ubuntu/ubuntu-15.04-snappy-core-stable`というVagrant boxが使えますので、これを起動します。

```
vagrant init ubuntu/ubuntu-15.04-snappy-core-stable
vagrant up
vagrant ssh
```

今回はWebDMを使わないので、ポート・フォワード設定は行いません。WebDMを使う場合は、4200番ポートをフォワードすれば、ホストOSのWebブラウザからWebDMを使うことができます。

## Dockerをインストールする

Snappy Ubuntu Coreは`snappy`コマンドでパッケージを操作します。

Dockerのパッケージを`snappy`コマンドで探します。

```
$ snappy search docker
Name             Version   Summary
matrix.mectors   0.0.11    matrix
go-ether.mectors 0.0.3     go-ether
docker           1.6.2.005 Docker
```

ちょっと古いですが、ありました(記事執筆時点のDocker最新バージョンはv1.10.2)。これをインストールします。

```
$ sudo snappy install docker
$ docker -v
Docker version 1.6.2, build 8f2d6e5
```

## Dockerイメージをビルドする

Dockerイメージの元となるDockerfileを以下のように作成します([u6k/ruby-docker](https://github.com/u6k/ruby-docker)から)。

```
FROM ubuntu:latest
MAINTAINER u6k <u6k.apps@gmail.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential git wget

RUN wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz && \
    tar zxvf ruby-2.3.0.tar.gz && \
    cd ruby-2.3.0/ && \
    ./configure && \
    make && \
    make install

CMD [ "ruby", "-v" ]
```

これをビルドしてみます。

```
$ docker build -t u6k/ruby-docker .
FATA[0000] Error checking context is accessible: 'can't stat '.''. Please check permissions and try again.
```

エラーになってしまいました…調べたところ、標準入力から流し込むことでビルドできることが分かりました。

```
$ cat Dockerfile | docker build -t u6kapps/ruby-docker -
$ docker images
REPOSITORY            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
u6kapps/ruby-docker   latest              16480b7d9129        4 minutes ago       841 MB
ubuntu                latest              56063ad57855        6 days ago          188 MB
```

イメージがビルドされました。

## Dockerコンテナーを実行する

ビルドしたイメージを実行してみます。

```
$ docker run u6kapps/ruby-docker
ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-linux]
```

普通に実行できました。

# おわりに

というわけで、自宅RaspberryPiでSnappy Ubuntu Coreを動作させるようになったら、

1. Snappy Ubuntu Core on QEMU(ARM)でDockerイメージをビルド
1. Docker Hubにアップ
1. Snappy Ubuntu Core on RPi3でDockerコンテナーを実行

という流れにしようかなと妄想中。
