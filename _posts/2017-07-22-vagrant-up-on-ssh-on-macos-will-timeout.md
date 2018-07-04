---
layout: single
title: "macOSにssh接続してvagrant upするとタイムアウトになる"
tags:
  - "Vagrant"
  - "CoreOS"
date: 2017-07-22
---

普段、自宅macOSにssh接続して作業していますが、 `vagrant up` したらタイムアウトになってしまったことと、解決したことのメモ。

## 現象

以下のように、タイムアウトになってしまいました。

```
$ sudo vagrant up
Bringing machine 'core-01' up with 'virtualbox' provider...
==> core-01: Importing base box 'coreos-alpha'...
==> core-01: Configuring Ignition Config Drive
==> core-01: Matching MAC address for NAT networking...
==> core-01: Checking if box 'coreos-alpha' is up to date...
==> core-01: Setting the name of the VM: coreos-vagrant_core-01_1500727104603_35889
==> core-01: Clearing any previously set network interfaces...
==> core-01: Preparing network interfaces based on configuration...    core-01: Adapter 1: nat
    core-01: Adapter 2: hostonly
==> core-01: Forwarding ports...
    core-01: 22 (guest) => 2222 (host) (adapter 1)
==> core-01: Running 'pre-boot' VM customizations...
==> core-01: Booting VM...
==> core-01: Waiting for machine to boot. This may take a few minutes...
    core-01: SSH address: 127.0.0.1:2222
    core-01: SSH username: core
    core-01: SSH auth method: private key
    core-01: Warning: Remote connection disconnect. Retrying...
Timed out while waiting for the machine to boot. This means that
Vagrant was unable to communicate with the guest machine within
the configured ("config.vm.boot_timeout" value) time period.

If you look above, you should be able to see the error(s) that
Vagrant had when attempting to connect to the machine. These errorsare usually good hints as to what may be wrong.

If you're using a custom box, make sure that networking is properlyworking and you're able to connect to the machine. It is a common
problem that networking isn't setup properly in these boxes.
Verify that authentication configurations are also setup properly,
as well.

If the box appears to be booting properly, you may want to increasethe timeout ("config.vm.boot_timeout") value.
```

## 解決

いろいろ調べて、タイムアウト時間を伸ばしたり、vb_guiをtrueにしたり、ipを固定化したりしてみましたが、最終的に、macOSにVNC接続してターミナルで `vagrant up` したら正常起動しました。

ちなみに、 `vagrant ssh` はssh接続でも正常動作しました。