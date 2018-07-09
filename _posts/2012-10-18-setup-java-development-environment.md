---
layout: single
title: "Java開発環境構築手順"
tags:
  - "Eclipse"
  - "Setup"
date: 2012-10-18 04:32:00+09:00
redirect_from:
  - /2012/10/java.html
---

個人的なJava開発環境の構築手順をメモします。普段は、構築後のフォルダをzipアーカイブして持ち歩き、Java開発環境を構築するときはアーカイブを展開するだけで簡単に構築できるようにしています(一部、インストールが必要ですが)。

## 開発環境の目的

以下を行うための環境を構築します。

* GAE/jを使用するWebアプリケーションの作成
* Androidアプリケーションの作成

以下は考慮しません。

* GWTの使用。jQueryなどのJavaScriptライブラリを使用するため。
* SVN、Gitなどのバージョン管理ツールのEclipseからの利用。gitコマンドやTortoiseGitを使用するため。

## 構築手順

構築手順を説明します。なお、`C:\eclipse\`にもろもろ展開していきますが、別の場所に展開する場合は、適宜読み替えてください。

### Java SDKをセットアップ

[Java SE Downloads](http://www.oracle.com/technetwork/java/javase/downloads/index.html)からJava SDKのインストールファイルをダウンロードしてインストールします。

### Jadをセットアップ

[JadClipseの設定方法](http://works.dgic.co.jp/djwiki/Viewpage.do?pid=@4A6164436C69707365)からJadのzipファイルをダウンロードして、`C:\eclipse\`に展開します。`C:\eclipse\Jad\`が作成されます。ついでに、JadClipseのzipファイルもダウンロードしておきます。

### SQLiteStudioをセットアップ

[SQLiteStudio](http://sqlitestudio.one.pl/index.rvt)から実行ファイルをダウンロードして、`C:\eclipse\sqlitestudio\`にコピーします。

### Eclipseをセットアップ

[Eclipse](http://eclipse.org/)から`Eclipse IDE for Java EE Developers`のzipアーカイブをダウンロードして、`C:\eclipse\eclipse\`に展開します。

#### `eclipse.ini`を修正

`eclipse.ini`の以下の点を修正します。

* `-Xms`、`-Xmx`を同じ値にします。

```
-Xms512m
-Xmx512m
```

#### 起動、ワークスペースを作成

Eclipseを起動します。ワークスペースを`C:\eclipse\workspace\`に作成します。

> **tips: ** 起動に失敗する場合、`eclipse.ini`の`-Xms`、`-Xmx`の値が影響している可能性があります。詳細はググってください。

#### Eclipseプラグインをインストール

以下のEclipseプラグインをインストールします。

* [Eclipse-Checkstyle Integration](http://eclipse-cs.sourceforge.net/)
* [FindBugs](http://findbugs.sourceforge.net/)
* [プロパティエディタ](http://propedit.sourceforge.jp/)
* [JadClipse](http://works.dgic.co.jp/djwiki/Viewpage.do?pid=@4A6164436C69707365)
* [Google Plugin for Eclipse](https://developers.google.com/eclipse/)
    * GAE/jだけじゃなく、Android SDKもインストールされるようです。
    * よく使用するバージョンのコンポーネント(1.6, 2.2, 2.3, 3.2, 4.x)、Google APIs、などなどをインストールします。
    * かなり時間がかかります。
    * インストールが完了したら、Eclipse右下の`Sign in to Google...`をクリックしてサインインします。

### 設定

[Window]→[Preference]をクリックして設定を開き、以下のように設定します。

- General
    - Always run in background = チェック
    - Show heap status = チェック
- General / Appearance
    - Theme = Classic
- General / Appearance / Colors and Fonts
    - Basic / Text Font = Use System Fontをクリック
- General / Editors / Text Editors
    - Undo history size = 9999
    - Insert spaces for tabs = チェック
    - Show line numbers = チェック
- General / Editors / Text Editors / Spelling
    - Enable spell checking = アンチェック
- General / Workspace
    - Text file encoding = Other: UTF-8
    - New text file line delimiter = Other Windows
- Java / Code Style / Formatter
    - "Eclipse [build-in]"を元に作成します。
    - Indentation
        - Tab policy = Spaces only
        - Statements within 'switch' body = チェック
    - Blank Lines
        - Before package declaration = 1
        - Before first declaration = 1
        - Before field declarations = 1
    - New Lines
        - at end of file = チェック
    - Line Wrapping
        - Maximum line width = 9999
    - Comments
        - Maximum line width for comments = 9999
- Java / Compiler
    - Compiler compilance level = 1.6
        - JDK 1.7を使用している場合は警告が表示されますので、JDK 1.6を追加します。
- Java / Editor / Content Assist
    - Auto Activation
        - Enable auto activation = アンチェック
- JavaScript / Code Style / Formatter
    - "Eclipse [build-in]"を元に作成します。
    - Indentation
        - Tab policy = Spaces only
        - Statements within 'switch' body = チェック
    - New Lines
        - at end of file = チェック
    - Line Wrapping
        - Maximum line width = 9999
    - Comments
        - Maximum line width for comments = 9999
- Team / CVS / Label Decorations
    - Text Decorations
        - Outgoing Change flag = ■
        - Added flag = ◆
- Validation
    - "Disable All"をクリックします。
- Web / CSS Files
    - Encoding = ISO 10646/Unicode(UTF-8)
- Web / CSS Files / Editor
    - Line width = 999
    - Indent using spaces = チェック
    - Indentation size = 4
- Web / HTML Files
    - Encoding = ISO 10646/Unicode(UTF-8)
- Web / HTML Files / Editor
    - Line width = 999
    - Indent using spaces = チェック
    - Indentation size = 4
- Web / JSP Files
    - Encoding = ISO 10646/Unicode(UTF-8)
- XML / XML Files / Editor
    - Line width = 999
    - Split multiple attributes each on a new line = チェック
    - Preserve whitespace in tags with PCDATA content = チェック
    - Indent using spaces = チェック
    - Indentation size = 4

### 動作確認

動作確認として、以下を行います。

* Hello Worldレベルの簡単なJavaアプリケーションを作成
* Androidアプリケーションを作成
* GAE/jアプリケーションを作成

以上で、Eclipseの設定は完了です。お疲れ様でした。Enjoy Coding!
