---
layout: single
title: "Sidekiqサンプル on Docker"
tags:
  - "Docker"
  - "Ruby on Rails"
  - "Sidekiq"
  - "ジョブ管理"
date: 2018-04-26 23:50:00+09:00
---

TODO sample-sidekiqプロジェクトのREADMEをコピーしたので、当記事用に修正する。

> Sidekiqのサンプル。

## Install

Dockerを使用します。あらかじめインストールしておいてください。

```
$ sudo docker version
Client:
 Version:       18.03.0-ce
 API version:   1.37
 Go version:    go1.9.4
 Git commit:    0520e24
 Built: Wed Mar 21 23:10:06 2018
 OS/Arch:       linux/amd64
 Experimental:  false
 Orchestrator:  swarm

Server:
 Engine:
  Version:      18.03.0-ce
  API version:  1.37 (minimum version 1.12)
  Go version:   go1.9.4
  Git commit:   0520e24
  Built:        Wed Mar 21 23:08:35 2018
  OS/Arch:      linux/amd64
  Experimental: false
```

他のソフトウェアは、全てDockerコンテナ内でインストールするので、ホストPCにインストールする必要はありません。

## Development

まっさらの状態からSidekiqのワーカーを実行するまでの手順を説明します。

### Railsプロジェクトを作成

Railsプロジェクトを作成します。RubyがインストールされているPCであれば `rails new .` で済みますが、ここではrubyコンテナの中でRailsプロジェクトを作成します。

まず、rubyコンテナを起動します。

```
$ sudo docker run --rm -it -v $(pwd):/var/myapp -w /var/myapp ruby bash
```

`-v` オプションで、カレント・フォルダをコンテナ内の `/var/myapp` フォルダに割り当てます。そして `-w` オプションで、コンテナ起動直後の作業フォルダを `/var/myapp` フォルダに設定しています。

Ruby on Railsをインストールします。

```
# gem install rails
```

カレント・フォルダにRailsプロジェクトを作成します。

```
# rails new .
```

作成したら、 `ls` でファイルを確認してみます。ファイルを確認したら、 `Ctrl-d` でコンテナからログアウトします。

### Gemfileに `sidekiq` を追加

Sidekiqはgemで提供されているので、 `Gemfile` ファイルに追加します。

```
gem 'sidekiq'
```

また、 `Gemfile` ファイルの余計なコメント行を削除します。結果、次のように修正します(バージョンは当サンプル作成時期により異なります)。

```
$ cat Gemfile
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'sqlite3'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

### Dockerコンテナ化

`rails` コマンドを使用したり動作確認するため、早々にDockerコンテナ化します。

簡単にSidekiqを使用したコンテナ構造を説明すると、次のように構成します。ちなみに、今回はRailsアプリケーションが使用するDBとしてSQLiteを指定しているため、DBコンテナは構成しません。

![コンテナ構造](http://www.plantuml.com/plantuml/png/NO_12SCm34Nlca8BP84IJ5PHxNy8RMHNbcZ7Rqm3RNCmVFnu3xHq5_FOxYJPgt5q6EMwjQfGPscDvpbNTLaLbX8LSRbA1nlAsa_mApwhtM0dJAFEqvH6b_OtzX6wCFGH2D2XJj5-OC4_tD5d3l6578xZWnPesGzw0m00)

まず、アプリケーション用コンテナの `Dockerfile` ファイルを作成します。

```
$ cat Dockerfile
FROM ruby:2.5

RUN apt-get update && \
    apt-get install -y \
        nodejs && \
    apt-get clean

VOLUME /var/myapp
WORKDIR /var/myapp

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
```

次に、上図で説明したコンテナ構造を構成するため、 `docker-compose.yml` ファイルを作成します。

```
$ cat docker-compose.yml
version: '3'

services:
  app:
    build: .
    environment:
      - "RAILS_ENV=development"
      - "REDIS_URL=redis://redis:6379"
    volumes:
      - ".:/var/myapp"
    ports:
      - "3000:3000"
    depends_on:
      - "redis"
  worker:
    build: .
    environment:
      - "RAILS_ENV=development"
      - "REDIS_URL=redis://redis:6379"
    volumes:
      - ".:/var/myapp"
    depends_on:
      - "redis"
    command: sidekiq
  redis:
    image: redis:4.0
    volumes:
      - "redis:/data"
    command: redis-server --appendonly yes

