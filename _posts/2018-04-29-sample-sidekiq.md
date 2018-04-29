---
layout: single
title: "Sidekiq on Dockerサンプル"
tags:
  - "Docker"
  - "Ruby on Rails"
  - "Sidekiq"
  - "Cron"
  - "ジョブ"
date: 2018-04-29 00:00:00+09:00
---

この記事では、SidekiqをDockerコンテナで動作させるためのセットアップ、実行手順を説明します。

# はじめに

Rubyでジョブ管理を行おうと考えたとき、[Resque](https://github.com/resque/resque)、[Delayed::Job](https://github.com/collectiveidea/delayed_job)、[Sidekiq](https://github.com/mperham/sidekiq)などの仕組みがあります。さらに定期的にジョブを実行したいと思い方法を探していると、[Sidekiq-Cron](https://github.com/ondrejbartas/sidekiq-cron)や[sidekiq-scheduler](https://github.com/moove-it/sidekiq-scheduler)の解説が多く見られました。このため、Sidekiqを使うことにしました。

なお、Rails 5ではジョブ実装の共通的な仕組みとして[Active Job](https://railsguides.jp/active_job_basics.html)が使えますが、Active Jobがsidekiq-schedulerなどで使えるか分からなかったので、今回はSidekiqをそのまま使うことにしました。

今回の手順で作成したプロジェクトは、 [u6k/sample-sidekiq](https://github.com/u6k/sample-sidekiq/) にあります。

# 前提

筆者はRails開発をvim + Dockerで行っており、ホストPCにRubyをインストールしてはいません。Dockerおよびdocker-composeを使用しますので、あらかじめインストールしておいてください。

```
$ docker version
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

```
$ docker-compose --version
docker-compose version 1.21.0, build 5920eb0
```

上記は筆者の環境ですが、Docker環境であればOSは問わないはずです。

エディターは、お好みのものを使いましょう。vimでもさくらエディタでもAtomでもVisual Studio Codeでも問題ありません。

手順の説明は、なるべくDockerなどの知識がなくてもコピペすれば動作するように書いてあります。ただ、最低限のシェルの知識は必要になります。環境によっては権限設定により一般ユーザーでは動作しないかもしれません。rootになるなり `sudo` するなりしましょう。

RubyやRailsなど他のソフトウェアは、全てDockerコンテナ内でインストールするので、ホストPCにインストールする必要はありません。

# セットアップ、実行手順

次に、Railsプロジェクトを作成してからジョブを実行するまでの手順を説明します。

## Railsプロジェクトを作成

Railsプロジェクトを作成します。ホストPCにRubyがセットアップ済みであれば `rails new .` を実行すれば良いですが、ここではrubyコンテナの中でRailsプロジェクトを作成します。

まず、rubyコンテナを起動します。

```
$ docker run --rm -it -v $(pwd):/var/myapp -w /var/myapp ruby bash
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

作成したら、 `ls` でファイルを確認してみます。Railsプロジェクトのファイルが作成されていることを確認したら、 `Ctrl-d` でコンテナからログアウトします。

## Gemfileに `sidekiq` を追加

Sidekiqはgemで提供されているので、 `Gemfile` ファイルに追加します。

```
gem 'sidekiq'
```

また、 `Gemfile` ファイルの余計なコメント行を削除します。結果、次のように修正します(バージョンは時期により異なります)。

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

## Dockerコンテナ化

`rails` コマンドを使用したり動作確認するため、早々にDockerコンテナ化します。

簡単にSidekiqを使用したコンテナ構造を説明すると、次のように構成します。ちなみに、今回はRailsアプリケーションが使用するDBとしてSQLiteを指定しているため、DBコンテナは構成しません。

{% plantuml %}
actor user
component app <<container>>
database redis <<container>>
component worker <<container>>

user --> app
app --> redis : enqueue
worker -up-> redis : dequeue
worker --> worker : execute worker
{% endplantuml %}

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
$ docker-compose build
```

コンテナを起動します。

```
$ docker-compose up -d
```

Webブラウザで http://localhost:3000 を開くか `curl` コマンドでGETリクエストすると、Welcomeページが表示されます。

![rails welcome page](/assets/img/2018-04-29-sample-sidekiq/rails-welcome-page.jpeg)

## ダッシュボードへのルートを設定

Sidekiqはジョブがどのような状態かを確認するためのダッシュボードを提供しています。ダッシュボードにアクセスするには、 `config/routes.rb` ファイルにルートを設定します。

`sidekiq/web` をrequireします。

```
require 'sidekiq/web'
```

ダッシュボードへのルートを設定します。次のように設定すると、 http://localhost:3000/sidekiq でダッシュボードにアクセスできます。

```
mount Sidekiq::Web, at: '/sidekiq'
```

結果、 `config/routes.rb` ファイルは次のようになります。

```
$ cat config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
end
```

## ワーカーを作成

Sidekiqで実行するワーカーを作成します。

`rails g` コマンドで、Helloワーカーを作成します。

```
$ docker-compose exec app rails g sidekiq:worker Hello
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

## ワーカーを実行

いよいよ、作成したワーカーをSidekiqで実行してみます。

Sidekiqは変更したソースコードを自動では読み込んでくれないので、いったんコンテナを終了します。

```
$ docker-compose down -v
```

コンテナを起動します。

```
$ docker-compose up -d
```

appコンテナのRailsコンソールを起動します。

```
$ docker-compose exec app rails c
```

ワーカー・クラスの `perform_async` メソッドを呼び出すことで、ワーカーをキューに登録します。

```
> HelloWorker.perform_async
```

正常に登録された場合、IDのような文字列が表示されます。エラーとなってしまいスタックトレースが表示された場合、これまでに作成したファイルや手順のどこかが間違えています。

今、キューに登録したワーカーはすぐに実行されます。workerコンテナのログを確認します。

```
$ docker-compose logs worker
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

また、 http://localhost:3000/sidekiq にアクセスすると、次のようにダッシュボードが表示されます。

![sidekiq dashboard](/assets/img/2018-04-29-sample-sidekiq/sidekiq-dashboard.jpeg)

## SidekiqをCron化

ここまでの作業で、Sidekiqを使ったジョブの実行ができるようになりました。単純にジョブを実行するだけであれば、ここまでで終わりです。

ここからは、sidekiq-cronを使ってジョブを定期的に実行してみます。

## `Gemfile` と `routes.rb` を修正

sidekiq-cronの設定は簡単で、2ファイルを修正するだけです。

`Gemfile` ファイルを修正します。 `sidekiq` の後に `sidekiq-cron` を追加します。

```
$ cat Gemfile

...(略)...
gem 'sidekiq'
gem 'sidekiq-cron'
...(略)...
```

`config/routes.rb` ファイルを修正します。 `require 'sidekiq/web'` の後に `require 'sidekiq/cron/web'` を追加します。

```
$ cat config/routes.rb
require 'sidekiq/web'
require 'sidekiq/cron/web'
...(略)...
```

これで、ジョブを定期実行する準備は完了です。ワーカーを変更する必要はありません。

## ジョブを定期実行

Dockerコンテナを停止して、起動して、Railsコンソールを起動します。

```
$ docker-compose down -v
$ docker-compose up -d
$ docker-compose exec app rails c
```

ジョブを定期実行する場合は、 `Sidekiq::Cron::Job.create` を呼び出します。

```
> Sidekiq::Cron::Job.create name: "Hello Job", cron: "* * * * *", class: "HelloWorker"
2018-04-27T04:26:05.562Z 50 TID-govsxyfv2 INFO: Cron Jobs - add job with name: Hello Job
=> true
```

これでジョブの定期実行が開始されます。しばらくしてから、workerコンテナのログを確認します。

```
$ sudo docker-compose logs worker
worker_1  | 2018-04-27T04:27:25.246Z 1 TID-grpm2wxhh HelloWorker JID-f746b9ad3c0740cd2bbee4fb INFO: start
worker_1  | hello
worker_1  | 2018-04-27T04:27:25.267Z 1 TID-grpm2wxhh HelloWorker JID-f746b9ad3c0740cd2bbee4fb INFO: done: 0.02 sec
worker_1  | 2018-04-27T04:28:05.080Z 1 TID-grpm2x371 HelloWorker JID-51fce69dc54f378fad381750 INFO: start
worker_1  | hello
worker_1  | 2018-04-27T04:28:05.081Z 1 TID-grpm2x371 HelloWorker JID-51fce69dc54f378fad381750 INFO: done: 0.001 sec
worker_1  | 2018-04-27T04:29:15.094Z 1 TID-grpm2x0dx HelloWorker JID-f0d933d3cda1de168afe4914 INFO: start
worker_1  | hello
worker_1  | 2018-04-27T04:29:15.096Z 1 TID-grpm2x0dx HelloWorker JID-f0d933d3cda1de168afe4914 INFO: done: 0.002 sec
```

約1分ごとにジョブが実行されています。

どのようなジョブが定期実行されているかは、Sidekiqダッシュボードで確認できます。Sidekiqダッシュボードのメニューに"Cron"が追加されています。

![sidekiq dashboard 2](/assets/img/2018-04-29-sample-sidekiq/sidekiq-dashboard-2.jpeg)

Cronページを見ると、登録したジョブが表示されます。

![sidekiq dashboard cron](/assets/img/2018-04-29-sample-sidekiq/sidekiq-dashboard-cron.jpeg)

# おわりに

このように、Railsアプリケーションに簡単に定期実行ジョブを追加することができました。アプリケーション固有の、クリーンアップ処理や単純な集計バッチ処理などであれば、これで十分だと思います。

一方、「ジョブ管理システム」として考えると、いろいろと機能が不足しています。ジョブネット、ジョブごとのワークスペース、ジョブ実行履歴、など。そういった機能が必要な場合は、やはりジョブ管理専用のサービスを使うことになると思います。

# 参考リンク

- [mperham/sidekiq: Simple, efficient background processing for Ruby](https://github.com/mperham/sidekiq)
- [sidekiqの使い方 - Qiita](https://qiita.com/nysalor/items/94ecd53c2141d1c27d1f)
- [Sidekiq について基本と1年半運用してのあれこれ - まっしろけっけ](http://shiro-16.hatenablog.com/entry/2015/10/12/192412)
- [Sidekiq アンチパターン: 序 - SmartHR Tech Blog](http://tech.smarthr.jp/entry/2017/04/20/165555)
- [ondrejbartas/sidekiq-cron: Scheduler / Cron for Sidekiq jobs](https://github.com/ondrejbartas/sidekiq-cron)

# Link

- Author
  - [u6k.Blog()](https://blog.u6k.me/)
  - [u6k - GitHub](https://github.com/u6k)
  - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
  - [2018-04-29-sample-sidekiq.md](https://github.com/u6k/blog/blob/master/_posts/2018-04-29-sample-sidekiq.md)
