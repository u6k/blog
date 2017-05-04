---
layout: single
title: "gensim入門"
tags:
  - "gensim"
  - "機械学習"
  - "自然言語処理"
  - "トピックモデル"
date: 2017-05-03
---

手軽にトピック分析を実行できるgensimを知ったので、gensimを使用して簡単な文章をトピック分析するチュートリアルを実行してみました。

# トピック分析、LDA、gensimとは

詳しく理解してはいないので、簡単に言うと、

- トピック分析とは、大量の文章からいくつかのトピックを分類して、与えられた文章がどのトピックに属するかを分類する手法
- LDAとは、トピック分析の1種
- gensimとは、トピック分析を行うことができるPython製のソフトウェア

gensimを使ったトピック分析は、以下の手順で行えるようです。

+ 文章を準備
+ 文章を単語ごとに分割、調整
+ 辞書を作成
+ コーパスを作成
+ LDAモデルを作成
+ 分類したい文章をLDAモデルで分類

# 前提

- Docker
    - Python 2環境を作るのが面倒だったのでDockerを使っているだけです。

```
$ docker version
Client:
 Version:      17.03.1-ce
 API version:  1.27
 Go version:   go1.7.5
 Git commit:   c6d412e
 Built:        Tue Mar 28 00:40:02 2017
 OS/Arch:      windows/amd64

Server:
 Version:      17.04.0-ce
 API version:  1.28 (minimum version 1.12)
 Go version:   go1.7.5
 Git commit:   4845c56
 Built:        Wed Apr  5 18:45:47 2017
 OS/Arch:      linux/amd64
 Experimental: false
```

- Python 2

```
# python --version
Python 2.7.13
```

- gensim 2.0.0

# 手順

pythonコンテナを起動します。

```
$ docker run --rm -it python:2 bash
```

gensimをインストールします。それなりに時間がかかります。

```
# pip install gensim
Collecting gensim
  Downloading gensim-2.0.0.tar.gz (14.1MB)
    100% |████████████████████████████████| 14.2MB 51kB/s
Collecting numpy>=1.3 (from gensim)
  Downloading numpy-1.12.1-cp27-cp27mu-manylinux1_x86_64.whl (16.5MB)
    100% |████████████████████████████████| 16.5MB 60kB/s
Collecting scipy>=0.7.0 (from gensim)
  Downloading scipy-0.19.0-cp27-cp27mu-manylinux1_x86_64.whl (45.0MB)
    100% |████████████████████████████████| 45.0MB 25kB/s
Requirement already satisfied: six>=1.5.0 in /usr/local/lib/python2.7/site-packages (from gensim)
Collecting smart_open>=1.2.1 (from gensim)
  Downloading smart_open-1.5.2.tar.gz
Collecting boto>=2.32 (from smart_open>=1.2.1->gensim)
  Downloading boto-2.46.1-py2.py3-none-any.whl (1.4MB)
    100% |████████████████████████████████| 1.4MB 488kB/s
Collecting bz2file (from smart_open>=1.2.1->gensim)
  Downloading bz2file-0.98.tar.gz
Collecting requests (from smart_open>=1.2.1->gensim)
  Downloading requests-2.13.0-py2.py3-none-any.whl (584kB)
    100% |████████████████████████████████| 593kB 1.4MB/s
Building wheels for collected packages: gensim, smart-open, bz2file
  Running setup.py bdist_wheel for gensim ... done
  Stored in directory: /root/.cache/pip/wheels/e9/5f/e7/4ff23a3fe4b181b44f37eed5602f179c1cc92a0a34f337e745
  Running setup.py bdist_wheel for smart-open ... done
  Stored in directory: /root/.cache/pip/wheels/02/44/43/68e963ce2b45baefa913a4e558bcd787403458afddffcf45ca
  Running setup.py bdist_wheel for bz2file ... done
  Stored in directory: /root/.cache/pip/wheels/31/9c/20/996d65ca104cbca940b1b053299b68459391c01c774d073126
Successfully built gensim smart-open bz2file
Installing collected packages: numpy, scipy, boto, bz2file, requests, smart-open, gensim
Successfully installed boto-2.46.1 bz2file-0.98 gensim-2.0.0 numpy-1.12.1 requests-2.13.0 scipy-0.19.0 smart-open-1.5.2
```

pythonインタープリタを起動します。

