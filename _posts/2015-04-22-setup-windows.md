---
layout: single
title: "Windows再セットアップメモ (2015/4/22版)"
tags:
  - "Chocolatey"
date: 2015-04-22 22:00:00+09:00
redirect_from:
  - /2015/04/windows-2015422.html
---

[前回のセットアップ](http://u6k-apps.blogspot.jp/2015/02/windows.html)から変わった手順があるため、再投稿します。

- 変更点
	- Chocolateyセットアップを`packages.config`で行うように変更。

## 目的

なんだかんだと環境が汚れて、Windowsを再セットアップすることがあります(仮想環境を使えとは思いますが)。ここでは、再セットアップの手順を説明します。
なお、この文章はあくまで自分向けなので、他の人には参考にならないと思います。たぶん。

## 前準備

- IMEの辞書をバックアップする。
- 他にバックアップすべきファイルが無いか、全フォルダを確認する。特に、ユーザーフォルダ以下を確認する。
- iPhonei USB接続でテザリングする場合、iTunesインストールファイルをダウンロードしておいたほうが良い。
	- iTunesがインストールされていないとUSB接続でのテザリングができないため。

## 用意するもの

- 外付けHDD。PC内にしかないファイルを退避するため。Dropboxなど外部ストレージに保存してあるなら、必要ない。
- Windowsインストールメディア。Windows PCであれば、PC内に回復用パーティションがあるはず。
- MS Officeインストールメディア。

## 手順

### Windowsインストール

- インストールメディア、または回復用パーティションからWindowsをインストールする。
- Microsoftアカウントでログオンする。
- ログオン方式を変更する。
	- Microsoftアカウントのパスワードをランダム文字列にしていて覚えていないため、ログオン方式を変更している。

### 初期設定

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

### Chocolatey

- [Chocolatey Gallery](https://chocolatey.org)に記載されているコマンドをコマンドプロンプトで実行して、Chocolateyをインストールする。
- gitだけ、先にインストールする。

```
> cinst git.install
> git config --global user.name "John Doe"
> git config --global user.email johndoe@example.com
> git config --global core.autocrlf false
> git config --global core.precomposeunicode true
> git config --global core.quotepath false
```

- GitHubから、PCセットアップ用のプロジェクトをクローンする。
TODO os-setupプロジェクトをGitHubに移動する。

```
> git clone https://github.com/u6k/os-setup.git
```

- クローンしたフォルダに含まれる`packages.config`を使用して、ソフトウェアをインストールする。

```
> cinst -y packages.config
```

なお、`packages.config`の内容は以下の通り。

```xml:packages.config
<?xml version="1.0" encoding="utf-8"?>
<pakages>
    <package id="TortoiseGit" />
    <package id="tortoisesvn" />
    <package id="svn" />
    <package id="GoogleChrome" />
    <package id="thunderbird" />
    <package id="winscp" />
    <package id="jdk8" />
    <package id="vcredist2013" />
    <package id="directx" />
    <package id="ccleaner" />
    <package id="adobereader" />
    <package id="cygwin" />
    <package id="ruby" />
    <package id="python" />
    <package id="cygwin" />
    <package id="putty" />
    <package id="SourceTree" />
    <package id="virtualbox" />
    <package id="vagrant" />
    <package id="genymotion" />
    <package id="dropbox" />
    <package id="fiddler" />
    <package id="sandboxie" />
    <package id="truecrypt" />
    <package id="android-sdk" />
</packages>
```

### 手動でソフトウェアをセットアップ

- MS Office
	- オートコレクトを一通りオフに設定。
- Explzh
	- 32bit版を使用する。64bit版だと、なぜかアーカイバーDLLがダウンロードできない。
	- アーカイバーDLLを全てインストールする。
- IrfanView
	- 本体は日本語ページから、プラグインは英語オフィシャルページからダウンロードする。
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

### ソフトウェアの更新(ときどき)

Chocolateyにはソフトウェアの一括バージョンアップ機能があります。ソフトウェア側が持っている自動バージョンアップ機能はオフにしておいて、Chocolateyに任せる運用をしています。
Chocolateyでソフトウェアをバージョンアップさせるには、以下のコマンドを実行します。

```
> cup all
```

これを定期的に実行するようにすればよいでしょう。

#### ちなみに、OneGetの話

Windows 10からはOneGetというChocolateyに似た仕組みが標準実装されるらしいです。OneGetはChocolateyリポジトリもサポートされるらしく、将来的には乗り換えるかも。

[My little secret : Windows PowerShell OneGet - Garrett Serack: Senior Open Source Engineer - Site Home - MSDN Blogs](http://blogs.msdn.com/b/garretts/archive/2014/04/01/my-little-secret-windows-powershell-oneget.aspx)

## メモ

- まだまだ、手動でインストール・設定することが多い…
- Linuxのdotfile管理みたいなのは、Windowsだとレジストリかな。レジストリを保存しておいて、Chocolateyインストール→レジストリを復元、で設定を復元できないかなぁ。そんなに綺麗にはできないよなぁ…
