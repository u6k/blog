---
layout: single
title: "This Week I Learned (from 2017-11-13 to 2017-11-19)"
tags:
  - "This Week I Learned"
date: 2017-11-19 23:50:00+09:00
---

今週、気になったニュースや自ソフトウェアのリリース情報を整理します。

# ニュース

- [頭を空にする以上の仕事術はないということ \| Lifehacking.jp](http://lifehacking.jp/2017/11/mind-like-water/)
    - GTDのプロセスの中でも、「まずINBOXに投入する」「INBOXを整理する」が強力だと思う。結果的にタスクがあふれたりするけど、それを現実として受け止めるところがスタートかな。
- [危うい「プロセス指向」が廃れない理由: 設計者の発言](http://watanabek.cocolog-nifty.com/blog/2017/11/post-cc6d.html)
    - データ構造を中心に設計すること。強く同意する。
    - ただ、「クラス構造がどのように構想されるかというと～(中略)～開発者の創造的洞察にまかされる」についてはあまり同意できない。いや、事実としてそういう場合が多いということは経験的に分かるけど、ICONIXやドメイン駆動設計やユースケース分析ではオブジェクト構造を中心に決めると認識している。ここら辺、ちゃんと整理してみたい。
- [【目次】Python scikit-learnの機械学習アルゴリズムチートシートを全実装・解説](http://neuro-educator.com/mlcontentstalbe/)
    - すっごく参考になる。「機械学習アルゴリズムを学びたい」と言われたときの目次にしよう。
    - というか、自分も素振りしてみよう。
- [IT・Web系各社の新卒エンジニア研修記事をまとめてみた - 音楽的でテクノロジー的なブログ](http://keeponrockin.hatenablog.com/entry/2017/11/15/204553)
    - これも参考になる。スキル・セットやレベルによって研修内容が変わるけど、自分のテンプレートとして取り込んでおきたい。
- [イマドキWebフロントエンド環境とReactを触りながらサンプルを10本書いてみた - Qiita](https://qiita.com/akimach/items/af3ba7841bcb789b75a5)
    - ここ数年、CIサーバーやらDockerやら触っていて、フロントエンドを置き去りにしてしまっているので、素振りしよう。
- [Research Blog: SLING: A Natural Language Frame Semantic Parser](https://research.googleblog.com/2017/11/sling-natural-language-frame-semantic.html)
    - 自然言語文章を解析して、単語に意味ラベルを付けるパーサー、っぽい。
    - 写真中のオブジェクトにラベルを付けるツールの、文章版かな？興味深い。
- [750台のRaspberry Piで構成された低価格スパコン - PC Watch](https://pc.watch.impress.co.jp/docs/news/1091722.html)
    - レゴで作ろう！
- [テスラのAI部門長が語る「Software 2.0」。ディープラーニングは従来のプログラミング領域を侵食し、プログラマの仕事は機械の教師やデータのキュレーションになる － Publickey](http://www.publickey1.jp/blog/17/ai_software_20.html)
    - 言いたいことは分からなくもないし、ソフトウェア開発の進化を進めるとは思うけど、機械学習技術が業務仕様を定義できるかというと、ちょっとピンとこない。このブログ記事はふわっとしているので、ソフトウェア開発のどの要素を機械学習できるか考えてみても良いかも。
- [RESTful API Design Tips from Experience – studioarmix – Medium](https://medium.com/studioarmix/learn-restful-api-design-ideals-c5ec915a430f)
    - REST API設計の参考にしよう。

# リリース情報

先週に引き続き、[task-focus](https://github.com/u6k/task-focus)の実装を進めています。ユーザー管理の実装を進めており、Twitter認証(というかSNS認証)を前提としています。ちょっと手こずっています。

# Link

- Author
    - [u6k.Blog()](https://blog.u6k.me/)
    - [u6k - GitHub](https://github.com/u6k)
    - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
    - [2017-11-19-this-week-i-learned.md](https://github.com/u6k/blog/blob/master/_posts/2017-11-19-this-week-i-learned.md)
