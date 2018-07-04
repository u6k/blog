---
layout: single
title: "自宅サーバー設計(ソフトウェア編)"
tags:
  - "サーバー"
  - "設計"
date: 2017-05-02
---

ハードウェア編で、MacBookProをDockerホストの構成を説明しました。Dockerコンテナがどのように動作しているかを整理します。

## 前提

- サービスを楽に構築するため、Dockerコンテナで(ほぼ)全てを構成したい。
- ユーザー数が少ない(自分しか使わない)ので、DBMSはSQLiteでとりあえずいいや。
- 定期ジョブは、Jenkinsおじさんにやってもらう。
- ファイル管理は、(可能な限り)minioコンテナに集約したい。最悪、minioコンテナのファイルから環境を復元したい。
    - ジョブのログ、再発行可能な証明書など消えても良いファイルは、各コンテナのボリュームで扱う。

## 構成図

{% plantuml %}

[nginx-proxy]
[letsencrypt-nginx-proxy-companion]
[redmine]
[blog]
[owncloud]
[jenkins]
[bookmark]
[narou-crawler]
[narou-crawler-db]
[minio]
[ceron-analyze]

[nginx-proxy] -- [letsencrypt-nginx-proxy-companion]
[nginx-proxy] .. [redmine] : redmine.u6k.me
[nginx-proxy] .. [blog] : blog.u6k.me
[nginx-proxy] .. [owncloud] : owncloud.u6k.me
[nginx-proxy] .. [jenkins] : jenkins.u6k.me
[nginx-proxy] .. [minio] : s3.u6k.me
[nginx-proxy] .. [bookmark] : bookmark.u6k.me
[jenkins] .. [redmine]
[jenkins] .. [bookmark]
[jenkins] .. [narou-crawler-db]
[jenkins] --> [narou-crawler]
[jenkins] --> [minio]
[jenkins] --> [ceron-analyze]
[narou-crawler] --> [narou-crawler-db]
[narou-crawler] --> [minio]
[ceron-analyze] --> [minio]

{% endplantuml %}

## 構成の説明

### nginx-proxyとletsencrypt-nginx-proxy-companion

nginx-proxyコンテナが外部からのHTTP(S)接続を受け入れ、ホスト名に応じて各コンテナに振り分けます。しばしば`jwilder/nginx-proxy`が使用されますが、1コンテナに複数のドメイン名をマッピングしたかったので、`dbendelman/nginx-proxy`を使用しています。

letsencrypt-nginx-proxy-companionコンテナは、Let's Encryptを使用してドメイン名に対して自動的にサーバー証明書を発行してくれます。

nginx-proxyコンテナとletsencrypt-nginx-proxy-companionコンテナの組み合わせは、Dockerコンテナにおける複数サービス提供の鉄板構成だと思っていて、サービスが増減しても動的に管理してくれるので、すごく便利です。

### redmine

redmineコンテナで、自分用のRedmineを運用しています。プラグイン、テーマなどをビルド時に追加しています。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`redmine.u6k.me`でアクセスできるようにしています。

Redmineは趣味開発や仕事だけではなく私生活のタスクも管理しているため、頻繁にバックアップを取り、長期旅行では一時的にDigitalOceanで運用するなどしています。

### owncloud

owncloudコンテナで、自分用のownCloudを運用しています。スマホの写真や動画、PC内ファイルの管理などで使っています。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`owncloud.u6k.me`でアクセスできるようにしています。

ownCloudにはS3と連携するプラグインがあるため、minioコンテナにファイル管理を集約できるはずですが、エラーになってしまい、今のところ実現できていません。

### blog

blogコンテナで、blogを公開しています。以前はBloggerを使っていましたが、Markdownの扱いが不便だったため、jekyllに乗り換えました。なので、記事を書いたらCircleCIでDockerイメージをビルドして、blogコンテナを再起動することで記事を更新しています。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`blog.u6k.me`でアクセスできるようにしています。

### bookmark

自作のブックマーク管理サービスを運用しています。一般的なブックマーク管理サービスのようにタグ管理や検索ができる他、REST APIでアクセスでき、ブックマークすることでWebページをキャッシュすることができます。

とはいえまだ開発中で、ドッグフーディングしているところです。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`bookmark.u6k.me`でアクセスできるようにしています。

### jenkins

jenkinsコンテナで自分用のJenkinsを運用しています。ただ、ビルドのためではなく、なんちゃってジョブ管理システムとして使っています。具体的には、以下のようなことをしています。

- コンテナのバックアップ
    - redmineのSQLite
    - bookmarkのhsqldb
    - narou-crawler-dbのダンプ
    - 上記を取得して、minioコンテナにアップロード。
- MyDNSにIPアドレスを通知。
- ceron-analyzeのAPIを定期呼び出し。
- narou-crawlerのAPIの定期呼び出し。
- minio、owncloudが管理するファイルをAmazonCloudDriveへバックアップ。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`jenkins.u6k.me`でアクセスできるようにしています。

### minio

コンテナのファイル管理を一手に引き受ける、S3互換ストレージであるMinioを運用しています。全てのファイルはここに集約されるため、minioコンテナが管理するファイルをバックアップすれば、万が一システムが壊れてもリストアできる…はず。

コンテナ実行時に`VIRTUAL_HOST`環境変数を設定することで、`s3.u6k.me`でアクセスできるようにしています。

## コンテナの起動、再起動、更新

swarmやshipyardなどで管理するべきかなとは思いますが、サービスごとにシェルで管理しています。このシェルは、コンテナ停止→イメージ更新→コンテナ起動、を行います。

どこかの記事で「サーバー管理は、sshして作業しなければならない時点で負け」とあって、できればそこを目指したいですが、目標ということで。

CIビルド後のコンテナ自動再起動を仕込もうと考えたことはありますが、ビルドと再起動が必ずしも同時ではないと考えて、仕込んでいません。実際、仕組みを大きく変えるためにコンテナ再起動前後で手作業が発生することがあります。

## おわりに

若干煩雑ではありますが、今のところこのように運用しています。リソースに余裕があれば、CoreOS起動→全コンテナが最新化されて起動、とかやってみたいです。
