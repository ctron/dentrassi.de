---
id: 367
title: 'Creating Mac OS X Icons (icns) on Linux'
date: '2014-02-25T09:58:58+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=367'
permalink: /2014/02/25/creating-mac-os-x-icons-icns-on-linux/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
---

Time again for some new icons for an Eclipse RCP launcher. While The Gimp can easily create XPM and Windows ICO files, when it comes to Mac OS “icns” format, you won’t have any built in support.

There are some fine tools out there for Mac OS, but if you are running Linux and don’t want to buy a Mac just for creating some icon files, [png2icns](http://icns.sourceforge.net/ "libicns") comes to the rescue. It is a small command line tool which simply creates an “icns” files from some “png” files.

Create your icon files as “png” in multiple resolutions. If you are creating an Eclipse RCP launcher, you will, most likely, have them anyway for creating your Windows “ico” file. Place them in any folder you like:

```
-rwxr-xr-x 0 jens jens   1427 Feb 24 10:49 icon_16px.png
-rwxr-xr-x 0 jens jens   2003 Feb 24 10:49 icon_32px.png
-rwxr-xr-x 0 jens jens   2560 Feb 24 10:48 icon_48px.png
-rwxr-xr-x 0 jens jens   5304 Feb 24 10:48 icon_128px.png
-rwxr-xr-x 0 jens jens   9883 Feb 24 10:47 icon_256px.png
```

Ensure that you have the “png2icns” application installed. On Ubuntu it comes with the package “icnsutils”, which can simply be installed by executing:

```
sudo apt-get install icnsutils
```

Now call “png2icns”. As the man page suggest you need to provide all PNG files, that you want to be part of the icon, as argument. The first argument is the output filename. Also you can let the shell find the correct PNG file by using the wildcard (\*):

```
png2icns icon.icns icon_*px.png
```

Easy! ;-)

PS: If anything goes wrong, “png2icns” will complain at the command line (e.g. due to some wrong resolution).