---
layout: post
title: "git自分用メモ"
tags:
  - "git"
date: 2012-09-17 00:00:00+09:00
redirect_from:
  - /2012/09/git.html
---

ダウンロード～インストール～参考リンクなど、自分用メモ。

<!-- more -->

# ダウンロード

- [Git for Windows](http://msysgit.github.com/)
  - 「Downloads」から「Git-1.7.11-preview20120710.exe」をダウンロード。
- [TortoiseGit](http://code.google.com/p/tortoisegit/)
  - 「Downloads」から「TortoiseGit 1.7.12.0」をダウンロード。

# インストール

- 「Git-1.7.11-preview20120710.exe」を実行
  - Select Components
  - →チェックを全て外す。
  - Adjusting your PATH environment
  - →「Run Git from the Windows Command Prompt」をチェック
  - Configuring the line ending conversions
  - →「Checkout as-is, commit as-is」をチェック
- 「TortoiseGit-1.7.12.0-64bit.msi」を実行
  - 選択肢はそのままでインストール

# インストール直後の設定

[使い始める - 最初のGitの構成](http://git-scm.com/book/ja/%E4%BD%BF%E3%81%84%E5%A7%8B%E3%82%81%E3%82%8B-%E6%9C%80%E5%88%9D%E3%81%AEGit%E3%81%AE%E6%A7%8B%E6%88%90)

以下のコマンドを実行して、個人の識別情報を設定する。

```
# git config --global user.name "John Doe"
# git config --global user.email johndoe@example.com
```

# チュートリアル

- [アリスとボブになりきってgitをちゃんと理解したい!](http://d.hatena.ne.jp/zariganitosh/20080905/1220621182)
- [アリスとボブのコラボレーション、gitをちゃんと理解したい!](http://d.hatena.ne.jp/zariganitosh/20080908/1220881938)
- [アリスとボブのサーバー、git pushをちゃんと理解したい!](http://d.hatena.ne.jp/zariganitosh/20080910/1221050855)
- [アリスがチャレンジなコードを書くとき、git branchをちゃんと理解したい!](http://d.hatena.ne.jp/zariganitosh/searchdiary?word=%A5%A2%A5%EA%A5%B9%20%A5%DC%A5%D6)

# ブランチ運用

- [A successful Git branching modelを翻訳しました](http://keijinsonyaban.blogspot.jp/2010/10/successful-git-branching-model.html)
- [git-flowによるブランチの管理](http://www.oreilly.co.jp/community/blog/2011/11/branch-model-with-git-flow.html)
- [A successful Git branching modelを補助するgit-flowを使ってみた](http://d.hatena.ne.jp/Voluntas/20101223/1293111549)

# マニュアル

- [Pro Git](http://git-scm.com/book/ja)