volumes:
  redis:
    driver: local
```

手順が間違えていなければ、イメージをビルドして、Railsアプリケーションを起動することができます。試しに、動作確認してみます。

イメージをビルドします。

```
$ sudo docker-compose build
```

コンテナを起動します。

```
$ sudo docker-compose up -d
```

Webブラウザで http://localhost:3000 を開くか `curl` コマンドでGETリクエストすると、Welcomeページが表示されます。

### ワーカーを作成

Sidekiqで実行するワーカーを作成します。

`rails g` コマンドで、Helloワーカーを作成します。

```
$ sudo docker-compose exec app rails g sidekiq:worker Hello
```

これにより、ワーカーとそのテスト・コードが作成されます。今回はワーカーのみ実装します。 `app/worker/hello_worker.rb` ファイルに `puts "hello"` コードを追加します。結果、次のように修正します。

```
$ cat app/workers/hello_worker.rb
class HelloWorker
  include Sidekiq::Worker

  def perform(*args)
    puts "hello"
  end
end
```

### ワーカーを実行

いよいよ、作成したワーカーをSidekiqで実行してみます。

Sidekiqは変更したソースコードを自動では読み込んでくれないので、いったんコンテナを終了します。

```
$ sudo docker-compose down -v
```

コンテナを起動します。

```
$ sudo docker-compose up -d
```

appコンテナのRailsコンソールを起動します。

```
$ sudo docker-compose exec app rails c
```

ワーカー・クラスの `perform_async` メソッドを呼び出すことで、ワーカーをキューに登録します。

```
> HelloWorker.perform_async
```

正常に登録された場合、IDのような文字列が表示されます。エラーとなってしまいスタックとレースが表示された場合、これまでに作成したファイルや手順のどこかが間違えています。

今、キューに登録したワーカーはすぐに実行されます。workerコンテナのログを確認します。

```
$ sudo docker-compose logs worker
Attaching to sample-sidekiq_worker_1
worker_1  | 2018-04-25T10:30:08.008Z 1 TID-gses4fdh1 INFO: Booting Sidekiq 5.1.3 with redis options {:url=>"redis://redis:6379", :id=>"Sidekiq-server-PID-1"}
worker_1  | 2018-04-25T10:30:08.111Z 1 TID-gses4fdh1 INFO: Running in ruby 2.5.1p57 (2018-03-29 revision 63029)[x86_64-linux]
worker_1  | 2018-04-25T10:30:08.111Z 1 TID-gses4fdh1 INFO: See LICENSE and the LGPL-3.0 for licensing details.
worker_1  | 2018-04-25T10:30:08.111Z 1 TID-gses4fdh1 INFO: Upgrade to Sidekiq Pro for more features and support: http://sidekiq.org
worker_1  | 2018-04-25T10:30:08.114Z 1 TID-gses4fdh1 INFO: Starting processing, hit Ctrl-C to stop
worker_1  | 2018-04-25T10:30:25.434Z 1 TID-gsesimoz1 HelloWorker JID-4c48fc655e11bc9ee2cbe82b INFO: start
worker_1  | hello
worker_1  | 2018-04-25T10:30:25.441Z 1 TID-gsesimoz1 HelloWorker JID-4c48fc655e11bc9ee2cbe82b INFO: done: 0.005sec
```

`hello` が出力されており、ワーカーが実行されたことが分かります。

## Links

- [mperham/sidekiq: Simple, efficient background processing for Ruby](https://github.com/mperham/sidekiq)
- [sidekiqの使い方 - Qiita](https://qiita.com/nysalor/items/94ecd53c2141d1c27d1f)
- [Sidekiq について基本と1年半運用してのあれこれ - まっしろけっけ](http://shiro-16.hatenablog.com/entry/2015/10/12/192412)
- [Sidekiq アンチパターン: 序 - SmartHR Tech Blog](http://tech.smarthr.jp/entry/2017/04/20/165555)

# Link

- Author
    - [u6k.Blog()](https://blog.u6k.me/)
    - [u6k - GitHub](https://github.com/u6k)
    - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
    - [2018-02-18-this-week-i-learned.md](https://github.com/u6k/blog/blob/master/_posts/2018-02-18-this-week-i-learned.md)
