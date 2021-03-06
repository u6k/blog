---
layout: single
title: "Dockerコンテナ(ubuntu)にoracle-java8をインストールする"
tags:
  - "Docker"
  - "Java"
date: 2016-01-29 07:00:00+09:00
redirect_from:
  - /2016/01/ubuntu-oracle-java8.html
---

2016/1/29現在では、Ubuntuにapt-getでoracle-java8を単純にインストールすることができないようです。この記事では、Dockerコンテナ(ubuntu:latest)にoracle-java8をインストールして、最低限の動作確認としてバージョン情報を表示してみます。Dockerはあまり関係なく、本質はUbuntuにoracle-java8をインストールすることですけど。

## 前提

* Windowsを前提で説明しますが、OS Xでもほぼ同様の手順になるはずです。Linuxの場合、Dockerホストを構築する手順が異なります。
* VirtualBox
    * Windows、またはOS Xの場合。
    * `cinst virtualbox`(Windowsの場合)、`brew install virtualbox`(OS Xの場合)などでインストール可能です。
* Docker Machine
    * Windows、またはOS Xの場合。LinuxはDockerホスト構築が必要ないため、不要。
    * `cinst docker-machine`(Windowsの場合)、`brew install docker-machine`(OS Xの場合)などでインストール可能です。
* Docker Engine
    * Linuxの場合。

## Dockerホストを構築

Windowsでは単純にDockerを使用することができないため、Docker MachineでVirtualBox上にDockerホストを構築します。

```
$ docker-machine create --driver virtualbox test
```

Dockerホストにsshログインします。

```
$ docker-machine ssh test
```

## Dockerイメージを構築

Dockerホスト内で、Dockerfileをダウンロードします。このDockerfileは、ubuntu:latestをベースイメージとしてoracle-java8をインストールします。

```
$ git clone https://github.com/u6k/ubuntu-oracle-java8.git
```

Dockerイメージを構築します。かなり時間がかかります。

```
$ docker build -t u6k/ubuntu-oracle-java8 .
```

イメージ一覧を表示して、構築したイメージが含まれていることを確認します。

```
$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
u6k/ubuntu-oracle-java8   latest              2008f3ea987b        24 hours ago        815.6 MB
ubuntu                    latest              6cc0fc2a5ee3        8 days ago          187.9 MB
```

## Dockerコンテナを実行

構築したイメージを実行します。成功すると、Javaバージョン情報が表示されます。

```
$ docker run u6k/ubuntu-oracle-java8
java version "1.8.0_72"
Java(TM) SE Runtime Environment (build 1.8.0_72-b15)
Java HotSpot(TM) 64-Bit Server VM (build 25.72-b15, mixed mode)
```

## おわりに

作成したソースコードは、次のリポジトリにあります。

* [u6k/ubuntu-oracle-java8](https://github.com/u6k/ubuntu-oracle-java8)
