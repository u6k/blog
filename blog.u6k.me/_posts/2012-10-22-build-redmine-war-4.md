---
layout: post
title: "Redmineをwar化 - 目指せ、ALMinium!"
tags:
  - "Redmine"
  - "redmine-war"
date: 2012-10-22 23:00:00+09:00
redirect_from:
  - /2012/10/redminewar-alminium.html
---

「Redmineをwar化」ですが、実はかなり前から挑戦しようとしてはいたのですが、[(1) とりあえずRedmine+JRubyで動かす](http://u6k-apps.blogspot.com/2012/10/redminewar-1-redminejruby.html)で述べた通り「セットアップが面倒！」となってしまい進んでいませんでした。

そんな時、偶然、[かんばん!　もし女子高生がRedmineで「スクラム」開発をしたら](http://www.atmarkit.co.jp/fjava/index/index_scrum.html)を見つけました。この記事に触発されて再びRedmineに挑戦する気になり、基本的にJavaユーザーの自分なので「そういえばJRubyというものもあったな」と思い、Redmineをwar化するに至ったわけです。

ちなみに現在の目標は、「かんばん!」の中でも紹介されている[ALMinium](https://github.com/alminium/alminium)相当の機能を持つパッケージを構築して、簡単にセットアップできるようにすること、です。

> NOTE: もっと言うと、GAE/jの上で動かしたい…
