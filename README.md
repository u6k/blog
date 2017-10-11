# u6k.Blog()

[![u6k.blog()](https://img.shields.io/badge/u6k-blog-orange.svg)](https://blog.u6k.me/) [![GitHub tag](https://img.shields.io/github/tag/u6k/blog.svg)](https://github.com/u6k/blog) [![Docker Pulls](https://img.shields.io/docker/pulls/u6kapps/blog.svg)](https://hub.docker.com/r/u6kapps/blog/) [![Travis](https://img.shields.io/travis/u6k/blog.svg)](https://travis-ci.org/u6k/blog) [![license](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)

[u6k.Blog()](https://blog.u6k.me/) のソースコードを管理します。

## Description

u6k.Blog()は、以下のサービスが連携して配信されています。

* GitHub
    * ソースコードを管理します。
* CircleCI
    * GitHubにpushすると起動され、GitHubからソースコードを取得して、静的Webサイトを含むDockerイメージをビルドして、DockerHubにpushします。
* DockerHub
    * 静的Webサイトを含むDockerイメージを管理します。
* Slack
    * Werckerのビルド結果を通知します。

u6k.Blog()は、Jekyllをブログ・システムとして使用しており、Markdown形式で記事を執筆します。

## Requirement

* Atom
    * 記事をMarkdown形式で執筆するため、Markdownエディタであれば何でも良いです。
* Docker
    * ローカルPCでプレビューするために使用します。Ruby動作環境があるのであれば、Dockerは必要ありません。

## Usage

### 記事を執筆

好みのMarkdownエディタで記事を執筆すれば良いです。基本的には、Markdownエディタでプレビューした通りの見た目の記事になるでしょう。

### Webサイトをプレビュー

JekyllでビルドしたWebサイトをプレビューする場合、以下の手順を実行します。

ビルド用Dockerイメージを構築します。

```
$ docker build -t blog-dev -f Dockerfile-dev .
```

ビルドして、静的ファイルを生成します。

```
$ docker run --rm -v $(pwd):/var/my-blog blog-dev
```

nginxコンテナを起動して、Webサーバー経由で表示できるようにします。

```
$ docker run -d -p 80:80 -v $(pwd)/_site:/usr/share/nginx/html nginx
```

Webブラウザで[http://localhost](http://localhost)を開くと、静的サイトが表示されます。

記事を修正して静的ファイルを再生成する場合、`_site`フォルダの中身を削除してから再生成したほうが良いです。

### Webサイトを公開

Webサイトを公開する場合は、masterブランチにpushすると、Werckerがビルドして、Amazon S3にデプロイされます。詳細は、`wercker.yml`を参照してください。

## Author

* GitHub
    * [u6k/blog](https://github.com/u6k/blog)
* Wercker
    * [u6k/blog](https://app.wercker.com/u6k/blog/runs)
* Redmine
    * [blog - u6k.Redmine()](https://redmine.u6k.me/projects/blog)

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンスの下に提供されています。</a>
