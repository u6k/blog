---
layout: single
title: "Android端末でブログを書く"
tags:
  - "jekyll"
  - "git"
date: 2017-07-20
---

ようやくできました。Android端末でブログを書いています。簡単に説明。

## 何がしたかった？

昨年まで、Bloggerでブログを公開していましたが、GitHubでMarkdown書式の記事ファイルを管理しているのに、いちいちBloggerに投稿しないといけなかったことが不便でした。なので、Jekyllに移行してDockerコンテナ化して動作させています。この経緯や構成やビルド手順は、別の記事で説明します。

ただ、これでもまだPCで記事ファイルを作成する必要がありました。もっとお手軽に記事を書きたい！

## どうしたか？

Android端末にMGitとMarkdownエディターをインストールしました。エディターはいくつか入れましたが、この記事はとりあえずJotterPadで書いています。

記事ファイルを作成して `git push` すると、CircleCIでDockerイメージがビルドされて、Docker HubにPushされて、Dockerコンテナが再起動されることで記事が公開されます。

## というわけで

思い付きやTILやらを手軽に書いてみようと思います。
