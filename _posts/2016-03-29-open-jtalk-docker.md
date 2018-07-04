---
layout: single
title: "Open JTalkで音声合成したい"
tags:
  - "Open JTalk"
  - "音声合成"
date: 2016-03-29 07:00:00+09:00
redirect_from:
  - /2016/03/open-jtalk-docker.html
---

はるか昔、Webページを音声で読み上げたいと考え、[Androidアプリの作成を試みました](http://blog.u6k.me/2012/10/webvoicecaster.html)。この後、すぐに類似アプリを見つけてしまい、それがビミョーに使いづらかったため計画が停止してしまっていましたが、なんとなく再開しました。

当時はPocketに貯めた記事を読み上げたいと考えていましたが、現在はWeb小説を読み上げたいと考えています。最近、Web小説にハマっているので。

当時はAndroidアプリ内で完結したかったので[N2 TTS](http://www.kddilabs.jp/products/audio/n2tts/product.html)を使いましたが、今回はOpen JTalkを使ってみたいと考えています。とりあえず[GitHubにプロジェクトを作成して](https://github.com/u6k/open_jtalk-docker)、Dockerコンテナーを構築しようと作業しています。

## リンク

* GitHub
    * [u6k/open_jtalk-docker: Open JTalkをDockerコンテナーで動作させます。](https://github.com/u6k/open_jtalk-docker)
* Docker Hub
    * [u6kapps/open_jtalk](https://hub.docker.com/r/u6kapps/open_jtalk/)
    * [u6kapps/open-jtalk-api](https://hub.docker.com/r/u6kapps/open-jtalk-api/)
* Redmine
    * [open_jtalk-docker](https://myredmine-u6kapps.rhcloud.com/projects/openjtalk-docker)
