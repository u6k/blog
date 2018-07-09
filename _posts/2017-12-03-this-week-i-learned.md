---
layout: single
title: "This Week I Learned (from 2017-11-27 to 2017-12-03)"
tags:
  - "This Week I Learned"
date: 2017-12-03 23:50:00+09:00
---

今週、気になったニュースや自ソフトウェアのリリース情報を整理します。

## ニュース

- [My approach to using Git, without the headaches – Hacker Noon](https://hackernoon.com/my-approach-to-using-git-without-the-headaches-6926df5af0c7)
    - git原理主義者の方々は、少々厳格すぎる気がしている。普通にマージで良いよ。
    - コミットがキレイに並ぶという履歴の美しさには確かに惹かれるけど、そこまで重要とは思えない。
- [「トラックナンバー」という言葉をご存知でしょうか？ (フェンリル \| デベロッパーズブログ)](https://blog.fenrir-inc.com/jp/2013/02/trucknumber.html)
    - 「ハネムーンナンバー」という言葉を調べていて「トラックナンバー」という言葉に行き当たった。物騒すぎる。
- [Scaled Agile Framework – SAFe for Lean Software and System Engineering](http://jp4.scaledagileframework.com/)
- [Scaling Agile – a Real Story](https://www.infoq.com/articles/making-scaling-agile-work-1)
- [Scaling Agile - Slice and Understand Together](https://www.infoq.com/articles/making-scaling-agile-work-2)
- [tucaz/agile-development-cheat-sheet](https://github.com/tucaz/agile-development-cheat-sheet/blob/master/README.md)
    - アジャイルについて調べていて。
- [Ask HN: How to get a Scala graduate position? \| Hacker News](https://news.ycombinator.com/item?id=15777514)
    - うーん、Scalaか…
- [超優秀なプレイヤーは「出世」という名の転職をさせてはいけない \| @_Nat Zone](https://www.sakimura.org/2017/11/4048/)
    - 技術者と経営幹部では求められる素養や技術が別であり、職種として別だから、「出世」ではなく「転職だよね」という話。
- [Full-stack smart contract development – Hacker Noon](https://hackernoon.com/full-stack-smart-contract-development-fccdfe5176ce)
    - Ethereum Virtual Machine上で動作する分散型アプリケーションを作成する入門記事。
- [AWSの新サービス群に対する一行所感 - プログラマでありたい](http://blog.takuros.net/entry/2017/11/30/111342)
    - 怒涛の勢い。ここまで色々揃うと、AWSにロックインされてもいいかなという気になってしまう。錯覚だけど。
- [ICONIXプロセスのロバストネス分析をastah*でやってみたお話 - hiro(iskwa)'s blog](http://hiroi.hateblo.jp/entry/2017/12/01/123036)
    - リレーションシップ駆動要件分析(RDRA)とICONIXプロセスで、ふわっとした要求から実装まで一気通貫したモデリングができそう。
    - 個人的にも、この作業パターンを追求してみようと思う。
- [ID生成大全 - Qiita](https://qiita.com/kawasima/items/6b0f47a60c9cb5ffb5c4)
    - 個人的には、業務的に意味があるキーがない場合はUUID v4一択だと思っているけど、頑なに連番キーが欲しい人がいて困る。いやそれ、絶対に連番になる保証あるの？それに意味はあるの？
- [Androidアプリ開発で取り返しがつかないことまとめ - Qiita](https://qiita.com/ryo_mm2d/items/6da55b7801863562e7b3)
    - スマホ・アプリのように寿命が長くアップデートを制御できないプラットフォームは怖い。
- [Don't use In-Memory Databases (like H2) for Tests](https://blog.philipphauer.de/dont-use-in-memory-databases-tests-h2/)
    - もはやDockerで手軽に本番同等環境をローカルPCに構築できるし、そう考えるとH2 Databaseを使う必要は確かに無いと思った。
    - 自分が持ってるボイラープレートと作業手順はH2 Databaseを使うように書いたけど、これもやめよう。

## リリース情報

うーん、進まない…いや、ちょっと興味深い仕事が入ってきてて。あと、task-focusをドッグフーディングしているけど、BASIC認証だとAndroid版Chromeが頻繁に認証を求めてきてうざいので、使うのをやめてしまいました。やはり普通のユーザー認証で良いからさっさと実装しよう。
