# u6k.Blog _(blog)_

[![Travis](https://img.shields.io/travis/u6k/blog.svg)](https://travis-ci.org/u6k/blog)
[![GitHub tag](https://img.shields.io/github/tag/u6k/blog.svg)](https://github.com/u6k/blog)
[![license](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)
[![u6k.blog()](https://img.shields.io/badge/u6k-blog-orange.svg)](https://blog.u6k.me/)

> [u6k.Blog](https://blog.u6k.me/) のソースコードを管理します

__Table of Contents:__

<!-- TOC depthFrom:2 -->

- [Background](#background)
- [Install](#install)
- [Dependencies](#dependencies)
- [Deploy](#deploy)
- [Maintainer](#maintainer)
- [Contribute](#contribute)
- [License](#license)

<!-- /TOC -->

## Background

u6k.Blogは、以下のサービスが連携して配信されています。

- GitHub
    - ソースコードを管理します。
- Travis CI
    - GitHubにpushすると起動され、GitHubからソースコードを取得して各種チェックを行います。
- GitHub Pages
    - u6k.Blogを配信します。
- Slack
    - Travis CIのビルド結果を通知します。

u6k.Blogは、Jekyllをブログ・システムとして使用しており、Markdown形式で記事を執筆します。

## Install

開発用Dockerイメージをビルドします。

```
$ docker-compose build
```

Dockerコンテナを起動します。起動すると、blogコンテナにより`_site`フォルダにサイトの静的ファイルが生成され、nginxコンテナにより配信されます。サイト生成後、ブラウザからは http://localhost:8080/ でアクセスできます。

```
$ docker-compose up -d
```

外部から表示確認するには、`ngrok`を使用します。

```
$ ngrok http 8080
```

GitHub Pagesで配信するには、`gh-pages`ブランチをチェックアウトして、`_site`フォルダの内容を全て上書きします。

## Dependencies

- Docker

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
- ngrok
    - 外部から表示確認を行うときに必要です。

## Deploy

gh-pagesブランチにプッシュして、GitHub Pagesにu6k.Blogをデプロイする手順。

```
# クリーンアップする
git clean -xdf
git reset --hard

# Dockerイメージをビルドする
docker build -t blog .

# u6k.Blogを生成する
docker run --rm -v $(pwd):/var/my-blog blog

# gh-pagesブランチをチェックアウトする
git checkout gh-pages

# CNAMEファイルを退避する
cp CNAME _site/

# 既存ファイルを削除する
git rm -rf '*'

# 余計なファイルを削除する
rm Gemfile.lock
rm .jekyll-metadata
rm -r uml/
rm -r .sass-cache/

# 生成したu6k.Blogを展開する
mv _site/* .
rm -r _site/

# gitプッシュする
git add .
git commit -m "generate u6k.Blog"
git push origin gh-pages
```

## Maintainer

- u6k
    - [GitHub](https://github.com/u6k/)
    - [Twitter](https://twitter.com/u6k_yu1)
    - [u6k.Blog](https://blog.u6k.me/)

## Contribute

貴重なアイデアをご提案やバグ報告などを頂ける場合は、Issueを書いていただけると幸いです。

## License

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />この 作品 は <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">クリエイティブ・コモンズ 表示 - 継承 4.0 国際 ライセンスの下に提供されています。</a>
