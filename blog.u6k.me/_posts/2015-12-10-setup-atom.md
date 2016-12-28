---
layout: single
title: "Atomセットアップ手順"
tags:
  - "Atom"
  - "Setup"
date: 2015-12-10 22:00:00+09:00
redirect_from:
  - /2015/12/atom-setup.html
---

Atomの自分向けセットアップ手順メモです。

<!-- more -->

# インストール

パッケージ管理ツールでAtomをインストールします。

* Windowsの場合(Chocolatey)
    * cinst atom -y
* OS Xの場合(Homebrew)
    * brew cask install atom

ショートカットを作成します。

# テーマを変更

* UI Theme
    * One Light
* Syntax Theme
    * One Light

# パッケージをインストール

* ~~japanese-wrap~~
    * Atom v1.2で不必要になった。
* markdown-toc
* markdown-pdf
* minimap

# 設定を変更

* Auto Indent On Paste
    * オフ
* Font Family
    * "Migu 1M"
* Preferred Line Length
    * 999
* Show Indent Guide
    * オン
* Show Invisibles
    * オン
* Soft Wrap
    * オン
* Soft Wrap At Preferred Line Length
    * オン
* Tab Length
    * 4
* Tab Type
    * soft

# パッケージの設定を変更

## autocomplete-plus

* Show Suggestions On Keystroke
    * オフ
