---
title: "vimメモ"
tags: ["vim"]
date: 2015-01-27 00:22:00+09:00
published: false
parmalink: "vim"
postID: 3891526165270914087
---

長らくWindowsでサクラエディタを使っていましたが、Linuxではvi、MacではCotEditorを申し訳程度に使っているだけでした。で、いい加減各プラットフォームでちゃんと使えるテキストエディタが欲しくなり、vimを使うことになりました。

ここでは、vimで自分がよく使う操作方法、各プラットフォームごとのツールをメモします。**まだ調査中で、使い慣れてきたら更新します。**

<!-- more -->

# 操作方法

## カーソル移動

|キー|操作|
|---|---|
|$|行末|
|^|行頭|
|gg|ファイル先頭|
|G|ファイル末尾|
|Ctrl+f|1画面次|
|Ctrl+b|1画面前|
|Ctrl+g|現在位置を表示|

## 編集

|キー|操作|
|---|---|
|u|アンドゥ|
|Ctrl+r|リドゥ|
|v|領域選択を開始|
|Ctrl+v|矩形選択を開始|
|Shift+v|行選択を開始|
|y|コピー|
|d|カット|
|p|ペースト|

## 検索・置換

|キー|操作|
|---|---|
|/word|wordを検索(n…次の候補、N…前の候補)|
|?word|wordを逆方向に検索|

## キーマクロ

|キー|操作|
|---|---|
|qa操作の記録を開始し、レジスタaに保存|
|q|操作の記録を終了|
|@a|レジスタaに保存された操作を再生|
|5@a|レジスタaに保存された操作を5回再生|

## ウィンドウ分割

|キー|操作|
|---|---|
|:split|画面を上下に分割|
|:vsplit|画面を左右に分割|
|:q|ウィンドウを削除|
|Ctrl+w w|別のウィンドウに移動|

## その他設定

|キー|操作|
|---|---|
|:set tabstop=4|タブ幅を設定|
|:set autoindent|自動インデントを設定|
|:set fileencoding=utf-8|文字コードを設定|
|:set fileformat|改行コードをdos(CR+LF)に設定|
|:set number|行番号を表示|

## プラグイン

ToDo これから調査。NeoBundleを使うらしい。

## 関連ファイル設定

ToDo これから調査

## 設定のエクスポート、インポート

ToDo これから調査。`.vimrc`らしい。

# プラットフォームごとのツール

* Linux
    * vimコマンド
* Windows
    * [Vim](https://chocolatey.org/packages/vim)
        * `cinst vim`
    * [GVim](http://www.vector.co.jp/soft/win95/writing/se117961.html)
    * cygwinのvimコマンド
* Mac
    * [macvim](https://code.google.com/p/macvim/)
        * Homebrewでインストールできるらしいが、情報が錯綜している？

# 参考

* [僕がサクラエディタからVimに乗り換えるまで](http://blog.jnito.com/entry/20120101/1325420213)
* [vimの使い方](http://seesaawiki.jp/w/yoynizi9691/d/vim%A4%CE%BB%C8%A4%A4%CA%FD)
* [チュートリアルでvimエディタの使い方を覚えよう](http://nanasi.jp/articles/howto/install/tutorial.html)
* [初心者でもわかるvimの使い方入門](http://matome.naver.jp/m/odai/2133561662251169101)
* [脱初心者を目指すVimmerにオススメしたいVimプラグインや.vimrcの設定](http://qiita.com/jnchito/items/5141b3b01bced9f7f48f)
* [NeoBundleの導入](http://qiita.com/puriketu99/items/1c32d3f24cc2919203eb)
* [そろそろしっかりvimを使う。dotfilesのgithub管理とvundleの導入。](http://holypp.hatenablog.com/entry/20110515/1305443997)
* [vimエディタで「文字コード、改行コードを変更して保存する。」](http://advweb.seesaa.net/article/3074705.html)
