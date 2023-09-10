---
id: 410
title: 'Identify GSM modem devices using udev'
date: '2014-11-03T16:22:37+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=410'
permalink: /2014/11/03/identify-gsm-modem-devices-using-udev/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
---

Again an interesting problem, I do have a Linux box and it has two GSM modems and a RS-232 FTDI USB device built in. Each GSM modem brings three USB serial devices. Now I do want to dial up using the first of these modems and therefore I do need the device name, e.g. `/dev/ttyUSB2`.

However, each time the box boots up, either the RS-232 device or the modems are first in the order or devices found by the kernel. This results in the modem to be either `/dev/ttyUSB2` or `/dev/ttyUSB3`. Since this definitely is an issue when dialing up, I would like to keep these device names persistent.

[udev](https://en.wikipedia.org/wiki/Udev "udev") can help here. It allows one to influence the way devices are created in userland. Depending on your distribution, the rules files are located at `/etc/udev/rules.d/` (at least for Ubuntu).

Now my modems can be identified by vendor and product id (12d1, 1404) so a simply udev rule should be fine:

\[code\]SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1404", SYMLINK+="gsm%s{bInterfaceNumber}"\[/code\]

In theory this should create additional entries under “/dev/” with map to the kernel assigned device names. For example `/dev/gsm00` -&gt; `/dev/ttyUSBXX`. So I could just access `/dev/gsm01`, whatever the boot order was.

The problem is that the device attribute `bInterfaceNumber` is not on the tty device, but on the usb device in the parent hierarchy.

Still it is possible to record the interface number of a first rule, and use it in a second one:

```
SUBSYSTEMS=="usb", ENV{.LOCAL_ifNum}="$attr{bInterfaceNumber}"
SUBSYSTEM=="tty", ATTRS{idVendor}=="12d1", ATTRS{idProduct}=="1404", SYMLINK+="gsm%E{.LOCAL_ifNum}"

```

This stores the attribute “bInterfaceNumber” into the environment variable `.LOCAL_ifNum` (the prefixed dot is a notation for temporary or hidden variables). In the second rule the same variable is pulled on using the `%E` syntax. Newer udev versions also support `$env` instead of `%E`.

Thanks to \[1\] for mentioning this trick!

\[1\] https://unix.stackexchange.com/questions/60154/udev-rule-file-for-modem-not-working