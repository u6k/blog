---
layout: single
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

![](001.jpg)

[Next]をクリックします。

![](002.jpg)

ライセンスをよく読み、問題が無ければ[Next]をクリックします。

![](003.jpg)

インストール先を指定して、[Next]をクリックします。通常、変更する必要はありません。

![](004.jpg)

インストール設定を行い、[Next]をクリックします。余計なオプションは要らないため、**全てのチェックを外します**。

![](005.jpg)

スタートメニューの名前を入力して、[Next]をクリックします。通常、変更する必要はありません。

![](006.jpg)

`PATH`環境変数の設定を選択して、[Next]をクリックします。コマンドプロンプトから使用したいため、**"Run Git from the Windows Command Prompt"を選択します**。

![](007.jpg)

エンコーディング変換を選択して、[Next]をクリックします。勝手に変更されたくはないので、**"Checkout as-is, commit as-is"を選択します**。

![](008.jpg)

インストール中です。

![](009.jpg)

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

![](010.jpg)

[Next]をクリックします。

![](011.jpg)

使用許諾をよく読み、問題が無ければ[Next]をクリックします。

![](012.jpg)

インストール先とコンポーネントを選択して、[Next]をクリックします。通常、変更する必要はありません。

![](013.jpg)

[Install]をクリックして、インストールを開始します。

![](014.jpg)

インストール中に、起動しているアプリを終了するように要求されることがあります。表示されたアプリを終了してから続行するか、アプリを終了せずに"Do not close applications. A reboot will be required."を選択して[OK]をクリックして続行します。

![](015.jpg)

インストールが完了しました。[Finish]をクリックして、終了します。

インストールが正常終了したか確認するため、エクスプローラーを起動して、適当なフォルダを右クリックします。正常終了していれば、右クリックメニューに"TortoiseGit"が表示されます。

![](016.jpg)

"About"をクリックすると、バージョン情報が表示されます。

![](017.jpg)

Gitとの連携がうまくいっていれば、"Version Infomation"にGitのバージョンも表示されます。

以上で、GitとTortoiseGitのセットアップは完了です。
