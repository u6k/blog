---
layout: post
title: "Windows再セットアップメモ"
tags:
  - "Chocolatey"
date: 2015-02-03 23:05:00+09:00
---

なんだかんだと環境が汚れて、Windowsを再セットアップすることがあります(仮想環境を使えとは思いますが)。ここでは、再セットアップの手順を説明します。
なお、この文章はあくまで自分向けなので、他の人には参考にならないと思います。たぶん。

<!-- more -->

# 前準備

- IMEの辞書をバックアップする。
- 他にバックアップすべきファイルが無いか、全フォルダを確認する。特に、ユーザーフォルダ以下を確認する。
- iPhoneUSB接続でテザリングする場合、iTunesインストールファイルをダウンロードしておいたほうが良い。

# 用意するもの

- 外付けHDD。PC内にしかないファイルを退避するため。Dropboxなど外部ストレージに保存してあるなら、必要ない。
- Windowsインストールメディア。Windows PCであれば、PC内に回復用パーティションがあるはず。
- MS Officeインストールメディア。

# 手順

## Windowsインストール

- インストールメディア、または回復用パーティションからWindowsをインストールする。
- Microsoftアカウントでログオンする。
- ログオン方式を変更する。
	- Microsoftアカウントのパスワードをランダム文字列にしていて覚えていないため、ログオン方式を変更している。

## 初期設定

※設定は、前使用していたアカウントから色々引き継がれる。

- ディスプレイ解像度、デスクトップ壁紙、スクリーンセーバーを設定する。
- エクスプローラーを設定する。
	- 自動的に現在のフォルダーまで展開。
	- 全てのフォルダを表示。
	- フォルダの表示設定をクリア、設定
	- 拡張子を表示
- タスクバーを設定する。
	- 左に表示
	- 小さいアイコン
- 電源を設定する。
- スタート画面、タスクバーのアイコンを整理する。
- インターネット接続を設定する。
	- 自宅LANに接続
	- テザリングで接続
- Windows Updateを行う。
- ウィルス対策ソフトウェアをインストールし、最新状態に更新、完全スキャンを行う。
- コマンドプロンプトを設定する。
	- フォントサイズ
	- 画面幅、バッファ

## Chocolatey

- [Chocolatey Gallery](https://chocolatey.org)に記載されているコマンドをコマンドプロンプトで実行して、Chocolateyをインストールする。
- よく使うソフトウェアを`choco`コマンドでインストールする。

```
> choco install TortoiseGit git.install tortoisesvn svn GoogleChrome thunderbird winscp jdk8 vcredis2013 directx ccleaner adobereader cygwin ruby python cygwin skype putty SourceTree virtualbox vagrant genymotion dropboxfiddler sandboxie truecrypt android-sdk
```

## 手動でソフトウェアをセットアップ

- MS Office
	- 自動修正を一通りオフに設定
- Explzh
	- 32bit版を使用する。64bit版だと、なぜかアーカイバーDLLがダウンロードできない。
	- アーカイバーDLLを全てインストールする。
- IrfanView
	- 本体は日本語ページから、プラグインは英語オフィシャルページからダウンロードする。
- Thunderbird
	- 一度そのまま起動して、プロファイルを作成する。
	- 「%USER%¥AppData¥Roaming¥Thunderbird¥profile.ini」にプロファイルの場所が設定されているので、Dropboxのプロファイルに修正して再起動する。
	- メールが参照できることを確認する。
	- メールの新規作成、返信、転送でプラグインが適用されることを確認する。
- CCleaner
	- 起動時にクリーン
- WinMerge
- サクラエディタ
	- インストール途中で、「Sakuraで起動する」を設定する。これがあるため、Chocolateyからはインストールしない。
- astah*
- CubePDF
- TeraTerm
- Google日本語入力
- GomPlayer
- DriveAnalyzer
- Skitch
- git
	- 以下のコマンドを実行する。

```
> git config --global user.name "John Doe"
> git config --global user.email johndoe@example.com
> git config --global core.autocrlf false
> git config --global core.precomposeunicode true
> git config --global core.quotepath false
```

- Java SDK
	- JAVA_HOME環境変数を設定する。
- GoogleChrome
	- Googleアカウントでログインする。
- Dropbox
	- ログインし、同期する。
- Skype
	- ログインする。
- SourceTree
	- GitHubにログインする。
	- BitBucketにログインする。
- Genymotion
	- 適当なエミュレーターイメージをダウンロードし、使えるようにする。
- Android SDK
	- 適当なモジュールをダウンロードする。

# メモ

- まだまだ、手動でインストール・設定することが多い…
- Linuxのdotfile管理みたいなのは、Windowsだとレジストリかな。レジストリを保存しておいて、Chocolateyインストール→レジストリを復元、で設定を復元できないかなぁ。そんなに綺麗にはできないよなぁ…
