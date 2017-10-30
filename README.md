# u6k.Blog() _(blog)_

[![Travis](https://img.shields.io/travis/u6k/blog.svg)](https://travis-ci.org/u6k/blog)
[![GitHub tag](https://img.shields.io/github/tag/u6k/blog.svg)](https://github.com/u6k/blog)
[![license](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)
[![Docker Pulls](https://img.shields.io/docker/stars/u6kapps/blog.svg)](https://hub.docker.com/r/u6kapps/blog/)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![u6k.blog()](https://img.shields.io/badge/u6k-blog-orange.svg)](https://blog.u6k.me/)

> [u6k.Blog()](https://blog.u6k.me/) のソースコードを管理します。

__Table of Contents:__

<!-- TOC depthFrom:2 -->

- [Background](#background)
- [Install](#install)
    - [Dependencies](#dependencies)
- [Usage](#usage)
- [Development](#development)
    - [記事を執筆](#記事を執筆)
    - [Webサイトを表示確認](#webサイトを表示確認)
- [Maintainer](#maintainer)
- [Contribute](#contribute)
- [License](#license)

<!-- /TOC -->

## Background

u6k.Blog()は、以下のサービスが連携して配信されています。

- GitHub
    - ソースコードを管理します。
- Travis CI
    - GitHubにpushすると起動され、GitHubからソースコードを取得して実行用Dockerイメージをビルドして、DockerHubにpushします。
- DockerHub
    - 実行用Dockerイメージを管理します。
- Slack
    - Travis CIのビルド結果を通知します。

u6k.Blog()は、Jekyllをブログ・システムとして使用しており、Markdown形式で記事を執筆します。

## Install

`u6kapps/blog`イメージをDockerHubで配布しているため、これを起動します。

```
$ docker run \
    -p 80:80 \
    u6kapps/blog
```

### Dependencies

- Docker
    - multi stage buildが実行できるバージョンが必要です。

```
$ docker version
Client:
 Version:      17.07.0-ce
 API version:  1.31
 Go version:   go1.8.3
 Git commit:   8784753
 Built:        Tue Aug 29 17:41:05 2017
 OS/Arch:      windows/amd64

Server:
 Version:      17.09.0-ce
 API version:  1.32 (minimum version 1.12)
 Go version:   go1.8.3
 Git commit:   afdb6d4
 Built:        Tue Sep 26 22:45:38 2017
 OS/Arch:      linux/amd64
 Experimental: false
```

- Markdownエディタ
    - 記事をMarkdown形式で執筆するため、Markdownエディタであれば何でも良いです。
    - 筆者は、AtomやVisualStudioCodeを使用しています。

## Usage

`u6kapps/blog`コンテナが起動後、Webブラウザで[http://localhost](http://localhost)を開くとブログが表示されます。

## Development

u6k.Blog()の開発について説明します。

### 記事を執筆

好みのMarkdownエディタで記事を執筆すれば良いです。基本的には、Markdownエディタでプレビューした通りの見た目の記事になるでしょう。

### Webサイトを表示確認

記事を執筆後、ローカルDocker環境で表示確認を行います。

実行用Dockerイメージをビルドします。

```
$ docker build -t blog .
```

blogコンテナを起動します。

```
$ docker run \
    -p 80:80 \
    blog
```

Webブラウザで[http://localhost](http://localhost)を開くとブログが表示されます。

記事を修正した場合、実行用Dockerイメージを再ビルドする必要があります。

## Maintainer

- [u6k - GitHub](https://github.com/u6k/)
- [u6k.Blog()](https://blog.u6k.me/)
- [u6k_yu1 | Twitter](https://twitter.com/u6k_yu1)

## Contribute

貴重なアイデアをご提案やバグ報告などを頂ける場合は、Issueを書いていただけると幸いです。

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンスの下に提供されています。</a>
