---
layout: single
title: "ブログ引っ越し検討、およびブログサービスに求める要件"
tags:
  - "Blog"
  - "要件"
date: 2015-05-26 07:00:00+09:00
redirect_from:
  - /2015/05/blog-post.html
---

Bloggerがイケてないので、別のブログサービスへの引越しを検討しています。ついでにブログサービスに求める要件も整理してみました。

## Bloggerで辛いところ

* Markdownで書けない。
* スマホから書けない。
	* 一応、スマホアプリがあるけど低機能。
* ガジェットがスマホ向けに表示されない。
	* テーマもスマホ向けには適用されないっぽい。
	* テーマをいじれば、スマホ向けにもPC向けテーマが表示されるらしいことは知ってる。試してないけど。
* コードブロックが整形表示されず、ただのpreブロックになってしまう。
	* 整形してくれるjsを挿入すればいいらしいことは知ってる。ただ、以前に試したけどスマホ向けには適用されなかったような。
	* gistに書いてから引用すればいいのだろうけど、それすら面倒。

## Blogger良いところ

* 広告が挿入されない。
* 標準でアクセス分析ツールが利用できる。
* アドセンスの適用が他ブログサービスに比べて簡単？らしい。
* ガジェットを簡単に配置できる。
* 無料で利用できる。

## ブログサービスに求める要件

良い機会なので、自分がブログサービスに求める要件を整理してみました。

* Markdown文書を投稿できる。
	* mdに書いたメタ情報で記事属性を設定できるとなお良い。
* コードをスタイリッシュに表示できる。
* 投稿日付を変更できる。
* 予約投稿ができる。
* スマホ向けアプリが提供されている。
	* 閲覧
	* 投稿
	* 更新
* カスタムHTMLコードを挿入できる。
* RSS配信している。
	* RSSエンドポイントは変更したくないな…どうすれば良いのだろう。
	* SNSでの記事周知が流行な理由を少し分かった気がする。
	* 正直、もうRSSは要らない子？という気がしなくもない。
* レスポンシブデザインに対応している。
	* PC向け
	* タブレット向け
	* スマホ向け
* サイドバーガジェットが提供されている。
* 記事URLを自由に設定できる。
	* Blogger側で記事単位にリダイレクト先を設定できるのであれば、それでも良い。
* SNSシェアボタンを設置できる。
	* Twitter
	* Facebook
	* Pocket
	* Google+
* 独自ドメインを設定できる。
* ファビコンを設定できる。
* 無料で利用可能。
* 広告が自動挿入されない。

## ブログサービス候補

というわけで、要件を満たしてくれそうなサービスを探してみます。

* tumblr
* Wordpress.com
* はてなブログ
* GitHub Pages
* Jekyll
	* [クリック1発で、Github上にブログを無料で作成できる「Jekyll Now」が超絶便利！](http://plus.appgiga.jp/masatolan/2015/01/13/55047/)

## 見送ったブログサービス

魅力的ではあったけど見送ったブログサービス。

* [チームブログをGitHubとHexoではじめよう！](http://blog.otakumode.com/2014/08/08/Blogging-with-hexoio/)
* [所要時間3分!? Github PagesとHEXOで爆速ブログ構築してみよう！](http://liginc.co.jp/web/programming/server/104594)
	* 自分で全て制御できるところがいかにもエンジニアチックで良いけど、そこまで手間はかけたくない。もっと手軽に投稿したいです。できればスマホだけで。
* [エンジニアのブログは Octopress が最適](http://blog.shiroyama.us/blog/2014/02/26/octopress/)
	* 同上

## 引越し手順

Bloggerからの引越し手順を考えてみます。

* 新ブログを開設。とりあえず動作・表示確認用。
* いくつか記事を投稿してみて、動作・表示確認をする。
	* 独自ドメインとしてテスト用のサブドメインを設定。
	* PC、スマホ両方で投稿、表示を確認。
	* テーマを表示確認。
	* リダイレクトを動作確認。
	* コード整形がキレイに表示されるか確認。
* 問題なさそうなら、引っ越し開始。
* 全記事を新ブログに投稿する。
* ドメイン名を新ブログを指すように設定。

## Tumblrで辛い点

* tumblr投稿のtwitter連携のURLが、独自ドメインURLではなくtumblrのURLになってしまう。
* ツイートをtumblr投稿した時のtwitter連携の書式が、コレジャナイ感がすごい。
* もっと気楽にブログ投稿したいと思うけど、それならBloggerでもできなくはないかな？
* tumblrのArchiveはおかしすぎ。
* うーん、Bloggerのままでも良い気がする。

## とりあえず

tumblrはすっごく魅力的なんですけど、どうせカスタマイズが必要になりますし、ならBloggerのままでも良い気がしてきました…この調子で突き詰めていくと、やはり最終的にはみんな大好きWordPressになってしまうのだろうか。

## 参考リンク

* [Blogger・Tumblr・はてなブログの徹底比較 〜真面目に文章を書くときのブログ選び〜](http://voices.ku-neko.com/2015/02/blogger-tumblr-hatenablog.html)
* [Bloggerに乗り換えました - BloggerとTumblrの比較](http://denshiyugi.blogspot.jp/2012/01/blogger-bloggertumblr.html)
* [妻のパン屋のブログを自作ツールでエキサイトブログからTumblrに移行した話](http://blog.jnito.com/entry/2014/09/22/100441)
* [【初心者】０から始めるtumblrのまとめ【使い方】 - NAVER まとめ](http://matome.naver.jp/odai/2132843425856803701)
