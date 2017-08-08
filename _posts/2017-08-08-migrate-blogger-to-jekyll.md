---
layout: single
title: "BloggerからJekyllにブログを引っ越し"
tags:
  - "Blog"
  - "Docker"
  - "Jekyll"
  - "CircleCI"
date: 2017-08-08 07:00:00+09:00
---

[ブログ引っ越し検討、およびブログサービスに求める要件](/2015/05/26/review-migration-blog-and-requirement-for-blog-service.html)で検討していた引っ越しについて、2017年1月から4月にかけて、BloggerからJekyll、つまり静的サイトに引っ越しをしました。この記事では、Jekyll検討過程、引っ越しの手順、ブログ構成を説明します。

<!-- more -->

# 振り返り - Bloggerで辛いところ

- Markdownで書けない。
- スマホから書けない。
- ガジェットがスマホ向けに表示されない。
- コードブロックが整形表示されず、ただのpreブロックになってしまう。

# Jekyll検討

Jekyllについては、以下を参照。

- [Jekyll • シンプルで、ブログのような、静的サイト](https://jekyllrb-ja.github.io/)
- [30分のチュートリアルでJekyllを理解する](http://melborne.github.io/2012/05/13/first-step-of-jekyll/)
- [Jekyll + github pages を使って git + markdown でサイト構築 - akkunchoi@github](http://akkunchoi.github.io/jekyll-github-blogging.html)

## Markdownで書ける！

何と言っても、Markdown文書をそのまま公開することができます。テーマによりますが、コードブロックやガジェットもキレイに表示できます。Bloggerの場合、ローカルでMarkdown文書を作成→StackEditにコピペしてパブリッシュ、という手順が鬱陶しいです。

後の公開ワークフローで説明しますが、GitHubのmasterブランチにpushすれば、自動的にブログが更新されるようなワークフローを作ることも可能です。

## サーバーの用意

Bloggerはホスティング・サービスなのでサーバーについて何も考えなくて良かったですが、Jekyllは静的サイトなので自分でサーバーを用意する必要があります。この点、もともと自宅サーバーを運用しているので、悩む必要がありませんでした。自分でサーバーを一から用意できない場合でも、以下の手段でホスティングすることができます。

- AWS S3
    - `s3_website`プラグインで、生成した静的サイトをAWS S3で容易に公開することができます。
- GitHub Pages
    - GitHub PagesはJekyllをサポートしています。[Using Jekyll as a static site generator with GitHub Pages - User Documentation](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/)を参照。
    - いろいろ制限があることに注意。

現在は自宅サーバーで公開していますが、何らかの都合でそれが使えなくなっても、簡単にAWS S3などに移行することができます。

# 引っ越しの手順

もともと、記事をMarkdown文書で管理していたため、記事本文の移行はほぼ作業無しでした。以下に、必要だった作業を説明します。

## ドメイン名

Blogger時代の`blog.u6k.me`というドメイン名を変えるつもりはなかったので、ドメイン名はそのままです。DNS設定とBlogger設定を変更しました。

## Jekyll用ファイル構成

単にMarkdown文書を格納していたので、これをJekyll用ファイル構成に整理しました。Jekyllで初期サイト構成を生成して、そこに既存ファイルを移動しました。この時、テーマもいろいろいじりました。

Dockerを使い、生成した静的サイトをnginxコンテナに格納して公開したかったので、そのためのDockerfileなども作成しました。

## ヘッダー

Markdown文書のヘッダー部分(メタ情報部分)を変更・追加する必要がありました。基本的にStackEdit向けに書いていたので、これをJekyll向けに変更しました。

## 旧URLからのリダイレクト

Bloggerのパス体系とJekyllのパス体系が異なったので、過去にシェアしたURLからリダイレクトする必要がありました。`jekyll-redirect-from`プラグインを使用すると、あるパスにアクセスされたときに実際の記事パスにリダイレクトすることができます。このプラグインを適用して、必要な記事のヘッダー部に`redirect_from`パラメータを追加しました。

## 画像

Blogger時代にいろいろなサービスで画像を生成・格納していたため、これを整理して同一リポジトリに格納しました。というか2017/8/8時点では移動中です。

## UML図

`jekyll-plantuml`プラグインを使用することで、Markdown文書中にPlantUML文書を直接埋め込むことができます。静的サイトを生成すると、UML画像に変換され、記事に埋め込まれます。 __超便利！！！__

# ブログ構成

以下の構成でブログの記事を執筆し、公開しています。ややこしいですが、Author(執筆者)がエディターで記事を書き`git push`した後は、`blog`コンテナが再起動されるまで自動です。

{% plantuml %}

skinparam titleBorderColor black
skinparam titleBorderThickness 1
skinparam titleBorderRoundCorner 15

title u6k.Blog Publish Workflow

actor "Author" as author
actor "Reader" as reader

node "Local PC" {
    component "Editor" as editor
    component "blog (Working)" <<Source Code>> as blog_src_working
    component "blog-dev" <<Docker>> as blog_dev_local
    component "blog" <<Docker>> as blog_local
}

node "GitHub" {
    component "blog" <<Source Code>> as blog_src
}

node "CircleCI" {
    component "blog-dev" <<Docker>> as blog_dev_circleci
    component "blog" <<Docker Image>> as blog_circleci
}

node "Docker Hub" {
    component "blog" <<Docker Image>> as blog_dockerhub
}

node "macOS" {
    component "Jenkins" <<Docker>> as jenkins
    component "blog" <<Docker>> as blog
}

author --> editor : use
editor --> blog_src_working : edit
blog_dev_local --> blog_src_working  : use
blog_dev_local --> blog_local : build
author --> blog_local : demo read

blog_src_working --> blog_src : git push

blog_src --> blog_dev_circleci : webhook
blog_dev_circleci -right-> blog_circleci : build
blog_dev_circleci --> jenkins : webhook

blog_circleci --> blog_dockerhub : docker push

jenkins --> blog_dockerhub : docker pull
jenkins --> blog : restart

reader -up-> blog : read

{% endplantuml %}

以下に、これらを使用したブログの公開ワークフローを説明します。

## Local PC

ローカルPCで記事を執筆し、gitで管理します。執筆中の記事を表示確認したい場合、blog-devコンテナでblogイメージをビルドして、これを起動して表示確認します。単純なMarkdown文書であれば普通にAtomなどでプレビューできるので、blogコンテナで表示確認もほとんどしていません。

[Android端末でブログを書く](/2017/07/20/write-blog-on-android.html)で書いた通り、短い文章であれば、Android端末のJotterPadでMarkdown文書を書き、MGitで`git push`するという方法も可能です。

## GitHub

記事を管理しています。GitHubに`git push`すると、WebHookによりCircleCIのビルドが実行されます。

## CircleCI

静的サイトをビルドします。具体的にはblog-devコンテナでblogイメージをビルドします。masterブランチであれば、Docker Hubに`docker push`してJenkinsのWebHookに通知します。

## Docker Hub

ビルドしたblogイメージを管理しています。Automated Buildではなく、CircleCIから`docker push`しています。ですので、Dockerイメージを管理しているだけです。

## macOS

自宅サーバーで、ブログを公開しています。ここではJenkinsとblogが動作しており、CircleCIからWebHook通知を受けると、JenkinsがDocker Hubから最新のblogイメージを`docker pull`して、blogコンテナを再起動します。これにより、最新の記事が公開されます。

ちなみに、`_config.yml`を見ると分かりますが`s3_website`プラグインを追加しており、実は一時的にAWS S3で公開していました。

# おわりに

ブログにしては複雑なワークフローになってしまいましたが、普通にサービスのビルドフローと同じ程度ですし、まぁいいかと思っています。今はテーマを適用して少しカスタマイズした程度なので、いろいろ試したいと思います。
