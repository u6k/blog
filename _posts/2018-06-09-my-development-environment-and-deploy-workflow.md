---
layout: single
title: "個人開発環境の構成、およびデプロイ・フロー"
tags:
  - "Docker"
  - "git"
  - "DigitalOcean"
  - "Travis CI"
  - "Rundeck"
  - "サーバー"
  - "設計"
date: 2018-06-09 00:00:00+09:00
---

個人的にいくつかのアプリケーションを開発していまして、おひとりさま開発なので環境構築からリリース、運用まで全て自分で行っています。これらの作業の手間やミスを減らすため、可能な限り自動化しています。

この記事では、開発環境として利用しているサービス、およびデプロイ・フローの概要を説明します。





# 開発基盤とは

- 開発してからリリースするまでの作業を効率化するために利用しているサービス群のこと
- 作成したソースコードやドキュメントの管理、実行可能イメージや各種レポートの作成やデプロイ、およびこれらのサービスの構築などを手動で行うことは、効率的ではない。
- なるべく外部のサービスを利用すると共に、自動でリリースの直前まで行われるようにしている。

# 開発基盤の構造

次のサービス群と流れで、開発からリリースまでの作業を行っている。

{{plantuml(svg)
actor "開発者" as developer
actor "利用者" as user
node "開発PC" {
  [Docker] as docker_dev
  database "local git repo" as git
}
database "GitHub" <<外部サービス>> as github
[TravisCI] <<外部サービス>> as travisci
database "Docker Hub" <<外部サービス>> as docker_hub
[Slack] as slack
node "本番サーバー" {
  [Rundeck] as rundeck
  [Docker] as docker_pro
}

developer -d-> docker_dev : 開発
docker_dev -- git : git commit
git --> github : git push
github --> travisci
travisci --> docker_hub : docker push
travisci --> slack : ビルド結果通知
slack -l-> developer : 通知
travisci --> rundeck : ジョブ起動
rundeck -- docker_hub : docker-compose\npull
rundeck --> docker_pro : docker-compose\nup
rundeck --> slack : ジョブ結果通知
user -u-> docker_pro : サービス利用
}}

# サービスの役割

サービスごとの役割を説明する。

## 開発PC

ホストOSには基本的に、エディター、Docker、gitがインストールされており、開発作業はDockerで行っている。処理系が混在するのでホストOSを汚したくないのと、なるべく本番Dockerコンテナ構造に近い構成で開発をしたいため。

開発PCが手元にない場合、本番サーバーでvimとgitで開発を行うことがある。というか、最近は仕事の都合でノートPCを持ち歩けないため、スマホから本番サーバーにsshして作業することが多い。

開発PCの場合、VisualStudioCode + SourceTreeを使うことが多い。本番サーバーの場合、vim + git-flow + tig + tmuxで作業を行う。

