---
layout: single
title: "This Week I Learned (from 2017-11-20 to 2017-11-26)"
tags:
  - "This Week I Learned"
date: 2017-11-26 23:50:00+09:00
---

今週、気になったニュースや自ソフトウェアのリリース情報を整理します。

## ニュース

- [Scala選定の理由と移行の方針 - Qiita](https://qiita.com/yuukiishikawa/items/95ad5a21514bffddb0bd)
    - 定期的にScala推しの記事が目に入るので、やっぱりScalaやろうかなという気になる。ただなぁ、ググラビリティ低いし黒魔術だし、うーん…
- [A Comprehensive Guide To Web Design — Smashing Magazine](https://www.smashingmagazine.com/2017/11/comprehensive-guide-web-design/)
    - Webデザインを網羅したガイド。大長編。
- [Algorithmiaのプラットホームにより企業が自分たちの機械学習モデルを管理しデプロイできる \| TechCrunch Japan](http://jp.techcrunch.com/2017/11/17/2017-11-16-algorithmia-now-helps-businesses-manage-and-deploy-their-machine-learning-models/)
    - 機械学習モデルの管理やデプロイと言われてもピンと来ない。ここら辺、もっと読み込んだり妄想すると楽しいかも。
- [組織設計を体系的に学ぶ - 「組織デザイン」を読んだ - $shibayu36->blog;](http://blog.shibayu36.org/entry/2017/11/20/193000)
    - 「組織はアーキテクチャに従う」という言葉もあるし、組織設計を学ぶことはシステム・デザインに繋がるかも。
- [Ask HN: Resources on how to improve abstract thinking skills? \| Hacker News](https://news.ycombinator.com/item?id=15740777)
    - 抽象的思考法をどうやって身に付けるか。いろいろ提案されていて興味深い。
- [なぜ git rebase をやめるべきか - Frasco](https://frasco.io/why-you-should-stop-using-git-rebase-535fa30d7e25)
    - どうもgit原理主義者の方々は難しく考えすぎている気がする。コミットの美しさを保つことに注力しすぎているというか。単純にマージで良いと思ってる。
- [リアクティブプログラミング超入門（1）：Chatwork、LINE、Netflixが進めるリアクティブシステムとは？　メリットは？　実現するためのライブラリは？ (1/2) - ＠IT](http://www.atmarkit.co.jp/ait/articles/1703/16/news023.html)
    - イベント駆動型プログラミングとあまり変わらない気がする。イベント・ループでイベントを捌くやつ。ただ、たぶんもっと拡張した概念なのだろうとは思う。
- [機械学習案件を納品するのは、そんなに簡単な話じゃないから気をつけて - Qiita](https://qiita.com/yoshizaki_kkgk/items/fa8b45918445bb3e6dc3)
- [機械学習案件は本運用乗せきってからが本当の勝負、みたいなところあるので気をつけて - Qiita](https://qiita.com/piyo7/items/59068fed6fb3e4b53174)
    - 貴重な落とし穴情報。機械学習案件は、これまでのいわゆるシステム開発とは異なる、契約・検収・保守の落とし穴があるかも。

## リリース情報

先週に引き続き、[task-focus](https://github.com/u6k/task-focus)の実装を進めています。ユーザー管理をSNS認証前提としたくてSpring Socialと戯れているけど、もはや泣きそう。もう先に進むために、普通のユーザー管理にしてしまおうかな…もっとSpring SecurityとSpring Socialの理解を深めてから、再チャレンジすることにしようか。
