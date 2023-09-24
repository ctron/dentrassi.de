---
id: 3874
title: 'Eclipse Kura on the Intel UP² with CentOS'
date: '2018-05-16T13:01:27+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3874'
permalink: /2018/05/16/intel-up%c2%b2-eclipse-kura/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3883;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - CentOS
    - Eclipse
    - IoT
    - Kura
---

![Intel UP²](https://dentrassi.de/wp-content/uploads/20180515_171043-292x300.jpg) In the past I was testing modifications to Kura with a Raspberry Pi 3 and Fedora for ARM. But I got a nice little Intel UP² just recently, and so I decided to perform my next Kura tests, with the modifications to the Apache Camel runtime in Kura, on this nice board. Creating a new device profile for Kura using CentOS 7 and the Intel UP² looked like a good idea anyway.

<!-- more -->

At the time of writing, the PR for merging the device profile into Kura is still pending ([PR #2093](https://github.com/eclipse/kura/pull/2093)). But my hope is that this will be merged before Kura 4 comes out.

## Build your own Kura image

But it is possible to try this out right now by using the preview branch ([preview/intel\_up2\_1](https://github.com/ctron/kura/tree/preview/intel_up2_1)) on my forked repository: [ctron/kura](https://github.com/ctron/kura).

The following commands use the `kura-build` container. For more information about building Kura with this container see: <https://github.com/ctron/kura-build> and <https://hub.docker.com/r/ctron/kura-build/>.

So for the moment you will need to build this image yourself. But if you have Docker installed, then it only needs a few minutes to create your own build of Kura:

```bash
docker run -v /path/to/output:/output -ti ctron/kura-build -r ctron/kura -b preview/intel_up2_1 -- -Pintel-up2-centos-7
```

Where `/path/to/output` must be replaced with a local directory where the resulting output should be placed. If you are running Docker with SElinux enabled, then you might need to append `:z` to the volume:

```bash
docker run -v /path/to/output:/output:z -ti ctron/kura-build -r ctron/kura -b preview/intel_up2_1 -- -Pintel-up2-centos-7
```

As you might guess, it is also possible to build other branches and repositories of Kura in the same way. That docker image only ensures that all the necessary build dependencies are present when executing the build.

If you are running on Linux and do have all the dependencies installed locally. Then of course there is no need to run through Docker, you can simply call the `build-kura` script directly:

```bash
./build-kura preview/intel_up2_1 -r ctron/kura -b preview/intel_up2_1 -- -Pintel-up2-centos-7
```

## Setting up CentOS 7

This is rather simple step, you simply need to download CentOS from <https://www.centos.org/download/> (the Minimal ISO is just fine). Copy the ISO to a USB stick (<https://wiki.centos.org/HowTos/InstallFromUSBkey>). On a Linux-ish system this should work like (where `/dev/sdX` is the USB stick, all data on this stick will be lost!):

```bash
sudo dd if=CentOS-7-x86_64-Minimal-1804.iso of=/dev/sdX bs=8M status=progress oflag=direct
```

Rebooting your UP with the USB stick attached, this should reboot into the CentOS installer from where you can perform a standard installation.

After the installation is finished and you booted into CentOS, you will need to enable [EPEL](https://fedoraproject.org/wiki/EPEL), as Kura requires some extra components (like `wireless-tools` and `hostapd`). You can do this by executing:

```bash
sudo yum install epel-release
```

You might also want to install a more recent kernel into CentOS. All the core things works with the default CentOS kernel. However some things like support for the GPIO support is still missing in the default CentOS kernel. But the mainline kernel from [ELRepo](http://www.elrepo.org) can easily be installed:

```bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
yum --enablerepo=elrepo-kernel install kernel-ml
```

For more information check e.g.: <https://www.howtoforge.com/tutorial/how-to-upgrade-kernel-in-centos-7-server/>

## Installing Kura on the Intel UP²

Copy the RPM you just created from the build process over to the UP, e.g. by:

```bash
scp kura-build-output/2018XXXX-YYYY/kura-intel-up2-centos-7*.rpm user@my-up:
```

And then on the device run:

```bash
yum install kura-*.rpm
```

This will install the Kura package as well as any required dependencies. After the installation has completed, reboot the machine and navigate your web browser to “http://my-up”, using the credentials “admin” / “admin”.

## More information

- **[Eclipse Kura](https://eclipse.org/kura)**
- **[Kura Build container](https://github.com/ctron/kura-build)**
- **[Intel UP²](http://www.up-board.org/upsquared)**
- **[PR #2093](https://github.com/eclipse/kura/pull/2093 "Add Intel UP2 support with CentOS 7 #2093")** – Add Intel UP2 support with CentOS 7
