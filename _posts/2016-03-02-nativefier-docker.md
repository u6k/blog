---
layout: single
title: "nativefierをDockerコンテナー化する"
tags:
  - "Docker"
date: 2016-03-02 07:00:00+09:00
redirect_from:
  - /2016/03/nativefier-docker.html
---

nativefierを使いやすくするため、Dockerコンテナー化します。

## nativefierとは

WebページをElectronでラップしてデスクトップ・アプリケーション化するアプリです。

[jiahaog/nativefier: Wrap any web page natively without even thinking, across Windows, OSX and Linux](https://github.com/jiahaog/nativefier)

## なぜDockerコンテナー化するのか？

nativefierはNode.js(npm)を必要としますが、Node.jsが無い環境でも使用したいため、Dockerコンテナー化します。

(Dockerが入っているならNode.jsくらい入っているとは思いますが…)

## 使い方

ビルドしたイメージをDocker Hubで公開しています。以下のように実行できます。

```
docker run -v {出力先}:/mnt/dest u6kapps/nativefier {nativefierオプション} /mnt/dest
```

* `{出力先}`には、ローカルPCの出力先フォルダを指定します。
    * マウント先に`/mnt/dest`を指定していますが、`nativefier`がここに出力します。
* `{nativefierオプション}`には、nativefierに渡すオプションを列挙します。
    * `ENTRYPOINT`で`nativefier`を起動するため、指定したオプションが渡ります。
    * nativefierに渡すオプションは、[jiahaog/nativefier](https://github.com/jiahaog/nativefier)を確認すること。

例えば、Windows向けのGoogle Calendarアプリを出力する場合は、以下のように実行します。

```
docker run -v /c/Users/xxx/Downloads:/mnt/dest u6kapps/nativefier -n "Google Calendar" -p win32 --honest "https://calendar.google.com" /mnt/dest
```

## おわりに

作成したソースコードは、次のGitHubリポジトリにあります。

* [u6k/nativefier-docker](https://github.com/u6k/nativefier-docker)

Docker Hubでイメージを公開しています。

* [u6kapps/nativefier](https://hub.docker.com/r/u6kapps/nativefier/)

Windowsで実行する場合はDocker MachineでDockerホストを構築して、その中でコンテナー実行すると思いますが、共有フォルダに出力しないと消えるので、注意です。

`nativefier`がダウンロードしたElectronはコンテナー実行後に消えますので、毎回、ダウンロードされます。
