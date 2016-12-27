---
title: "Open JTalkで音声合成してみた"
tags: ["Open JTalk", "音声合成"]
date: 2016-04-01 07:00:00+09:00
published: false
parmalink: "open-jtalk-docker-0.6.1"
postID: 8782434029996016090
---

Open JTalkを簡単に使用できるDockerfileを構築したので、内容を説明します。

<!-- more -->

[Open JTalkで音声合成したい](http://blog.u6k.me/2016/03/open-jtalk-docker.html)の続きです。

# 使い方

発声させる文字列を標準入力から受け取り、生成した音声wavデータを標準出力に出力します。Docker Hubで公開しているため、以下のように実行できます。

```
echo こんにちは | docker run -i --rm u6kapps/open_jtalk > hello.wav
```

詳細な使い方については、[open_jtalk-docker/docker/open_jtalk](https://github.com/u6k/open_jtalk-docker/tree/master/docker/open_jtalk)をご覧ください。

# 構築スクリプトの説明

使い方、ライセンスなど使用者のための情報は、[open_jtalk-docker/docker/open_jtalk](https://github.com/u6k/open_jtalk-docker/tree/master/docker/open_jtalk)で説明しています。この記事では、面倒くさいOpen JTalkの構築を自動化したスクリプトの内容について説明します。

## Dockerfile

[Dockerfile](https://github.com/u6k/open_jtalk-docker/blob/master/docker/open_jtalk/Dockerfile)の内容について説明します。

```
FROM ubuntu:latest
MAINTAINER u6k <u6k.apps@gmail.com>
```

Ubuntuイメージをベースに使用します。最近だとAlpine Linuxをベースとすることでファイル・サイズを小さくすることがあるみたいですが、とりあえずUbuntu。また、`u6k.apps@gmail.com`を作成者として記述しています。

```
RUN apt-get update && \
    apt-get install -y wget git build-essential
```

Open JTalkのビルドに必要となるソフトウェアをインストールします。

* `wget`…ファイルをダウンロードするため。いずれ、`curl`に書き換えた方が良いと思っています。
* `git`…ソースコードをダウンロードするため。
* `build-essential`…コンパイル作業に関連するソフトウェア。

```
WORKDIR /usr/local/src/
```

ソフトウェアのダウンロードやコンパイルなどを`/usr/local/src/`で行うため、作業ディレクトリを移動します。

```
RUN wget http://downloads.sourceforge.net/hts-engine/hts_engine_API-1.10.tar.gz && \
    tar zxvf hts_engine_API-1.10.tar.gz && \
    cd hts_engine_API-1.10/ && \
    ./configure && \
    make && \
    make install
```

hts_engine_APIをダウンロードして、セットアップします。普通に`configure`、`make`、`make install`しているだけです。

```
COPY manobi.patch manobi.patch
```

Open JTalkをそのままビルドすると、場合によって音声が間延びしてしまうという問題があるため、パッチを当てる必要があります。そのパッチ・ファイルを取り込みます。

```
RUN wget http://downloads.sourceforge.net/open-jtalk/open_jtalk-1.09.tar.gz && \
    tar zxvf open_jtalk-1.09.tar.gz && \
    cd open_jtalk-1.09/ && \
    patch -p0 < /usr/local/src/manobi.patch && \
    ./configure --with-hts-engine-header-path=/usr/local/include --with-hts-engine-library-path=/usr/local/lib --with-charset=UTF-8 && \
    make && \
    make install
```

Open JTalkをダウンロードして、セットアップします。セットアップ前に`patch`でパッチを当てます。

```
RUN wget http://downloads.sourceforge.net/open-jtalk/hts_voice_nitech_jp_atr503_m001-1.05.tar.gz && \
    tar zxvf hts_voice_nitech_jp_atr503_m001-1.05.tar.gz && \
    cp -r hts_voice_nitech_jp_atr503_m001-1.05 /usr/local/lib/hts_voice_nitech_jp_atr503_m001-1.05
```

Open JTalkによる音声合成で使用する音響モデルをダウンロードして、展開します。ディレクトリ名をそのままにしていますが、分かりやすくした方が良かったかも。

```
RUN wget http://downloads.sourceforge.net/open-jtalk/open_jtalk_dic_utf_8-1.09.tar.gz && \
    tar zxvf open_jtalk_dic_utf_8-1.09.tar.gz && \
    cp -r open_jtalk_dic_utf_8-1.09 /usr/local/lib/open_jtalk_dic_utf_8-1.09
```

Open JTalkによる音声合成で使用する辞書をダウンロードして、展開します。ディレクトリ名をそのままにしていますが、分かりやすくした方が良かったかも。

```
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
```

スクリプトを取り込み、実行権限を付与して、Docker起動時に実行するように指定します。少し躓いた点として、WindowsのDocker Machineでは`chmod`を実行しなくてもスクリプトが実行できましたが、Docker HubやLinuxホストでDockerビルドした場合はPermission deniedになってしまいました。

## entrypoint.sh

[entrypoint.sh](https://github.com/u6k/open_jtalk-docker/blob/0.6.1/5116/update-version/docker/open_jtalk/entrypoint.sh)について説明します。

```
#!/bin/sh
```

お約束。

```
if [ -z "$OPEN_JTALK_VOICE_FILE" ]; then
  OPEN_JTALK_VOICE_FILE=/usr/local/lib/hts_voice_nitech_jp_atr503_m001-1.05/nitech_jp_atr503_m001.htsvoice
fi

if [ -z "$OPEN_JTALK_DIC_DIR" ]; then
  OPEN_JTALK_DIC_DIR=/usr/local/lib/open_jtalk_dic_utf_8-1.09
fi

if [ -z "$OPEN_JTALK_OPTIONS" ]; then
  OPEN_JTALK_OPTIONS="-s 48000 -p 240"
fi
```

環境変数の有無を調べ、無い場合はデフォルト値を設定します。これらの環境変数は、Open JTalkの起動に使用します。

```
OUTPUT_FILE=`mktemp`
```

Open JTalkの音声ファイルの出力先を`mktemp`で作成します。

```
echo open_jtalk -m $OPEN_JTALK_VOICE_FILE -x $OPEN_JTALK_DIC_DIR -ow $OUTPUT_FILE $OPEN_JTALK_OPTIONS >&2
open_jtalk -m $OPEN_JTALK_VOICE_FILE -x $OPEN_JTALK_DIC_DIR -ow $OUTPUT_FILE $OPEN_JTALK_OPTIONS
```

`open_jtalk`を実行して、音声ファイルを生成します。入力ファイルを指定していないため、標準入力からテキストを取得します。この場合は、`docker`に対する標準入力からテキストを取得します。

```
cat $OUTPUT_FILE
```

`open_jtalk`が出力した音声ファイルを標準出力に出力しています。結果、`docker`の実行結果として標準出力に音声ファイルの内容が出力されます。

# おわりに

とりあえず、簡単にOpen JTalkを使用できるDockerイメージを構築しました。他に、MMDAgentの音響ファイルを入れたり、WebAPIとしてOpen JTalkを使用したかったり、やりたいことはいくつかあるので作業を続行します。

# リンク

* GitHub
    * [u6k/open_jtalk-docker: Open JTalkをDockerコンテナーで動作させます。](https://github.com/u6k/open_jtalk-docker)
* Docker Hub
    * [u6kapps/open_jtalk](https://hub.docker.com/r/u6kapps/open_jtalk/)
    * [u6kapps/open-jtalk-api](https://hub.docker.com/r/u6kapps/open-jtalk-api/)
* Redmine
    * [open_jtalk-docker](https://myredmine-u6kapps.rhcloud.com/projects/openjtalk-docker)
