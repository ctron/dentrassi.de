---
id: 205
title: 'Build your own SIP trunk with Asterisk and mISDN'
date: '2013-01-22T16:37:34+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=205'
permalink: /2013/01/22/build-your-own-sip-trunk-with-asterisk-and-misdn/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Infrastructure
    - 'Technical Stuff'
tags:
    - Asterisk
    - SIP
---

The mission: “save some bucks by using a free PBX using a cheap isdn card”. Don’t try! Buy something working in the first place. But if you have to, here is one example how it can be done. There are, for sure, many others!

<!-- more -->

The idea was to replace [trixbox](http://trixbox.org/ "trixbox") using an AVM Fritz!PCI card with something more up to date and not that buggy. FreePBX Distro kicked itself out because of the issues with mISDN. Elastix brought in mISDN support but still failed in configuring it. Since the setup was for only 3 users for now and the idea was to later buy something more professional (I really hope it comes to this point), I used [Starface free](http://www.starface.de/en/Produkte/softswitch/starface-free.php "Starface free"). It has 4 users and 10 extensions for free. Yet the free version only allows using SIP providers. Also it was not possible to buy a [Patton SmartNode 4120](http://www.patton.com/products/product_detail.asp?id=452) at the moment, which I still hope to get somewhere in the future. So I needed to build our own SIP trunk since the provider used (M-NET) does not provide SIP trunks as a product.

Everything is done as user `root` unless noted otherwise.

## mISDN + gateway setup

- Install a fresh centos 5 (5.9). You can use the netinstall version since you need practically nothing.
- Be sure to update: yum update
- add the elastix repository: elastix, epel
    
    create file `/etc/yum.repos.d/epel.repo`
    
    ```
    [epel]
    name=Extra Packages for Enterprise Linux 5 - $basearch
    #baseurl=http://download.fedoraproject.org/pub/epel/5/$basearch
    mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch
    failovermethod=priority
    enabled=1
    gpgcheck=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    
    [epel-debuginfo]
    name=Extra Packages for Enterprise Linux 5 - $basearch - Debug
    #baseurl=http://download.fedoraproject.org/pub/epel/5/$basearch/debug
    mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-debug-5&arch=$basearch
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    gpgcheck=1
    
    [epel-source]
    name=Extra Packages for Enterprise Linux 5 - $basearch - Source
    #baseurl=http://download.fedoraproject.org/pub/epel/5/SRPMS
    mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-5&arch=$basearch
    failovermethod=priority
    enabled=0
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
    gpgcheck=1
    
    ```
    
    create file `/etc/yum.repos.d/elastix.repo`
    
    ```
    [elastix-base]
    name=Base RPM Repository for Elastix
    mirrorlist=http://mirror.elastix.org/?release=2&arch=$basearch&repo=base
    #baseurl=http://repo.elastix.org/elastix/2/base/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix
    
    [elastix-updates]
    name=Updates RPM Repository for Elastix
    mirrorlist=http://mirror.elastix.org/?release=2&arch=$basearch&repo=updates
    #baseurl=http://repo.elastix.org/elastix/2/updates/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix
    
    [elastix-beta]
    name=Beta RPM Repository for Elastix
    mirrorlist=http://mirror.elastix.org/?release=2&arch=$basearch&repo=beta
    #baseurl=http://repo.elastix.org/elastix/2/beta/$basearch/
    gpgcheck=1
    enabled=0
    gpgkey=http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix
    
    [elastix-extras]
    name=Extras RPM Repository for Elastix
    mirrorlist=http://mirror.elastix.org/?release=2&arch=$basearch&repo=extras
    #baseurl=http://repo.elastix.org/elastix/2/extras/$basearch/
    gpgcheck=1
    enabled=1
    gpgkey=http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix
    ```
- import the required keys:
    ```
    rpm --import http://repo.elastix.org/elastix/RPM-GPG-KEY-Elastix
    rpm --import http://fedoraproject.org/static/217521F6.txt
    ```
Now comes the tricky part. The mISDN modules from elastix require an older kernel than the current from centos. This might change in the future but for me, right now, this is the case.

Find oud the most recent mISDN version:

```
yum deplist mISDN | grep "package:"
```

This will give you a list of mISDN versions currently known to yum. Write don’t the most recent one.

```
package: mISDN-modules.i686 1.1.9.1-2
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_164.6.1.el5
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_194.el5
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_164.el5
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_164.11.1.el5
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_238.12.1.el5
package: mISDN-modules.i686 1.1.9.1-1.2.6.18_194.3.1.el5
```

In this case `mISDN-modules.i686 1.1.9.1-2`.  
So check for the kernel of this version:

```
yum deplist mISDN-modules-1.1.9.1-2
```

Note the different syntax on the version! You need to specify `mISDN-$VERSION` and without the `i686` identifier!

```
package: mISDN-modules.i686 1.1.9.1-2
  dependency: kernel = 2.6.18-238.12.1.el5
   provider: kernel-PAE.i686 2.6.18-348.el5
   provider: kernel-debug.i686 2.6.18-348.el5
   provider: kernel-xen.i686 2.6.18-348.el5
   provider: kernel.i686 2.6.18-348.el5
   provider: kernel-xen.i686 2.6.18-194.3.1.el5
   provider: kernel.i686 2.6.18-164.11.1.el5
   provider: kernel.i686 2.6.18-194.el5
   provider: kernel-xen.i686 2.6.18-164.6.1.el5
   provider: kernel.i686 2.6.18-238.12.1.el5
   provider: kernel.i686 2.6.18-194.3.1.el5
   provider: kernel-xen.i686 2.6.18-194.el5
   provider: kernel-xen.i686 2.6.18-238.12.1.el5
   provider: kernel-xen.i686 2.6.18-164.11.1.el5
   provider: kernel.i686 2.6.18-164.6.1.el5
  dependency: mISDN >= 1.1.9.1
   provider: mISDN.i686 1.1.9.1-0
   provider: mISDN.i686 1.1.9.1-2
  dependency: module-init-tools
   provider: module-init-tools.i386 3.3-0.pre3.1.60.el5_5.1
  dependency: /bin/sh
   provider: bash.i386 3.2-32.el5
```

The required kernel is `2.6.18-238.12.1.el5`. So we need to install it:

```bash
yum install kernel-2.6.18-238.12.1.el5
```

Depending on your setup you need to use “yum downgrade kernel 2.6.18-238.12.1.el5” instead.

Check if the kernel is installed:

```bash
yum list "*kernel*"
```

In my case:

```
Installed Packages
kernel.i686                    2.6.18-238.12.1.el5                     installed      
kernel-PAE.i686                2.6.18-348.el5                          installed      
Available Packages
kernel.i686                    2.6.18-348.el5                          base           
kernel-PAE-devel.i686          2.6.18-348.el5                          base           
kernel-debug.i686              2.6.18-348.el5                          base           
…
```

So I got one that I don’t want (kernel-PAE.i686 2.6.18-348.el5) and one possible upgrade which must not be installed!

Removing the kernel is easy. But be careful not to uninstall the wrong one!

```
rpm -e kernel-PAE-2.6.18-348.el5
```

Checking the file `/boot/grub/menu.lst` shows only one kernel now, the correct one!

```



```

Now we can install mISDN and asterisk.

```bash
yum install libxslt
yum install asterisk-mISDN mISDN
```

One possible way out of this update mess is to disable the original centos repositories and rely only on the elastix sources.

Now reboot

```bash
reboot
```

## mISDN setup

Scan for your mISDN card:

```bash
/etc/init.d/mISDN scan
```

You should get something like:

```bash
1 mISDN compatible device(s) found:
>> avmfritz
```

Now store that configuration:

```
/etc/init.d/mISDN config
```

Not check the config file <q>/etc/mISDN.conf</q> if this is really your configuration. Depends on what setup you have. Maybe you need to change it.

This should give you something like:

```
-- Loading mISDN modules --
>> /sbin/modprobe --ignore-install capi
>> /sbin/modprobe --ignore-install mISDN_core debug=0
>> /sbin/modprobe --ignore-install mISDN_l1 debug=0
>> /sbin/modprobe --ignore-install mISDN_l2 debug=0
>> /sbin/modprobe --ignore-install l3udss1 debug=0
>> /sbin/modprobe --ignore-install mISDN_capi
>> /sbin/modprobe --ignore-install avmfritz protocol=0x2 layermask=0xf
>> /sbin/modprobe --ignore-install mISDN_dsp debug=0 options=0
```

And activate on boot:

```bash
chkconfig mISDN on
chkconfig --list mISDN
```

Now you should be able to see the card in action:

```bash
misdnportinfo
```

For me:

```
Port  1: TE-mode BRI S/T interface line (for phone lines)
 -> Interface is Poin-To-Point.
 -> Protocol: DSS1 (Euro ISDN)
 -> childcnt: 2
--------

mISDN_close: fid(3) isize(131072) inbuf(0x8cec060) irp(0x8cec060) iend(0x8cec060)
```

Now we need to re-create the configuration in a different format \*sigh\*

\[code\]/usr/sbin/misdn-init config\[/code\]

And edit the file <q>/etc/misdn-init.conf</q> to match the content of <q>/etc/mISDN.conf</q>. For example in my case I had to change from PTMP mode to PTP in both files. Asterisk will read the latter file and use it for its configuration.

Finally edit asterisks own misdn configuration file: /etc/asterisk/misdn.conf

Check the section “\[intern\]” near the end of the file and remove/rename the section to something like:

```ini
[fpstn]
; define your ports, e.g. 1,2 (depends on mISDN-driver loading order)
ports=1,2
; context where to go to when incoming Call on one of the above ports
context=from-pstn
msns=*
```

Again this depends heavly on your setup. Important is that the section is named \[fpstn\] and “context=from-pstn” since we need that later.

## asterisk setup

After some hours of googling and trial&amp;error I finally came up with some useful resources on the net:

At https://confluence.terena.org/pages/viewpage.action?pageId=131104 there is quite a good explanation of how to set up an asterisk VOIP gateway (SIP trunk). Still with some issues but it was a pretty good base. Also it did not use mISDN.

Asterisk had to be configured to provide a SIP user (the trunk). So replace the file “/etc/asterisk/sip.conf” with the following content:

```ini
[general]
context=guest                   ; Default context for incoming calls (non authenticated)

disallow=all                    ; First disallow all codecs
;allow=g729
allow=gsm
allow=alaw
allow=ulaw

language=en                     ; Default language setting for all users/peers

localnet=192.168.0.0/255.255.0.0; All RFC 1918 addresses are local networks
localnet=10.0.0.0/255.0.0.0     ; Also RFC1918
localnet=172.20.0.0/255.255.0.0          ; Another RFC1918 with CIDR notation
localnet=169.254.0.0/255.255.0.0 ;Zero conf local network

jbenable=yes
jbforce=yes
jbimpl = fixed

[600]
username=600
secret=somesecret600
type=friend
host=dynamic
context=sip
insecure=port,invite
```

This is a quite short configuration, but we only need one account for starface to hook up to the asterisk server. You should change the secret of course. The “insecure=port,invite” was necessary since asterisk otherwise rejected the starface pbx when making calls, although the initial registration using the username and password was successful. In pre-1.8 versions of asterisk this was “insecure=very”, but this is not working anymore.

So now we have two parts in the asterisk box, an mISDN trunk and a SIP account which will act as a trunk. Now we need to pass calls between them. Therefore we configure some dialplans in the “/etc/asterisk/extensions.conf”:

```ini
[general]
static=yes
writeprotect=yes

[from-pstn]
exten => _1234.,1,Dial(SIP/600/${EXTEN})

[sip]
exten => _0.,1,Dial(misdn/g:fpstn/${EXTEN})
```

So everthing that comes in using ISDN (from-pstn) will be directed to the SIP account 600 passing on the original number so that starface can use it. The rule “\_1234.” must be adapted to match your telephone number.

Also everything that comes from the SIP account (starface) and starts with a zero will be sent to ISDN.

Tweaking the rules will be a task, then everybody needs something different here I guess.

Finally re-start asterisk:

```bash
/etc/init.d/asterisk restart
```

## starface

Setting up Starface was the real easy part. Get the ISO image, install into the KVM server (Ubuntu 12.04 using KVM as virtualization). Starface officially supports only vmware, but is still based on Linux. I had to use “pcnet” as network interface and “sata” for the disk since the “virtio” module won’t work with Starface. Room for improvement ;-)

Installing Starface was simply booting from the ISO image and installing to the disk. The SIP trunk could now easly be added using the following settings:

- Create a new line
- Select “new” as provider
- Use the following provider settings (leave other settings to default): 
    - host=&lt;your-sip-trunk-ip&gt;
- Enter the username and password from above (600, somesecret600)

### setting up starface

This is pretty straight forward now. Provision your phone. Setup a number. And make a call!

## Some checks

### SIP peers

Check if starface registeres with your sip trunk using the asterisk command line on the gateway:

```bash
asterisk -r
sip show peers
```

### SIP Debugging

SIP Debugging can be enabled using the asterisk command `sip set debug on`.

### Turn on the full log

Edit `/etc/asterisk/logger.conf` and comment in the `full` line
