---
layout: post
title: "GitとTortoiseGitのセットアップ手順"
tags:
  - "git"
  - "TortoiseGit"
  - "手順"
date: 2013-03-13 22:27:00+09:00
redirect_from:
  - /2013/03/gittortoisegit.html
---

Gitは非常に有名で優れた分散型バージョン管理システムです。以前はSubversionが大きなシェアを持っていましたが、現在はGitが大きなシェアを持っています。Gitはコマンドラインツールなので基本的にはコマンドを入力・実行する形で使用しますが、WindowsでGitを使う場合、Gitコマンドをそのまま使うよりもTortoiseGitを使う方が便利です。以下に、GitとTortoiseGitのセットアップ手順を説明します。

<!-- more -->

# Git、TortoiseGitをダウンロード

TortoiseSVNはSVN無しでも動作しましたが、TortoiseGitはあくまでGitのフロントエンドであり、Gitをインストールする必要があります。そのため、GitとTortoiseGitをダウンロードします。

WindowsにGitをインストールする方法は、Cygwin版GitとmsysGitの2通りあります。Cygwinを入れるのが面倒なため、ここではmsysGitで説明します。

* [msysgit - Git for Windows](https://code.google.com/p/msysgit/)
    * `Git-xxx.exe`、`msysGit-xxx.exe`、`PortableGit-xxx.7z`がありますが、`Git-xxx.exe`をダウンロードします
* [TortoiseGit - Porting TortoiseSVN to TortoiseGit](https://code.google.com/p/tortoisegit/)
    * 必要であれば、言語パックもダウンロードします。

# Gitをインストール

まず、Gitをインストールします。ダウンロードした`Git-xxx.exe`を実行します。

![](http://3.bp.blogspot.com/-b7_HZcca5RM/UUB2PJ_Az2I/AAAAAAAAAPc/cnOh-pKsZ8c/s1600/WS000000.JPG)

[Next]をクリックします。

![](http://3.bp.blogspot.com/-pY_b8p18nJU/UUB2PMT2IYI/AAAAAAAAAPo/Q2rhS8j8WT8/s1600/WS000001.JPG)

ライセンスをよく読み、問題が無ければ[Next]をクリックします。

![](http://3.bp.blogspot.com/-C4C5BAQN8wc/UUB2PGF1giI/AAAAAAAAAPg/Ixggt3tZwQI/s1600/WS000002.JPG)

インストール先を指定して、[Next]をクリックします。通常、変更する必要はありません。

![](http://1.bp.blogspot.com/-XUAgIGJYQlM/UUB2PonLrAI/AAAAAAAAAR8/aEvXnQqGnjE/s1600/WS000003.JPG)

インストール設定を行い、[Next]をクリックします。余計なオプションは要らないため、**全てのチェックを外します**。

![](http://3.bp.blogspot.com/-LRYQY_72prQ/UUB2PiP57qI/AAAAAAAAASA/fFGMlq8coG0/s1600/WS000005.JPG)

スタートメニューの名前を入力して、[Next]をクリックします。通常、変更する必要はありません。

![](http://1.bp.blogspot.com/-OgM-ys3ZKOc/UUB2QPp3QLI/AAAAAAAAAQY/TR3ueP4BMcE/s1600/WS000006.JPG)

`PATH`環境変数の設定を選択して、[Next]をクリックします。コマンドプロンプトから使用したいため、**"Run Git from the Windows Command Prompt"を選択します**。

![](http://2.bp.blogspot.com/-erJ9cp1iMuA/UUB2QNz4xII/AAAAAAAAAQA/sVJomMfEaCA/s1600/WS000007.JPG)

エンコーディング変換を選択して、[Next]をクリックします。勝手に変更されたくはないので、**"Checkout as-is, commit as-is"を選択します**。

![](http://3.bp.blogspot.com/-H2Ugc-34Xt4/UUB2QpB9fHI/AAAAAAAAAQU/1jMj8R26qLY/s1600/WS000008.JPG)

インストール中です。

![](http://2.bp.blogspot.com/-t2F9OCnY8FU/UUB2QkkPooI/AAAAAAAAAQM/CqnJpNlKTCA/s1600/WS000009.JPG)

インストールが完了しました。[Finish]をクリックして終了します。

インストールが正常終了したか確認するため、コマンドプロンプトを起動して、次のコマンドを実行します。

```
C:\git --version
git version 1.7.11 msysgit.1
```

バージョン情報が表示されれば、正常終了しています。

# Gitを設定

Gitを使う前に、ユーザー名とメールアドレスを設定する必要があります。この設定は、コミット時のユーザー名、メールアドレスとして自動的に使用されます(クローンしたリポジトリごとにも設定できます)。

コマンドプロンプトを起動して、次のコマンドを実行します。

```
C:\git config --global user.name "(ユーザー名)"
C:\git config --global user.email "(メールアドレス)"
```

# TortoiseGitをインストール

Gitのセットアップが終わったら、次はTortoiseGitをインストールします。ダウンロードした`TortoiseGit-xxx.msi`を実行します。

![](http://1.bp.blogspot.com/-A9Qo9xHTUzY/UUB2Qt3VYTI/AAAAAAAAAQc/Do8E6diNK3k/s1600/WS000010.JPG)

[Next]をクリックします。

![](http://3.bp.blogspot.com/-7Xf03Ra2W3c/UUB2RGngCMI/AAAAAAAAARs/vUPt_vCY6Rw/s1600/WS000011.JPG)

使用許諾をよく読み、問題が無ければ[Next]をクリックします。

![](http://4.bp.blogspot.com/-EjeSLUg1sMo/UUB2RFyqhYI/AAAAAAAAASE/x5PZigWMDro/s1600/WS000012.JPG)

インストール先とコンポーネントを選択して、[Next]をクリックします。通常、変更する必要はありません。

![](http://4.bp.blogspot.com/-9hXgv_jLTak/UUB2RB0U64I/AAAAAAAAAQw/7KPmDsVp0RU/s1600/WS000013.JPG)

[Install]をクリックして、インストールを開始します。

![](http://2.bp.blogspot.com/-GRXT0E9jGV8/UUB2Rj1pDoI/AAAAAAAAARo/YfcoNbJhtPg/s1600/WS000014.JPG)

インストール中に、起動しているアプリを終了するように要求されることがあります。表示されたアプリを終了してから続行するか、アプリを終了せずに"Do not close applications. A reboot will be required."を選択して[OK]をクリックして続行します。

![](http://1.bp.blogspot.com/-sdaDi4h_29g/UUB2R57_GJI/AAAAAAAAARg/4j6DypRnbTU/s1600/WS000016.JPG)

インストールが完了しました。[Finish]をクリックして、終了します。

インストールが正常終了したか確認するため、エクスプローラーを起動して、適当なフォルダを右クリックします。正常終了していれば、右クリックメニューに"TortoiseGit"が表示されます。

![](http://4.bp.blogspot.com/-Jb3oZMG-zLU/UUB2Sk6h_GI/AAAAAAAAASM/tjB_URTb3NQ/s1600/WS000019.JPG)

"About"をクリックすると、バージョン情報が表示されます。

![](http://1.bp.blogspot.com/-BaFhjENl6io/UUB2SgPXucI/AAAAAAAAARY/G1VTuLzgTwE/s1600/WS000020.JPG)

Gitとの連携がうまくいっていれば、"Version Infomation"にGitのバージョンも表示されます。

以上で、GitとTortoiseGitのセットアップは完了です。