```
# python
Python 2.7.13 (default, Mar 22 2017, 22:44:40)
[GCC 4.9.2] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>>
```

gensimをインポートして使用可能にします。

```
>>> import gensim
>>> from gensim import corpora
```

解析対象の文章を準備します。ここでは、短い文章を9個準備しています。

```
>>> documents = ["Human machine interface for lab abc computer applications",
...              "A survey of user opinion of computer system response time",
...              "The EPS user interface management system",
...              "System and human system engineering testing of EPS",
...              "Relation of user perceived response time to error measurement",
...              "The generation of random binary unordered trees",
...              "The intersection graph of paths in trees",
...              "Graph minors IV Widths of trees and well quasi ordering",
...              "Graph minors A survey"]
```

文を単語に分割した配列にします。単語配列には分析において無意味な単語も含まれるので、ストップ・ワードを定義して、単語配列から除去します。

```
>>> # ストップワードを定義
>>> stop_words = set('for a of the and to in'.split())

>>> # 文を単語に分割し、ストップワードを除去した配列を作成
>>> texts = [[word for word in document.lower().split() if word not in stop_words] for document in documents]
```

> __NOTE:__ 分析に意味のない単語が含まれていても困るので、単語群から無意味な単語を除去しますが、いくつかの方法があります。「名詞以外の単語を除去」「ストップ・ワードを明示的に定義して除去」「高頻度すぎる・低頻度すぎる単語を除去」「TF-IDFで単語の重要度を算出して、重要度が低い単語を除去」など。

texts変数の内容は、以下のようになります。

```
>>> from pprint import pprint
>>> pprint(texts)
[['human', 'machine', 'interface', 'lab', 'abc', 'computer', 'applications'],
 ['survey', 'user', 'opinion', 'computer', 'system', 'response', 'time'],
 ['eps', 'user', 'interface', 'management', 'system'],
 ['system', 'human', 'system', 'engineering', 'testing', 'eps'],
 ['relation', 'user', 'perceived', 'response', 'time', 'error', 'measurement'],
 ['generation', 'random', 'binary', 'unordered', 'trees'],
 ['intersection', 'graph', 'paths', 'trees'],
 ['graph', 'minors', 'iv', 'widths', 'trees', 'well', 'quasi', 'ordering'],
 ['graph', 'minors', 'survey']]
```

texts変数から、1回しか出現していない単語を除去します。

```
>>> # 単語の出現回数を格納するfrequency変数を定義
>>> from collections import defaultdict
>>> frequency = defaultdict(int)

>>> # 単語の出現回数をfrequency変数でカウント
>>> for text in texts:
...     for token in text:
...         frequency[token] += 1

>>> # frequency変数で1より上の単語のみを配列に構築
>>> texts = [[token for token in text if frequency[token] > 1] for text in texts]
```

texts変数の内容を確認すると、単語出現回数1の単語が除去されていることが分かります。

```
>>> pprint(texts)
[['human', 'interface', 'computer'],
 ['survey', 'user', 'computer', 'system', 'response', 'time'],
 ['eps', 'user', 'interface', 'system'],
 ['system', 'human', 'system', 'eps'],
 ['user', 'response', 'time'],
 ['trees'],
 ['graph', 'trees'],
 ['graph', 'minors', 'trees'],
 ['graph', 'minors', 'survey']]
```

辞書を作成します。辞書とはここでは、単語ID・単語・単語出現回数を持つデータのことです。

作成した辞書は`save`または`save_as_text`でファイルに保存することができ、`load`または`load_from_text`で読み込むことで使いまわすことができます。

```
>>> dictionary = corpora.Dictionary(texts)

>>> # ファイルに保存できます
>>> dictionary.save('/tmp/deerwester.dict')

>>> # テキストファイルに保存することもできます
>>> dictionary.save_as_text('/tmp/deerwester.dict.txt')
```

辞書をテキストファイルに保存すると、内容は以下のようになります。

```
# cat /tmp/deerwester.dict.txt
1       computer        2
8       eps     2
10      graph   3
2       human   2
0       interface       2
11      minors  2
3       response        2
5       survey  2
6       system  3
4       time    2
9       trees   3
7       user    3
```

コーパスを作成します。コーパスとはここでは、文章ごとに「単語ID・出現頻度」タプル配列を持つデータのことです。

