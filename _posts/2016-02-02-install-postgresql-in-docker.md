---
layout: single
title: "Dockerコンテナ(ubuntu)にPostgreSQLをインストールする"
tags:
  - "Docker"
date: 2016-02-02 07:00:00+09:00
redirect_from:
  - /2016/02/ubuntu-postgresql.html
---

PostgreSQLが動作するDockerコンテナー(ubuntu:latest)を、勉強のために自作してみます。

## 確認したいこと

* DockerコンテナにPostgreSQLをインストールして、最低限の動作確認としてpsqlで接続すること。

## 前提条件

* Windowsを前提に説明しますが、Docker Machineが使えるならどのOSでも大差ないはずです。
* VirtualBox
    * Windows、またはOS Xの場合。
    * `cinst virtualbox`(Windowsの場合)、`brew install virtualbox`(OS Xの場合)などでインストール可能です。
* Docker Machine
    * Windows、またはOS Xの場合。LinuxはDockerホスト構築が必要ないため、不要。
    * `cinst docker-machine`(Windowsの場合)、`brew install docker-machine`(OS Xの場合)などでインストール可能です。
* Docker Client
    * Linuxの場合。

## Dockerホストを構築。

Dockerホストを構築して、sshログインします。

```
$ docker-machine create --driver virtualbox test
$ docker-machine ssh test
```

## PostgreSQLサーバー・コンテナーを構築、起動

PostgreSQLサーバーをインストールしたコンテナーを構築、起動します。このコンテナーは、5432番ポートを開放し、外部ホストからの接続を許可し、`docker`というユーザーとデータベースを構築済み、という状態にします。

Dockerfileは作成済みなので、`git clone`します。

```
$ git clone https://github.com/u6k/ubuntu-postgresql.git
```

PostgreSQLサーバーのDockerイメージを構築します。

```
$ cd ubuntu-postgresql/src/server/
$ docker build -t u6k/postgresql-server .
```

構築したDockerイメージをコンテナ起動します。

```
$ docker run --name postgresql-server -d u6k/postgresql-server
```

`--name`引数で、コンテナに名前を付けます。`-d`引数で、デーモンとして起動します。`-d`を付けないと、コンテナ起動後にプロンプトが戻ってこなくなります(`Ctrl+c`でコンテナを終了させる必要あり)。

## PostgreSQLクライアント・コンテナーを構築、起動

上記でサーバーを起動できましたが、このままでは接続確認ができません。接続確認用に、PostgreSQLクライアントをインストールしたコンテナーを構築、起動します。

サーバー構築時に`git clone`したリポジトリにPostgreSQLクライアント・コンテナのDockerfileも作成済みなので、Dockerイメージを構築します。

```
$ cd ../client/
$ docker build -t u6k/postgresql-client .
```

構築したDockerイメージをコンテナ起動します。

```
$ docker run --link postgresql-server:psql -it u6k/postgresql-client bash
```

`--link`引数で、`postgresql-server`という名前のコンテナと連携します。これにより、エイリアス指定した名前(ここでは`psql`)で、接続情報の環境変数が設定されます。後ほど、何が設定されるか確認してみます。`-it`でコンテナの標準入力を開いて、操作を可能にします。最後の`bash`で、シェルに`/bin/bash`を使います。

コンテナに入ったら、`--link`引数により設定された環境変数を確認してみます。

```
# env | grep PSQL
PSQL_NAME=/tiny_wilson/psql
PSQL_PORT_5432_TCP=tcp://172.17.0.2:5432
PSQL_PORT=tcp://172.17.0.2:5432
PSQL_PORT_5432_TCP_PORT=5432
PSQL_PORT_5432_TCP_ADDR=172.17.0.2
PSQL_PORT_5432_TCP_PROTO=tcp
```

`PSQL_`というプリフィックスの環境変数がいくつか設定されていることが分かります。これらの環境変数を使用することで、PostgreSQLサーバー・コンテナに接続しやすくなります。

psqlでPostgreSQLサーバーに接続を試みます。

```
# psql -h $PSQL_PORT_5432_TCP_ADDR -U docker
Password for user docker:
psql (9.3.10)
SSL connection (cipher: DHE-RSA-AES256-GCM-SHA384, bits: 256)
Type "help" for help.

docker=#
```

接続が成功しました。

## 再度、起動する場合

PostgreSQLサーバー・コンテナを上記の手順で再度起動しようとすると、以下のようにエラーとなります。

```
$ docker run --name postgresql-server -d u6k/postgresql-server
Error response from daemon: Conflict. The name "postgresql-server" is already in use by container 09892e5fa33e. You have to remove (or rename) that container to be able to reuse that name.
```

これは、`postgresql-server`という名前のコンテナが(停止状態で)残っており衝突しているので、削除するかリネームすることでその名前を使用できる、ということを言っています。

以下の手順で、停止状態のコンテナを一括削除できます。

```
$ docker rm $(docker ps -aq)
```

## 参照

* [u6k/ubuntu-postgresql](https://github.com/u6k/ubuntu-postgresql)
