---
id: 525
title: 'Controlling the screen resolution of a Windows Guest in VirtualBox'
date: '2015-02-24T14:18:09+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=525'
permalink: /2015/02/24/controlling-the-screen-resolution-of-a-windows-guest-in-virtualbox/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
categories:
    - Infrastructure
    - 'Technical Stuff'
---

Now I wanted to create another screencast for [Package Drone](http://packagedrone.org) and stumbled over the same issue again. Time to document it ;-)

<!-- more -->

VirtualBox with the Windows Guest drivers installed allows for any screen resolution which you could ever think of. Just resize the guest window and the screen resolution of the guest system will adapt.

But what if you want to set a specific screen resolution, pixel perfect?! Windows allows you to change the screen resolution but does not allow you to enter width and height. You are stuck with a slider of presets.

Googling around you will find the idea of adding a custom screen resolution to that selection. However, it seems that for some users this works, for others it doesn’t. I am one of the latter users.

But there is simple command which will tells your guest session to change to a specific resolution, directly from the command line:

\[code\]VBoxManage controlvm "My virtual machine" setvideomodehint 1280 720 32\[/code\]

This will tell the *currently running* virtual machine to change resolution to 1280×720 at 32bit.
