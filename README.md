# u6k.Blog()

[![wercker status](https://app.wercker.com/status/68efa3416753009de34ed1fd59b0cd37/s/master "wercker status")](https://app.wercker.com/project/byKey/68efa3416753009de34ed1fd59b0cd37)
[![u6k.blog()](https://img.shields.io/badge/u6k-.blog-orange.svg)](http://blog.u6k.me/)
[![license](https://i.creativecommons.org/l/by-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-sa/4.0/)

[u6k.Blog()](http://blog.u6k.me/) のソースコードを管理します。

## Description

u6k.Blog()は、以下のサービスが連携して配信されています。

* GitHub
    * ソースコードを管理します。
* Wercker
    * GitHubにpushすると起動され、GitHubからソースコードを取得して、静的Webサイトをビルドして、Amazon S3にアップロードします。
* Amazon S3
    * u6k.Blog()の静的ファイルを配信します。
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

まず、生成した静的ファイルをブラウザで開くため、nginxコンテナを起動します。本来は`jekyll serve`でプレビューできるはずですが、`minimal-mistakes`テーマのせいか、これが上手くいきません…

```
$ docker run -d -p 80:80 -v $(pwd)/_site:/usr/share/nginx/html nginx
```

静的ファイルを生成するため、jekyll-dockerコンテナを起動します。

```
$ docker run --rm -it -v $(pwd):/var/myblog u6kapps/jekyll-docker bash
```

gemをアップデートします。これは、コンテナ起動直後だけで良いです。

```
# bundle update
```

Jekyllを使用して、静的ファイルを生成します。

```
# jekyll build
```

Webブラウザで[http://localhost](http://localhost)を開くと、静的サイトが表示されます。

記事を修正して静的ファイルを再生成する場合、`_site`フォルダの中身を削除してから再生成したほうが良いです。

```
# rm -rf _site/*
# jekyll build
```

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
