---
layout: single
title: "Android TTSでonUtteranceCompleted()が呼び出されるための実装方法"
tags:
  - "Android"
  - "TextToSpeech"
date: 2012-09-02 00:00:00+09:00
redirect_from:
  - /2012/09/android-ttsonutterancecompleted.html
toc: false
---

`onUtteranceCompleted()`内でToast表示しようとしたけれど、発声が終わってもToastが表示されないので調べたら、以下が原因でした。

- `setOnUtteranceCompletedListener()`は初期化後に呼び出さなくてはならない。`onInit()`中に呼び出すと良い。
- `speak()`呼出し時に、`TextToSpeech.Engine.KEY_PARAM_UTTERANCE_ID`キーを設定したパラメータを渡す。渡さないと`onUtteranceCompleted()`は呼び出されない。
- `onUtteranceCompleted()`はUIスレッドではないので、そもそもToast表示できない。`runOnUiThread()`などでUIスレッドで実行すること。

## 参考

[Android TTS onUtteranceCompleted callback isn't getting called - stackoverflow](http://stackoverflow.com/questions/4652969/android-tts-onutterancecompleted-callback-isnt-getting-called)
