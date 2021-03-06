---
layout: single
title: "work-reportの素案"
tags:
  - "企画"
  - "レビュー"
  - "ブログ"
date: 2018-06-12 00:00:00+09:00
---

個人的にいわゆる週次レビューをしていましたが、これを簡略化するツールがほしいなと思ったので、ツールの素案を書いてみます。README駆動開発みたいなものです。

## 背景

過去に週次レビュー(u6k.RedmineのWiki、u6k.BlogのThis Week I Learnedなど)をしていましたが、現在は滞っています。活動の集計やコメントする作業が非常に手間がかかるためです。

GitHubでコードを管理しているので、コードを書くという活動量についてはGitHub Contributionを見ればある程度はわかります。興味があることもとりあえずTwitterに書いているので、twilogを見ればわかります。しかし、Wikiや多くのタスク、企画案などコードで表現できないものはu6k.Redmineで管理しており、こちらの活動は集計することが困難です。また、GitHub ContributionやTwitterも、ブログに書くとなると面倒です。

なので、上記のことを集計して、「あとはコメントを書くだけ」という状態にしたブログ原稿を生成するツールがほしいです。

## 要件

- 各種の活動をレポートとして生成してほしい
    - 活動を収集する
        - GitHubのコミット、Issue更新など
        - Redmineのチケット更新、Wiki更新など
        - Pocketの増加、消化
        - Twitterのツイート
- 活動レポートを見たい
    - 活動をレポートとして表示する
        - 数量
        - ログ
        - カレンダー
    - 活動をブログ記事として生成する
        - Jekyllページ形式

## サンプル

こんな感じの記事を生成したいです。

### Weekly Report (from 2018-06-04 to 2018-06-10)

2018-06-04から2018-06-10の活動のレポートです。

#### リリース

- 公開した記事
    - コメント
- 公開したプロダクトのバージョン
    - コメント

#### 主なツイートとコメント

- ツイート
    - コメント

#### GitHub

- 12 コミットしました。
- Issueを 23 回更新しました。

__GitHub Contribution画像を表示__

#### Redmine

- チケットを xx 回更新しました。
    - 新規チケットを x 個作成しました。
    - チケットを x 個終了しました。
- Wikiを xx 回更新しました。

__Redmine活動グラフを表示__

#### Twitter

- xx 回ツイートしました。
    - x 回リツイートしました。

__Twitter活動グラフを表示__

#### Pocket

- xxxxx ページが未読です。
- xx ページ追加しました。
- xx ページアーカイブしました。

__Pocket活動グラフを表示__

#### Author

authorを表示

## リポジトリ

- [u6k/work-report: 個人的な活動ログをレポートする - GitHub](https://github.com/u6k/work-report)
- [概要 - work-report - u6k.Redmine](https://redmine.u6k.me/projects/work-report)
