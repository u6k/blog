---
title: "Google Cloud Messaging for Android(GCM)のサンプル"
tags: ["Android", "GCM", "Push Notification"]
date: 2012-10-08 22:48:00+09:00
published: false
parmalink: "sample-android-gcm"
postID: 7025094625326549004
---

既に同様の記事が多数公開されていますが、自分もサンプルを作成して動作確認しましたので、ここに公開します。

<!-- more -->

# 参照元

GCMのコーディング方法は、[GCM: Getting Started](http://developer.android.com/guide/google/gcm/gs.html)を読めばだいたいわかります。当記事では、[GCM: Getting Started](http://developer.android.com/guide/google/gcm/gs.html)をなぞりながらサンプルを作成します。

「そもそもGCMって何?」というレベルの場合、[GCM Architectural Overview](http://developer.android.com/guide/google/gcm/gcm.html)を読むか、C2DMに関するページを検索してください(C2DMはGCMの前身)。

ちなみに、GCMではGoogleがライブラリを提供してくれているので、C2DMに比べて実装がすごく楽になっています。

> TODO: そもそものところから書いたほうが良いかな…

# GCMを有効化

実装を始める前に、API ConsoleでGCMを有効化する必要があります。API Consoleで行うことは次の通りです。

1. プロジェクトを作成
1. プロジェクトIDを取得
1. GCMサービスを有効化
1. API Keyを作成

## プロジェクトを作成

[API Console](https://code.google.com/apis/console/#project:884497848039)にアクセスします。プロジェクトを作成していない場合は、「Create project...」をクリックして、プロジェクト名を入力してプロジェクトを作成します。

![](http://developer.android.com/images/gcm/gcm-create-api-proj.png)

## プロジェクトIDを取得

プロジェクトを作成すると、URLが以下のようになるはずです。

> https://code.google.com/apis/console/#project:4815162342

URLの「#project:xxx」のxxx部分がプロジェクトIDになります。これはアプリ側でSENDER_IDとして使用するので、控えておきます。

## GCMサービスを有効化

API ConsoleのServicesからGoogle Cloud Messaging for AndroidをONに設定します。

![](http://4.bp.blogspot.com/-wGOK1jrBxwI/UHLQgfQ96rI/AAAAAAAAACw/1UdfK_gq4r8/s1600/gcm-20121008-2208.png)

## API Keyを作成

API ConsoleのAPI AccessからAPI Keyを作成します。

![](http://developer.android.com/images/gcm/gcm-api-access.png)

「Create new Server key」をクリックします。

![](http://developer.android.com/images/gcm/gcm-config-server-key.png)

APIへのアクセスを許可するIPアドレスを指定できます。サーバーのIPアドレスを指定することで、他PCからのAPI使用を拒否することができるようです。未入力の場合、全許可になるようです。

![](http://developer.android.com/images/gcm/gcm-api-key.png)

Server appsのAPI Keyが作成されました。ちなみに、「Key for browser apps」という項目もあり紛らわしいので注意です。

ちょっと面倒ですが、これでGCMを有効化できました。

# アプリ側を作成

次に、アプリ側を作成します。アプリ側の作成で行うことは以下の通りです。

1. gcm.jarファイルをビルドパスに含める
1. GCMIntentServiceを作成
1. GCMを登録/解除するActivityを作成
1. AndroidManifestを修正

## gcm.jarファイルをビルドパスに含める

GCMはGoogleがライブラリを提供しています。それが「gcm.jar」です。「gcm.jar」は「*$YOUR_SDK_ROOT*/extras/google/」以下に格納されているはずですので、libsフォルダにコピーしてビルドパスに含めます。格納されていない場合、SDK ManagerからGoogle Cloud Messaging for Android Libraryをインストールしてください。

## GCMIntentServiceを作成

GCMの各種イベントを処理するGCMBaseIntentServiceクラスが提供されています。これを継承したGCMIntentServiceクラスを作成します。以下、GCMイベントに対応して通知を表示するサンプルです。

> NOTE: クラス名をGCMIntentService以外にしたら動作しなかった…

```
public class GCMIntentService extends GCMBaseIntentService {
    // TODO SENDER_ID
    public static final String SENDER_ID = "xxx";
    public GCMIntentService() {
        super(SENDER_ID);
    }

    @Override
    protected void onRegistered(Context ctx, String registrationId) {
        Log.d("sample-gcm", "onRegistered: registrationId=" + registrationId);
        handleMessage("GCM登録");
    }

    @Override
    protected void onUnregistered(Context ctx, String registrationId) {
        Log.d("sample-gcm", "onUnregistered: registrationId=" + registrationId);
        handleMessage("GCM解除");
    }

    @Override
    protected void onError(Context ctx, String errorId) {
        Log.d("sample-gcm", "onError: errorId=" + errorId);
        handleMessage("GCMエラー");
    }

    @Override
    protected void onMessage(Context ctx, Intent intent) {
        String msg = intent.getStringExtra("message");
        Log.d("sample-gcm", "onMessage: msg=" + msg);
        handleMessage("GCM受信: msg=" + msg);
    }

    private void handleMessage(String msg) {
        NotificationManager nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        Notification n = new Notification(android.R.drawable.btn_default, msg, System.currentTimeMillis());
        PendingIntent contentIntent = PendingIntent.getActivity(getApplicationContext(), 0, new Intent(), 0);
        n.setLatestEventInfo(getApplicationContext(), "sample-gcm", msg, contentIntent);
        nm.notify(1, n);
    }
}
```

SENDER_IDには、API Consoleで取得したプロジェクトIDを設定します。

基本的に、各種イベントに対して通知などのアクションを行うことになります。受け取ったregistrationIDをSharedPreferenceに保存する、などの処理はGCMライブラリが良しなにやってくれます。楽だ。

## GCMを登録/解除するActivityを作成

GCMの登録、解除を行うGCMRegistrarクラスが提供されています。これを使用し、以下のようなコードでRegistrationIDを取得します。

```
GCMRegistrar.checkDevice(MainActivity.this);
GCMRegistrar.checkManifest(MainActivity.this);
String registrationId = GCMRegistrar.getRegistrationId(MainActivity.this);
if ("".equals(registrationId)) {
    GCMRegistrar.register(MainActivity.this, GCMIntentService.SENDER_ID);
} else {
    Toast.makeText(MainActivity.this, "既にGCM登録済み", Toast.LENGTH_SHORT).show();
}
```

`checkDevice()`は、その端末でGCMがサポートされているか確認します。`checkManifest()`は、AndroidManifestでGCMが使用可能になっているか確認します。双方とも、不可の場合は例外がスローされます。

`getRegistrationId()`で、端末(というかアプリ)に登録されているRegistrationIDを取得します。未登録の場合は空文字列が返ります。

`register()`で、GoogleのGCMサーバーにリクエストを送信し、RegistrationIDを取得します。取得したRegistrationIDは、SharedPreferenceに保存されます。保存されたRegistrationIDは、先ほどの`getRegistratioId()`で取得することができます。便利だ。

GCMの解除はもっと簡単で、単に`unregister()`を呼び出すだけです。

```
GCMRegistrar.unregister(MainActivity.this);
```

## AndroidManifestを修正

`<permission>`、`<uses-permission>`を以下のように追加します。

```
<permission
    android:name="your_package.permission.C2D_MESSAGE"
    android:protectionLevel="signature" />
<uses-permission android:name="your_package.permission.C2D_MESSAGE" />
<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

`your_package`は、アプリのパッケージに置き換えます。

GCMIntentServiceクラスを追加します。

```
<service android:name=".GCMIntentService" />
```

GCMを受信できるように、`<receiver>`を追加します。

```
<receiver
    android:name="com.google.android.gcm.GCMBroadcastReceiver"
    android:permission="com.google.android.c2dm.permission.SEND">

    <intent-filter>
        <action android:name="com.google.android.c2dm.intent.RECEIVE" />
        <action android:name="com.google.android.c2dm.intent.REGISTRATION" />
        <category android:name="your_package" />
    </intent-filter>
</receiver>
```

以上で、アプリ側の作成は完了です。

# サーバー側を作成

サーバー側、と言いますが、今回はとりあえず試したいだけなのでコンソールアプリを作成します。サーバー側の作成で行うことは以下の通りです。

1. jarファイルをビルドパスに含める
1. コードを作成

## jarファイルをビルドパスに含める

アプリ側と同じように以下のjarファイルをビルドパスに含めます。

* gcm-server.jar
* json_simple-1.1.jar
* mockito-all-1.8.5.jar

## コードを作成

1個のRegistrationIDに「てすと」という文字列を送信するアプリを作成します。

```
// TODO API Key
String key = "xxx";

// TODO GCM Registration ID
String registrationId = "xxx";

Sender sender = new Sender(key);
Message message = new Message.Builder().addData("message", "てすと").build();
Result result = sender.send(message, registrationId, 1);
System.out.println(result.toString());
```

API KeyはAPI Consoleで作成したもの、RegistrationIDはアプリでGCM登録した時にLogCatに表示されるものです。

以上で、サーバー側の作成は完了です。

# 動作確認

これで全部揃いましたので、動作確認を行います。以下のように動作したら成功です。

1. アプリを動作させ、RegistrationIDを取得できる。
1. サーバー側を動作させ、アプリにメッセージが送信されて表示される。

作成したサンプルは以下で公開しています。

* [sample-push-notification](https://bitbucket.org/u6k/sample-push-notification/)
