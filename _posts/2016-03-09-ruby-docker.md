---
layout: single
title: "DockerでRubyを使用する"
tags:
  - "Docker"
date: 2016-03-09 07:00:00+09:00
redirect_from:
  - /2016/03/ruby-docker.html
---

DockerコンテナにRubyをインストールしてみます。

## 確認したいこと

* DockerコンテナにRubyをインストールして、最低限の動作確認としてコンソールに文字列を表示すること。

## 前提条件

* VirtualBox
    * Windows、またはOS Xの場合。
    * `cinst virtualbox`(Windowsの場合)、`brew install virtualbox`(OS Xの場合)などでインストール可能です。
* Docker Machine
    * Windows、またはOS Xの場合。LinuxはDockerホスト環境が必要ないため、不要。
    * `cinst docker-machine`(Windowsの場合)、`brew install docker-machine`(OS Xの場合)などでインストール可能です。
* Docker Client
    * Linuxの場合。

## 確認手順

Windowsを前提に説明しますが、Docker Machineが使えるならどのOSでも大差ないはずです。

### Dockerホストを構築

Dockerホストを構築して、sshログインします。

```
$ docker-machine create --driver virtualbox default
$ docker-machine ssh
```

### Rubyコンテナーを構築、起動

Rubyをインストールしたコンテナーを構築、起動します。このコンテナーは、Ruby 2.3をインストールし、Rubyバージョン情報を表示します。

Dockerfileは作成済みなので、`git clone`します。

```
$ git clone https://github.com/u6k/ruby-docker.git
```

Dockerイメージを構築します。

```
$ cd ruby-docker/src/
$ docker build -t u6k/ruby-docker .
```

構築したDockerイメージをコンテナ起動します。Rubyバージョン情報が表示されます。

```
$ docker run u6k/ruby-docker
```

## おわりに

作成したソースコードは、次のリポジトリにあります。

- [u6k/ruby-docker](https://github.com/u6k/ruby-docker)
