---
layout: post
title: "rbenvを使用したRuby環境構築 (Raspbian)"
tags:
  - "Raspberry Pi"
  - "Ruby"
date: 2015-01-23 20:00:00+09:00
redirect_from:
  - /2015/01/rbenvruby-raspbian.html
---

Raspberry Pi(Raspbian)にrbenvを使用してRuby環境を構築したので、手順メモを残します。と言っても、[Ruby - rbenv のインストール (Linux Mint) - Qiita](http://qiita.com/tsubu-mustard/items/3f818bf9831a4a934c5a)に従っただけですが。

<!-- more -->

# 完了状態

* Ruby 2.2.0が使用可能。

# 作業手順

`rbenv`を`git clone`します。

```
$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
```

`.bashrc`に追記します。

```
# rbenv
PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

`.bashrc`を再読み込みします。

```
$ source .bashrc
```

`ruby-build`を`git clone`します。

```
$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```

依存パッケージをインストールします。

```
$ sudo aptitude install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
```

インストールできるRubyのバージョンを確認します。

```
$ rbenv install --list
```

Rubyをインストールします。すごく時間がかかったので、`screen`の中で行いました。

```
$ sudo rbenv install 2.2.0
$ sudo rbenv rehash
$ rbenv versions
```

`rbenv versions`でインストールしたバージョンが表示されるはずです。

デフォルトで使用するRubyのバージョンを設定します。

```
$ rbenv global 2.2.0
$ ruby -v
```

`ruby -v`で設定したバージョンが表示されるはずです。

# 参考

* [sstephenson/rbenv](https://github.com/sstephenson/rbenv)
* [Home ・ sstephenson/ruby-build Wiki](https://github.com/sstephenson/ruby-build/wiki)
