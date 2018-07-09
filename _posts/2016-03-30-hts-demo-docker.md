---
layout: single
title: "Open JTalkで使用する音響モデルを簡単に自作できるようになりたい"
tags:
  - "Open JTalk"
  - "音声合成"
date: 2016-03-30 07:00:00+09:00
redirect_from:
  - /2016/03/hts-demo-docker.html
---

以前から、人の音声を簡単にサンプリングして音声合成できないかな？　とは考えていました。例えば、声優のたまごのような人の音声を合成して、広く知ってもらえるようなサービスを作ったりできないかな、と考えていました。ただ、音声合成の元データの作り方が分かりませんでした。が、ふとそれっぽい記事を見かけたのでメモします。

## 参考リンク

* [音響モデルの作成 - MMDAgent & Project-NAIP wiki](http://cube370.wiki.fc2.com/wiki/%E9%9F%B3%E9%9F%BF%E3%83%A2%E3%83%87%E3%83%AB%E3%81%AE%E4%BD%9C%E6%88%90)
* [HTSの学習用データの作成 - MMDAgent & Project-NAIP wiki](http://cube370.wiki.fc2.com/wiki/HTS%E3%81%AE%E5%AD%A6%E7%BF%92%E7%94%A8%E3%83%87%E3%83%BC%E3%82%BF%E3%81%AE%E4%BD%9C%E6%88%90)
* [なんかいろいろしてみます HTS-demoによる自作音響モデルの作り方　その１](http://akihiro0105.blog55.fc2.com/blog-entry-12.html)
* [なんかいろいろしてみます HTS-demoによる自作音響モデルの作り方　その２](http://akihiro0105.blog55.fc2.com/blog-entry-13.html)
* [なんかいろいろしてみます HTSの話者適応学習のデモの動かし方](http://akihiro0105.blog55.fc2.com/blog-entry-107.html)
* [あらゆる現実をすべてねじ曲げて音響モデルを自作したいのでまずは資料集めから — Backstage of Backspace — Medium](https://medium.com/backstage-of-backspace/%E3%81%82%E3%82%89%E3%82%86%E3%82%8B%E7%8F%BE%E5%AE%9F%E3%82%92%E3%81%99%E3%81%B9%E3%81%A6%E3%81%AD%E3%81%98%E6%9B%B2%E3%81%92%E3%81%A6%E9%9F%B3%E9%9F%BF%E3%83%A2%E3%83%87%E3%83%AB%E3%82%92%E8%87%AA%E4%BD%9C%E3%81%97%E3%81%9F%E3%81%84%E3%81%AE%E3%81%A7%E3%81%BE%E3%81%9A%E3%81%AF%E8%B3%87%E6%96%99%E9%9B%86%E3%82%81%E3%81%8B%E3%82%89-2f1a7721db5e#.odeuwqhph)

HTS-demoというソフトウェアを使うと、Open JTalkで音声合成する元データである音響モデルというものを作成できるようです。ただ、HTS-demoを動作させることが非常に難しいように見えます。これを簡単に使用できるようにするため、Dockerイメージとアプリケーションを作成してみたいと考えています。

## おわりに

GitHubリポジトリで作業しています。

* [u6k/hts-demo-docker: 音響モデル作成ソフトウェアをDockerイメージで提供します。](https://github.com/u6k/hts-demo-docker)
