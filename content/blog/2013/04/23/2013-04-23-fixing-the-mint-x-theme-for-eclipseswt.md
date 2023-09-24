---
id: 277
title: 'Fixing the Mint-X theme for Eclipse/SWT'
date: '2013-04-23T15:15:52+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=277'
permalink: /2013/04/23/fixing-the-mint-x-theme-for-eclipseswt/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:278;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - 'Technical Stuff'
tags:
    - Eclipse
    - linux
    - mint
    - SWT
---

If you are running Mint, Eclipse and you like the Mint-X theme, you might be a bit frustrated every time you open up Eclipse. Especially with Eclipse 4.2 the design of the toolbars is pretty messed up. See the launchpad bug entry: <https://bugs.launchpad.net/linuxmint/+bug/1168281>

<!-- more -->

![eclipse1](http://dentrassi.de/wp-content/uploads/eclipse1.png)

Gladly this is only a minor glitch which [can be fixed easily](https://bugs.launchpad.net/linuxmint/+bug/1168281/+attachment/3651502/+files/mintx.patch). Hopefully the [change](https://github.com/ctron/mint-x-theme/commit/135f78193c17d51386c191f23ff11925b8714a61) of the github pull request will find its way into Mint.