```
>>> corpus = [dictionary.doc2bow(text) for text in texts]

>>> # ファイルに保存できる
>>> corpora.MmCorpus.serialize('/tmp/deerwester.mm', corpus)
```

コーパスは、以下のような内容になります。

```
>>> pprint(corpus)
[[(0, 1), (1, 1), (2, 1)],
 [(1, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1)],
 [(0, 1), (6, 1), (7, 1), (8, 1)],
 [(2, 1), (6, 2), (8, 1)],
 [(3, 1), (4, 1), (7, 1)],
 [(9, 1)],
 [(9, 1), (10, 1)],
 [(9, 1), (10, 1), (11, 1)],
 [(5, 1), (10, 1), (11, 1)]]
```

LDAモデルを構築します。ここで、モデルが持つトピック数を指定します。

```
>>> # num_topics=5で、5個のトピックを持つLDAモデルを作成
>>> lda = gensim.models.ldamodel.LdaModel(corpus=corpus, num_topics=5, id2word=dictionary)
```

トピックは以下のように構築されます。トピックが5個あり、トピックは単語・適合度の組み合わせで構築されていることが分かります。

```
>>> pprint(lda.show_topics())
[(0,
  u'0.256*"trees" + 0.178*"system" + 0.177*"graph" + 0.097*"human" + 0.097*"eps" + 0.097*"minors" + 0.016*"time" + 0.016*"interface" + 0.016*"computer" + 0.016*"user"'),
 (1,
  u'0.086*"trees" + 0.084*"graph" + 0.083*"eps" + 0.083*"interface" + 0.083*"computer" + 0.083*"system" + 0.083*"minors" + 0.083*"survey" + 0.083*"time" + 0.083*"human"'),
 (2,
  u'0.207*"user" + 0.143*"system" + 0.142*"response" + 0.142*"time" + 0.078*"computer" + 0.078*"survey" + 0.078*"eps" + 0.078*"interface" + 0.014*"trees" + 0.013*"graph"'),
 (3,
  u'0.220*"interface" + 0.220*"human" + 0.220*"computer" + 0.039*"trees" + 0.038*"graph" + 0.038*"system" + 0.038*"minors" + 0.037*"eps" + 0.037*"survey" + 0.037*"user"'),
 (4,
  u'0.221*"graph" + 0.220*"survey" + 0.220*"minors" + 0.039*"trees" + 0.038*"system" + 0.038*"human" + 0.037*"time" + 0.037*"eps" + 0.037*"interface" + 0.037*"user"')]
```

これで、トピック分析を行う準備ができました。

分析したい文章を定義します。

```
# 文を定義
test_documents = ["Computer themselves and software yet to be developed will revolutionize the way we learn"]

# 単語を分割
test_texts = [[word for word in document.lower().split()] for document in test_documents]

# 既存の辞書を使用して、コーパスを作成
test_corpus = [dictionary.doc2bow(text) for text in test_texts]
```

test_corpus変数の内容は以下のようになります。

```
>>> pprint(test_corpus)
[[(0, 1)]]
```

コーパスを文章として認識して、推定トピックを出力します。

```
>>> for topics_per_document in lda[test_corpus]:
...     pprint(topics_per_document)
...
[(0, 0.10002083277439905),
 (1, 0.10157201217970441),
 (2, 0.10004205414751678),
 (3, 0.59835522682825404),
 (4, 0.10000987407012563)]
```

この結果から文章は、約0.60でトピック3だと推定されます。

# 参考

- [gensim: Corpora and Vector Spaces](https://radimrehurek.com/gensim/tut1.html)
- [Python で LDAトピック分析手習い 〜 参考ウェブサイトのコード を 写経して、gensimモジュールを使うやり方を１ステップごと、確認してみた - Qiita](http://qiita.com/HirofumiYashima/items/c8aa8df214d48c86ecba)
- [機械学習関連情報をトピックモデルで分類する - Qiita](http://qiita.com/suchowan/items/a4231d1c63c835ae88e2)
- [潜在意味解析 - Wikipedia](https://ja.wikipedia.org/wiki/%E6%BD%9C%E5%9C%A8%E6%84%8F%E5%91%B3%E8%A7%A3%E6%9E%90)
- [判別分析 - Wikipedia](https://ja.wikipedia.org/wiki/%E5%88%A4%E5%88%A5%E5%88%86%E6%9E%90)
