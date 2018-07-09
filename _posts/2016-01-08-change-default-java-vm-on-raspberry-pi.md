---
layout: single
title: "Raspberry PiでJavaVMを切り替える手順"
tags:
  - "Raspberry Pi"
  - "Java"
date: 2016-01-09 07:00:00+09:00
redirect_from:
  - /2016/01/raspberry-pi-change-java-vm.html
---

Raspberry Piに複数のJavaをインストールした場合に、JavaVMを切り替える手順を説明します。簡単に言うと、`update-alternatives`コマンドで切り替えることが出来ます。

## update-alternatives

以下のように`update-alternatives`コマンドを実行することで、対話的にJavaVMを切り替えることが出来ます。

```
$ sudo update-alternatives --config java
alternative java (/usr/bin/java を提供) には 2 個の選択肢があります。

  選択肢    パス                                               優先度  状態
------------------------------------------------------------
* 0            /usr/lib/jvm/java-7-openjdk-armhf/jre/bin/java        1043      自動モード
  1            /usr/lib/jvm/java-7-openjdk-armhf/jre/bin/java        1043      手動モード
  2            /usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt/jre/bin/java   318       手動モード

現在の選択 [*] を保持するには Enter、さもなければ選択肢の番号のキーを押してください: 2
update-alternatives: /usr/bin/java (java) を提供するために 手動モード で /usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt/jre/bin/java を使います
```

## 参考リンク

* [Raspberry Pi - Change Default Java Virtual Machine (JVM)](http://www.savagehomeautomation.com/projects/raspberry-pi-change-default-java-virtual-machine-jvm.html)
