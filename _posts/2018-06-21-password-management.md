---
layout: single
title: "アナログなパスワード管理"
tags:
  - "機密情報管理"
date: 2018-06-21 00:00:00+09:00
---

- 大量のサービスに対するパスワードなんて、覚えられるわけがない。
- 可能な限り多要素認証を利用して、パスワードが漏洩しても直ちに損害を受けないようにする。

# 管理サービス

- 基本的に、LastPassで管理する。
- マスターパスワードのみ、Off The Gridで生成したパスワードを使用する。

# LastPass登録ポリシー

- パスワードは、可能な限り長く、英数記号を含ませて、ランダムに生成する。
- 可能な限り、多要素認証を設定する。多要素認証を設定した場合、メモに復旧コードなどを記載する。
- マスターパスワードは定期的に変更する。

# Off The Grid

- GRC | Off The Grid https://www.grc.com/offthegrid.htm
- OTGルールだと英字しか生成されないため、ルールを拡張する。
- グリッドは紙に印刷して、スマホケースに挟み込む。

## Off The Grid拡張ルール

- `u6k.me`ドメインを使用する。
- 2文字ではなく3文字使用する。
- 更に進行方向の数字記号を使用する。
- PINには、1フェーズの文字の外周数字を使用する。

# 参考リンク

- Off The Grid
    - 紙だけでサイトごとに異なるパスワードを生成する暗号、米研究者が考案 -INTERNET Watch Watch https://internet.watch.impress.co.jp/docs/news/473716.html
    - GRC | Off The Grid     https://www.grc.com/offthegrid.htm
- 別の手法
    - パスワードを記録し、暗号化するための、超アナログな方法 | ライフハッカー［日本版］ https://www.lifehacker.jp/2010/12/101222password_tabula_recta.html
- IPAの勧告
    - プレス発表　パスワードリスト攻撃による不正ログイン防止に向けた呼びかけ：IPA 独立行政法人 情報処理推進機構 https://www.ipa.go.jp/about/press/20140917.html
        - パスワードの使いまわしは、絶対ダメ
- 総務省の勧告
    - パスワード定期変更は逆に危険。その理由を総務省と内閣に聞いた | ホウドウキョク https://www.houdoukyoku.jp/posts/28671
        - パスワードの定期変更は不要(パスワードが十分に長く複雑な場合)
- 六角暗号記帳
    - デジタルエンディングノートにも。生成・変更もカンタン！パスワードノート。 - アマノコトワリ舎　自然と共に。パスワード管理ノート新発売！ https://www.amacoto.com/

# Link

- Author
  - [u6k.Blog](https://blog.u6k.me/)
  - [u6k - GitHub](https://github.com/u6k)
  - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
  - [2018-06-21-password-management.md](https://github.com/u6k/blog/blob/master/_posts/2018-06-21-password-management.md)
