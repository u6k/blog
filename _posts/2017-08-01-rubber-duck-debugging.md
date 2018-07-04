---
layout: single
title: "ラバーダック・デバッギング、自問自答"
tags:
  - "プログラミング"
  - "コミュニケーション"
date: 2017-08-01
---

久しぶりにラバーダッキング(ラバーダック・デバッギング)という単語が目に留まったので、整理してみます。

## ラバーダッキング(ラバーダック・デバッギング、テディベア・ペア・プログラミング)とは

問題解決に詰まったとき、人に問題を説明すると説明途中で解決することがあるように、人ではなくラバーダック(アヒルのおもちゃ)やテディベアに話しかけることで問題解決を試みる手法のことです。

- [Rubber duck debugging - Wikipedia](https://en.wikipedia.org/wiki/Rubber_duck_debugging)
- [Teddy Bear Pair Programming by Adrian Bolboaca](http://blog.adrianbolboaca.ro/2012/12/teddy-bear-pair-programming/)
- [ポーギーに話す](http://www.aoky.net/articles/john_graham_cumming/talking_to_porgy.htm)
- [「ラバーダッキング」と人に教えることの意義 - ベイジの日報](https://baigie.me/nippo/2017/04/25/rubberducking/)
- [ベアプログラミング（テディベア効果） - 発声練習](http://next49.hatenadiary.jp/entry/20111025/p2)
- [ベアプログラミングが無理ならサイレントベアプログラミングを検討しよう - Qiita](http://qiita.com/sta/items/6661cfcb57cfefa9a36a)

人に説明すると相手の時間を奪ってしまいますが、ラバーダックやテディベアであれば時間を奪うことがありません。ただ、他人から見るとアヒルのおもちゃに話しかける変な人になってしまうので、それを克服しようとしているサイレントベアプログラミングの記事は、興味深いです。

## 自問自答

ただ漠然と「何に困っているか」を呟くだけでも効果はありますが、およそ以下のような自問自答で解決案に至ることが多いです。

- 処理の流れが分からない場合
    - 登場人物は把握できているか？
    - 時系列で、誰と誰がどのように会話しているか把握できているか？
- デバッグでつまずいている場合
    - 変数や設定値は把握できているか？
    - どのような値を設定して、どのような結果になったか、とりあえずで良いから記録しているか？
- システムや仕様の構成がよく分からない場合
    - どのような登場人物がいるか？
    - 登場人物同士は、どのように会話しているか？
- どのように仕事を進めれば良いのか分からない場合
    - 仕事の具体的な目的、成果物は把握しているか？
    - 目的を達成するために、どのようなステップが考えられるか？
        - ステップは契機と結果が繋がってなくてはならない。
    - ステップの中で、自分以外が関わるステップはあるか？
    - デッドラインはいつか？つまり、この仕事が遅延すると、どの作業に影響が出るか？
    - ステップを実行するために、何が(5W1H)必要か？
- 「～はず」
    - 本当にそうなのか？
- 「確認した」
    - どのように確認したか、網羅的に確認したか？

自問自答のまとめをGoogle先生に聞いても良いと思います。例えば、以下のページのようによくまとまったリストが見つかるかもしれません。

- [一匹狼のための一人Ｑ＆Ａ大会 - 発声練習](http://next49.hatenadiary.jp/entry/20081114/p1)

## 質問テンプレート

コミュニティには、質問テンプレートがある場合があります。これらのように、困ったときのテンプレートを作っておくとよいかもしれません。

- [Do you have a checklist that can help me ask a better question? - Meta Server Fault](https://meta.serverfault.com/questions/6074/do-you-have-a-checklist-that-can-help-me-ask-a-better-question)
- [Why is it that properly formulating your question (for stackoverflow) often yields you your answer - Meta Stack Exchange](https://meta.stackexchange.com/questions/20016/why-is-it-that-properly-formulating-your-question-for-stackoverflow-often-yiel)

## 設計で煮詰まった時は？

ラバーダック・デバッギングは主にプログラミングの文脈で語られますが、設計においてはどうでしょうか？

「コーディングも設計」という主張は置いておいて、設計の場合は、例えばUMLモデル図のような、多角的視点に基づく設計情報があるはずなので、設計情報を見直すことで机上デバッグを行います。モデルの粒度、属性、役割、接続を見直します。この見直し作業の時に、やはり人に説明したり、自問自答したり、つまりラバーダック・デバッギングを行うことで解決することもあります。

この時、設計モデルを何らかのツールで作成している場合、プログラミングと同様にラバーダック・デバッギングの効果が高まると思います。筆者は残念ながら、そのようなツールで設計を行うことはまれですが。

## ツール、サービスはあるか？

上記のサイレントベアプログラミングの記事で、チャット・ツールを用いた手法が提案されています。

アプリがないか探したところ、Androidアプリを見つけました。試用してはいないので、どのようなアプリかは不明です。

- [Rubber Duck Debugger](https://play.google.com/store/apps/details?id=com.rddebugger.moldo.rubberduckdebugger)

昔、Eclipseプラグインで一人チャットがあった気がしますが、それでもできそうです。

自然言語解析技術が進歩した現代なら、ユーザーの呟きから自問自答文を返信することは、できそうにも思います。