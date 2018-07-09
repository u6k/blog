---
layout: single
title: "ペネトレーションテストについてまとめ"
tags:
  - "テスト"
date: 2014-02-20 21:55:00+09:00
redirect_from:
  - /2014/02/penetration-test.html
---

## ペネトレーションテストとは

システムやネットワークの脆弱性を検証するテストのこと。対象に実際に攻撃を行い侵入を試みる。

プログラムの脆弱性対応が不十分だったり、ミドルウェアの設定が不十分だったり、ミドルウェアやOSに新しい脆弱性が発見されることがある。そこで、実際に攻撃を受けた場合にどの程度耐えられるかを検証する。

ペネトレーションテストは実際にシステムを攻撃するため、セキュリティについて専門的な知識が必要になる。このため、テストサービスを提供する専門業者に依頼することもある。

### 参考リンク

* [ペネトレーションテストとは \| 日立ソリューションズの情報セキュリティブログ](http://securityblog.jp/words/4661.html)
* [ペネトレーションテスト : IT用語辞典 e-Words](http://sp.e-words.jp/w/E3839AE3838DE38388E383ACE383BCE382B7E383A7E383B3E38386E382B9E38388.html)
* [ペネトレーションテスト - Wikipedia](http://ja.wikipedia.org/wiki/%E3%83%9A%E3%83%8D%E3%83%88%E3%83%AC%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%83%86%E3%82%B9%E3%83%88)
* [「ペネトレーション・テスト」とは：ITpro](http://itpro.nikkeibp.co.jp/word/page/10006229/)

## 実施時期

以下のタイミングでテストを実施する。

* 開発中
    * 開発中システムのテストがほぼ完了して修正が落ち着いた段階で行う事が多い。リリース前に脆弱性がないことを確認する。
* リリース後、定期的
    * 新たな攻撃手法や脆弱性は日々公表されている。このため、新たな攻撃手法を取り入れたペネトレーションテストを定期的に実施したほうが良い。
    * 定期的に行う場合、保守作業として調整する。また、PDCAサイクルに則って運用するべき。

## 脆弱性が発見された場合

脆弱性が発見された場合にどうするかは、テストを行う前に検討するべき。脆弱性の発見は基本的にリスク管理項目であるため、以下のリスク対応を行う。

* リスクの低減
    * 脆弱性に実際に対応する。プログラムの修正、ミドルウェアの設定変更、パッチの適用など。
    * 多くの場合、この対応を採用することになる。
* リスクの保有
    * 脆弱性を突かれた場合の影響が十分に小さいため、対応を行わずに許容範囲内として受容する。
    * リリース・スケジュールの都合、予算の都合などで決定されることもある。
* リスクの回避
    * 脆弱性がある機能・原因を全く別の方法に変更することで、脆弱性を完全に除去する。例えば、「インターネットからの不正侵入」に対して、インターネットへの公開を停止する、など。
    * リスクを保有する機能の利便性よりリスクが十分に大きい場合に取る対応で、非常に慎重に検討するべき。
* リスクの移転
    * リスクを他社に移転すること。例えば、リスクに対して保険をかけたり、一部の運用を他社に委託したりするなど。

### 参考リンク

* [IPA 独立行政法人 情報処理推進機構：情報セキュリティマネジメントとPDCAサイクル](http://www.ipa.go.jp/security/manager/protect/pdca/risk.html)

## 業者

Google先生に聞いたところ、以下のサービスが見つかった。

* [セキュリティ診断サービス【セコム】](http://www.secomtrust.net/service/consulting/shindan.html)
* [Webセキュリティ診断 \| オフィスまるごとサポート \| 法人のお客さま \| NTT東日本](http://www.ntt-east.co.jp/business/solution/marugoto/webshindan/)
* [セキュリティ診断サービス｜日立ソリューションズ](http://www.hitachi-solutions.co.jp/security_assessment/)
* [ウェブサイトセキュリティ診断：ウェブアプリケーション脆弱性診断｜シマンテック](http://www.symantec.com/ja/jp/page.jsp?id=sds-webdiag)
* [セキュリティ診断(脆弱性診断)/設計開発支援 \| サービス案内 \| 情報セキュリティのNRIセキュア](http://www.nri-secure.co.jp/service/assessment/index.html?xadid=ads00054)
* [【PCI DSSペネトレーションテスト支援】グローバルセキュリティエキスパート株式会社 \| GSX](http://www.gsx.co.jp/service/J3_11.html)
* [サーバ診断エクスプレス \| セキュリティ診断コンシェルジュ](http://va.rs.jmc.ne.jp/server/server-express?gclid=CL2j-_bX2rwCFUYAvAodJmcAgw)
* [脆弱性診断サービス \| Webセキュリティサービス　Proactive Defense](http://www.proactivedefense.jp/services/diagnosis/)
* [セキュリティ診断 \| サービス \| 株式会社ラック](http://www.lac.co.jp/service/evaluation/)

## ツール

もちろん、自分でペネトレーションテストを行うこともできる。個別の攻撃ツールを使っても良いが、総合的にテストを支援するツールが提供されている。

* Kali Linux
    * ペネトレーションテストを目的としたLinuxディストリビューション。Liveディスクや、セットアップ済み仮想マシンなどが提供されている。BackTrackの後継ツール。
    * [Kali Linux \| Rebirth of BackTrack, the Penetration Testing Distribution.](http://www.kali.org/)
    * [Kali Linux を使ってみる : まだプログラマーですが何か？](http://dotnsf.blog.jp/archives/378189.html)
    * [Kali Linux を VirtualBox にインストールする \| Webセキュリティの小部屋](http://www.websec-room.com/2014/01/07/1485)
    * [【Linux】　”Kali linux”　BackTrackの後継と言われている - NAVER まとめ](http://matome.naver.jp/odai/2137346166791157401)
* BackTrack
    * ペネトレーションテストを目的とした、1DVDタイプのLinuxディストリビューション。後継ツールとしてKali Linuxがある。
    * [BackTrack Linux - Penetration Testing Distribution](http://www.backtrack-linux.org/)
    * [BackTrack - Wikipedia](http://ja.wikipedia.org/wiki/BackTrack)
    * [Linux Hacks：BackTrackを使ってセキュリティをテストする - ITmedia エンタープライズ](http://www.itmedia.co.jp/enterprise/articles/0806/19/news035.html)
    * [【Linux 】　セキュリティーの脆弱を発見する。　”BackTrack” の使い方 - NAVER まとめ](http://matome.naver.jp/odai/2137113685353331401)
* Nessus
    * 指定したサーバーに対して、ポートスキャンや擬似アクセスなどを行うことで脆弱性を調査する、脆弱性スキャナー。Windowsでも動作する。
    * [Nessus Vulnerability Scanner](http://www.tenable.com/products/nessus)
    * [Windowsでも使える脆弱性スキャナ「Nessus」を使う - さくらのナレッジ](http://knowledge.sakura.ad.jp/tech/356/)
    * [WindowsやLinuxで実行できる脆弱性スキャナ「Nessus」を試す \| SourceForge.JP Magazine](http://sourceforge.jp/magazine/13/06/04/090000)
    * [Nessus - Wikipedia](http://ja.wikipedia.org/wiki/Nessus)
    * [Nessusを利用した総合セキュリティチェック](http://www.bflets.dyndns.org/Security/Nessus.html)

## その他、参考サイト

* [侵入テスト（ペネトレーションテスト）の有効性：情報セキュリティアドミニストレータ試験対策](http://www.sstokkun.net/archives/2005/06/top_1.html)
* [実践！Webセキュリティ点検術（1）ペネトレーションテストとは何か 最新ペネトレーション式｜ビジネス+IT](http://www.sbbit.jp/article/cont1/15565)
* [セキュリティの弱点を発見するペネトレーションテストとは？ - takalognet](http://d.hatena.ne.jp/takalognet/20071017/1192586326)

## 備考: 不正侵入の手順

不正侵入は以下の手順で行われる。

* 事前調査
    * 対象とするシステムの侵入方法・脆弱性を調査する。
* 権限取得
    * システムに侵入し、ユーザーの権限を取得する。これにより、以降は(システムにとって)正しいユーザーとして行動することができる。
* 不正行為
    * 個人情報を盗む、パスワードを盗む、個人情報を盗むなどの不正行為を行う。
* 後処理
    * 侵入・操作した痕跡を消す。これにより、犯行が気づかれにくくなる。

## 備考: 疑問点、課題

* 実施するタイミングによって実施内容は変わるか？
* 報告は、どのような形式で行うか？
* チェック観点に対する、侵入された時に発生する一般的な事象。
* 発生した場合の想定される事象。影響。
* 対応する場合の工数。
* 瑕疵か否か。
* 実施手順を策定する。対象アプリケーションのパターンを想定して。
* 報告書のテンプレートを作成する。