- [Docker Documentation | Docker Documentation](https://docs.docker.com/)
- [Visual Studio Code - Visual Studio](https://www.microsoft.com/ja-jp/dev/products/code-vs.aspx)
- [Git](https://git-scm.com/)
- [welcome home : vim online](https://www.vim.org/)
- [Sourcetree | Free Git GUI for Mac and Windows](https://www.sourcetreeapp.com/)
- [nvie/gitflow: Git extensions to provide high-level repository operations for Vincent Driessen's branching model.](https://github.com/nvie/gitflow)
- [jonas/tig: Text-mode interface for git](https://github.com/jonas/tig)
- [tmux/tmux: tmux source code](https://github.com/tmux/tmux)

## GitHub

言わずと知れている、ソフトウェア開発プロジェクトのホスティング・サービス。主にソースコードの管理をしている。課題やWikiなどはu6k.Redmineで管理しているため、GitHubでは管理していない。

GitHubにプッシュすると、Travis CIに通知され、ビルドが開始される。

- [The world’s leading software development platform · GitHub](https://github.com/)

## Travis CI

CIサービス。Travis CIでは、コンパイル、テスト、ドキュメント生成、プロジェクト静的解析、実行可能イメージを生成、などのビルド作業を行う。特にGitタグがプッシュされたとき(つまりリリースしたとき)は、実行可能イメージをDocker Hubにアップロードして、u6k.Rundeckに通知してデプロイを行う(サービスによる)。

ビルド生成物は、Docker Hubの他に、GitHub Pages、u6k.Minioなどにもアップロードする。

ビルド作業の結果は、Slackで通知される。

GitHubのプルリクエストは、原則としてTravis CIのビルドがパスしないとマージできないように設定している。

- [Travis CI - Test and Deploy Your Code with Confidence](https://travis-ci.org/)

## Slack

チャット・サービス。個人開発では、自分だけのSlackワークスペースに`#build`チャンネルを作成して、Travis CIのビルド結果が通知されるようにしている。Travis CIのコンソールを眺めていなくても、通知を待っていれば良い。

Slackには他にも、サービス監視によるアラート、バッチ処理失敗などが通知されるようになっている。

- [よりシームレスなチームワークを実現する、ビジネスコラボレーションハブ | Slack](https://slack.com/)

## Docker Hub

Dockerイメージのホスティング・サービス。gitタグがプッシュされた場合、Travis CIでビルドしたDockerイメージをDocker Hubにプッシュする。個人開発は基本的にオープンソースとしているので、Dockerイメージの管理もDocker Hubのようなオープンな場でも問題ない。

以前は、Docker HubによるAutomated Buildを利用していたが、どうも思ったタイミングでビルドしてくれないので、Travis CIでビルドしている。

仕事やプライベートにしたい個人開発の場合は、GitLabのDockerリポジトリを利用する。

- [Docker Hub](https://hub.docker.com/)
- [GitLab Container Registry | GitLab](https://docs.gitlab.com/ce/user/project/container_registry.html)

## Rundeck

ジョブ・スケジューラー。バッチ処理を管理、実行しているが、一部のDockerコンテナの制御もジョブとして実行できるようにしている。

Travis CIがDocker Hubにプッシュしたあと、RundeckのAPIを呼び出してジョブを起動する。ジョブは`docker-compose pull`、`down`、`up -d`を行う。これにより、Gitタグをプッシュすると、最終的に最新バージョンのサービスが起動する。同時に、RundeckがSlackにジョブ実行結果を通知する。

- [Rundeck Pro | Modern IT Operations Management Platform](https://www.rundeck.com/)

## 本番サーバー

[ほとんどのサービスはDockerコンテナで動作](https://redmine.u6k.me/projects/os-setup/wiki/%E3%82%BD%E3%83%95%E3%83%88%E3%82%A6%E3%82%A7%E3%82%A2%E8%A8%AD%E8%A8%88)している。よって、本番サーバーにはDockerと最小限のソフトウェアのみがインストールされている。このため、以前はCoreOSで運用していた時期もあった。現在は、もう少しソフトウェアをインストールしたくて、Debianで運用している。

ストレージ・サイズの関係で、基本的には自宅マシンをサーバーとして運用しているが、出張や旅行などで長期間自宅を離れる場合は、DigitalOceanなどのIaaSに一時的に移行して、帰宅後に切り戻す。この場合でも、DNS設定の変更とデータの移行が少々面倒なだけで、OSとDockerコンテナのセットアップはAnsibleで簡単に実行できるようにしている。

- [自宅サーバーやVPSに使える無料のダイナミックDNS (Dynamic DNS) | MyDNS.JP](https://www.mydns.jp/)
- [DigitalOcean: Cloud Computing, Simplicity at Scale](https://www.digitalocean.com/)
- [Open source, containers, and Kubernetes | CoreOS](https://coreos.com/)
- [Debian -- ユニバーサルオペレーティングシステム](https://www.debian.org/)

# Link

- Author
  - [u6k.Blog()](https://blog.u6k.me/)
  - [u6k - GitHub](https://github.com/u6k)
  - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
  - [2018-06-09-my-development-environment-and-deploy-workflow.md](https://github.com/u6k/blog/blob/master/_posts/2018-06-09-my-development-environment-and-deploy-workflow.md)
