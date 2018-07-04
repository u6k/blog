---
layout: single
title: "個人開発基盤の構成、およびデプロイ・フロー"
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

この記事では、開発基盤として利用しているサービス、およびデプロイ・フローの概要を説明します。

## 前提

インターネット上のサービスを利用しています。が、オンプレミスでも類似の基盤を構築することは可能です。具体的には、GitLabでいけるはず。

開発するアプリケーションは、Dockerを前提としています。逆に言えば、Dockerで動作すれば言語処理系は問いません。

この記事では、開発基盤を「開発してからリリースするまでの作業を効率化するために利用しているサービス群」のことを言います。

## 開発基盤の構造

次のサービス群と流れで、開発からリリースまでの作業を行っています。

{% plantuml %}
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
{% endplantuml %}

## サービスの役割

サービスごとの役割を説明します。

### 開発PC

開発PCには基本的に、エディター、Docker、gitがインストールされており、開発作業はDockerで行っています。開発するアプリケーションによって言語処理系が混在するのでOSを汚したくないのと、なるべく本番Dockerコンテナ構造に近い構成で開発をしたいためです。

開発PCが手元にない場合、本番サーバーでvimとgitで開発を行うことがあります。というか、最近は仕事の都合でノートPCを持ち歩けないため、スマホから本番サーバーにsshして作業することが多いです。

開発PCの場合、VisualStudioCode + SourceTreeを使うことが多いです。本番サーバーの場合、vim + git-flow + tig + tmuxで作業を行っています。

- [Docker Documentation \| Docker Documentation](https://docs.docker.com/)
- [Visual Studio Code - Visual Studio](https://www.microsoft.com/ja-jp/dev/products/code-vs.aspx)
- [Git](https://git-scm.com/)
- [welcome home : vim online](https://www.vim.org/)
- [Sourcetree \| Free Git GUI for Mac and Windows](https://www.sourcetreeapp.com/)
- [nvie/gitflow: Git extensions to provide high-level repository operations for Vincent Driessen's branching model.](https://github.com/nvie/gitflow)
- [jonas/tig: Text-mode interface for git](https://github.com/jonas/tig)
- [tmux/tmux: tmux source code](https://github.com/tmux/tmux)

### GitHub

言わずと知れている、ソフトウェア開発プロジェクトのホスティング・サービスです。主にソースコードの管理をしています。課題やWikiなどはu6k.Redmineで管理しているため、GitHubでは管理していません。

GitHubにプッシュすると、Travis CIに通知され、ビルドが開始されます。

- [The world’s leading software development platform · GitHub](https://github.com/)

### Travis CI

CIサービスです。Travis CIでは、コンパイル、テスト、ドキュメント生成、プロジェクト静的解析、実行可能イメージを生成、などのビルド作業を行います。特にGitタグがプッシュされたとき(つまりリリースしたとき)は、実行可能イメージをDocker Hubにアップロードして、u6k.Rundeckに通知してデプロイを行います(一部のサービスのみ)。

ビルド生成物は、Docker Hubの他に、GitHub Pages、u6k.Minioなどにもアップロードします。

ビルド作業の結果は、Slackで通知します。

GitHubのプルリクエストは、原則としてTravis CIのビルドがパスしないとマージできないように設定しています。これにより、焦っていてうっかりビルドを壊してしまうコミットが混入することを防いでいます。

- [Travis CI - Test and Deploy Your Code with Confidence](https://travis-ci.org/)

### Slack

開発者向けのチャット・サービスです。個人開発では、自分だけのSlackワークスペースに`#build`チャンネルを作成して、Travis CIのビルド結果が通知されるようにしています。Travis CIのコンソールを眺めていなくても、通知を待っていれば良い状況にしています。

Slackには他にも、サービス監視によるアラート、バッチ処理失敗などが通知されるようになっています。将来的には、チャット・ボットを飼って、全てチャットから指示できるようにしたいと思っていますが、まだそこまではしていません。

- [よりシームレスなチームワークを実現する、ビジネスコラボレーションハブ \| Slack](https://slack.com/)

### Docker Hub

Dockerイメージのホスティング・サービスです。Gitタグがプッシュされた場合、Travis CIでビルドしたDockerイメージをDocker Hubにプッシュします。個人開発は基本的にオープンソースとしているので、Dockerイメージの管理もDocker Hubのようなオープンな場でも問題ないと考えています。

以前は、Docker HubによるAutomated Buildを利用していましたが、どうも思ったタイミングでビルドしてくれないので、Travis CIでビルドしています。

仕事やプライベートな個人開発の場合は、GitLabのDockerリポジトリを利用しています。

- [Docker Hub](https://hub.docker.com/)
- [GitLab Container Registry \| GitLab](https://docs.gitlab.com/ce/user/project/container_registry.html)

### Rundeck

ジョブ・スケジューラーです。バッチ処理を管理、実行していますが、一部のDockerコンテナの制御もジョブとして実行できるようにしています。

Travis CIがDocker Hubにプッシュしたあと、RundeckのAPIを呼び出してジョブを起動します。ジョブは`docker-compose pull`、`down`、`up -d`を行います。これにより、Gitタグをプッシュすると、最終的に最新バージョンのサービスが起動します。同時に、RundeckがSlackにジョブ実行結果を通知します。

- [Rundeck Pro \| Modern IT Operations Management Platform](https://www.rundeck.com/)

### 本番サーバー

ほとんどのサービスはDockerコンテナで動作(TODO: ソフトウェア設計にリンクを張る)しています。よって、本番サーバーにはDockerと最小限のソフトウェアのみがインストールされています。このため、以前は[CoreOSで運用していた時期](/2017/04/28/my-server-specification-for-hardware.html)もありました。現在は、もう少しソフトウェアをインストールしたくて、Debianで運用しています。

ストレージ・サイズの関係で、基本的には自宅マシンをサーバーとして運用していますが、出張や旅行などで長期間自宅を離れる場合は、DigitalOceanなどのIaaSに一時的に移行して、帰宅後に切り戻します。この場合でも、DNS設定の変更とデータの移行が少々面倒なだけで、OSとDockerコンテナのセットアップはAnsibleで簡単に実行できるようにしています。

- [自宅サーバーやVPSに使える無料のダイナミックDNS (Dynamic DNS) \| MyDNS.JP](https://www.mydns.jp/)
- [DigitalOcean: Cloud Computing, Simplicity at Scale](https://www.digitalocean.com/)
- [Open source, containers, and Kubernetes \| CoreOS](https://coreos.com/)
- [Debian -- ユニバーサルオペレーティングシステム](https://www.debian.org/)

## おわりに

いろいろなサービスが関わりますが、Gitプッシュしたあとはほぼ自動で様々なことができるようになっており、便利だしミスもほぼありません。また、Dockerを基盤としているため、どの言語処理系でも考え方が変わらないことも便利です。

この記事で説明した構成は個人開発の場合ですが、仕事の場合でもオンプレミスになるだけで、構成の考え方は変わりありません。可能な限り自動化して、便利かつミスのないリリースをしましょう。

## Link

- Author
  - [u6k.Blog()](https://blog.u6k.me/)
  - [u6k - GitHub](https://github.com/u6k)
  - [u6k_yu1 \| Twitter](https://twitter.com/u6k_yu1)
- Source
  - [2018-06-09-my-development-environment-and-deploy-workflow.md](https://github.com/u6k/blog/blob/master/_posts/2018-06-09-my-development-environment-and-deploy-workflow.md)
