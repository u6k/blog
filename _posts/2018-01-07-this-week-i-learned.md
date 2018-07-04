---
layout: single
title: "This Week I Learned (from 2018-01-01 to 2018-01-07)"
tags:
  - "This Week I Learned"
date: 2018-01-07 23:50:00+09:00
---

今週の気になったニュースや自ソフトウェアのリリース情報や書いた記事を整理します。

## ニュース

- [Feature #14872: Activities REST API - Redmine](http://www.redmine.org/issues/14872)
    - 2017年の活動を振り返るためにRedmine Activitiesを集計したかったのですが、APIがありませんでした。このチケットも放置されているようです。仕方ないのでHTMLを解析して集計しました。APIは自分でプラグインを書くか、View Customizeプラグインを使うかするしかないかな？
- [モデル駆動開発におけるモデル変換の役割 (1/2)：CodeZine（コードジン）](https://codezine.jp/article/detail/10597)
    - 要求開発から実装までモデルで表現する手法に興味があります。これも参考にしよう。
- [モデルの粒度とトレーサビリティ、変更管理の問題は、モデリングツールではなくUMLそのものに真因があるのではないか: プログラマの思索](http://forza.cocolog-nifty.com/blog/2017/12/uml-7a09.html)
    - プログラミング言語があくまで言語であって手法ではないように、UMLもモデリング言語であって手法ではないと考えています。粒度、トレーサビリティ、構成管理は手法で解決すべきです。しかし、UMLにはベスト・プラクティスが無いっぽいことが課題だと思います。
- [アジャイル開発にはモデリングや要件定義の工程はあるのか、という問題とその周辺: プログラマの思索](http://forza.cocolog-nifty.com/blog/2018/01/post-cdeb.html)
    - 本格的なアジャイルを実践したことはないけど、いろいろ考えさせられる記事なので、別記事で想いを整理してみようと思います。
- [Using Java 9 Modularization to Ship Zero-Dependency Native Apps](https://steveperkins.com/using-java-9-modularization-to-ship-zero-dependency-native-apps/)
    - Java 9を使った、JREも同梱したアプリケーションの配布の手順。インストールの手間が減るので良いと思いますが、例えばJREに脆弱性が見つかったとかでアップデートしたい場合は、やはりパッケージ再作成と再インストールが必要になるのかな？
- [オープンデータ取得先まとめ - Qiita](https://qiita.com/tmp_llc/items/7296c5d6bb8769b18d24)
    - 機械学習技術が流行してデータの重要性が高まっているので、公開されているデータについても注意していきたい。
- [Markdown export - 🌟Features - Dynalist Forum](http://talk.dynalist.io/t/markdown-export/803)
    - アウトライナーとしてDynalistを使っていますが、Markdown文書にエクスポートする機能がないのが不便。DynalistでRedmine Wikiやブログの文章を考え、それをMarkdown文書にエクスポートしてそのまま貼り付ける、とかしたいのですけど。

## リリース情報

記事を書きました。

- [2017年の振り返り - u6k.Blog()](https://blog.u6k.me/2018/01/03/2017-retrospective.html)
    - 2017年の振り返りと、2018年の目標。今年も頑張ろう。そして、もっと機械的に計測したい。

CodeIQのお題を消化しました。

- [進捗ヴェリーグッドマーク | CodeIQ](https://codeiq.jp/q/3526)

## おまけ

これ、This Week I Learned(今週学んだこと)というよりRetrospective(振り返り)な気がしてきた…

## Link

- Author
    - [u6k.Blog()](https://blog.u6k.me/)
    - [u6k - GitHub](https://github.com/u6k)
    - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
    - [2018-01-07-this-week-i-learned.md](https://github.com/u6k/blog/blob/master/_posts/2018-01-07-this-week-i-learned.md)
