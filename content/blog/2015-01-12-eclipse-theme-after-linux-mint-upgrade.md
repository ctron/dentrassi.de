---
id: 475
title: 'Eclipse theme after Linux Mint Upgrade'
date: '2015-01-12T13:02:44+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=475'
permalink: /2015/01/12/eclipse-theme-after-linux-mint-upgrade/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - 'Technical Stuff'
tags:
    - Eclipse
    - gtk
    - linux
    - mint
    - SWT
---

A while ago I wrote about a [theming issue](https://dentrassi.de/2013/04/23/fixing-the-mint-x-theme-for-eclipseswt/ "Fixing the Mint-X theme for Eclipse/SWT") with Linux Mint and Eclipse. It took a while longer than expected, but the change [finally made it into](https://bugs.launchpad.net/linuxmint/+bug/1168281) Linux Mint in version 17.1.

However, starting with Linux Mint 17, there seems to be a new issue. Not that dramatic like the old one, but still somewhat annoying. The default Linux Mint theme (Mint-X) chooses a light gray base color value as a background. This might look nice in most applications, however the mixture of Eclipses (E4) recent approach to create its own theming over the operating system, somewhat collides with that.

Text editors and the tree view inherit a light gray background from the operating system theme, while other Eclipse background elements stay white.

There seems to be a simple fix for that however. Edit the file `/usr/share/themes/Mint-X/gtk-2.0/gtkrc` and change the first real line from:

\[code\]gtk\_color\_scheme = "bg\_color:#d6d6d6\\nselected\_bg\_color:#9ab87c\\nbase\_color:#F7F7F7" # Background, base.\[/code\]

to:

\[code\]gtk\_color\_scheme = "bg\_color:#d6d6d6\\nselected\_bg\_color:#9ab87c\\nbase\_color:#FFFFFF" # Background, base.\[/code\]

However, and that is why I stumbled over this after the upgrade to Mint 17.1, this change will be overridden after an upgrade of the theme package. This never happened one in version 17, but you never know.

*Note:*  It is also interesting that Eclipse/SWT seems to use GTK 2 instead of GTK 3. If you have some information in that, please drop me a line!