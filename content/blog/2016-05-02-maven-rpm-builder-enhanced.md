---
id: 804
title: 'Maven RPM builder, enhanced'
date: '2016-05-02T12:04:36+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=804'
permalink: /2016/05/02/maven-rpm-builder-enhanced/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - Java
    - maven
    - RPM
---

The [Maven RPM Builder](https://ctron.github.io/rpm-builder/) got a few new features. Version 0.3.0 can now:

- Create [symbolic links](https://ctron.github.io/rpm-builder/entry.html)
- Specify [pre/post install/remove scripts](https://ctron.github.io/rpm-builder/scripts.html)
- Declare all kinds of [dependencies](https://ctron.github.io/rpm-builder/deps.html) (requires, provides, conflicts, obsoletes)
- And has a much [better documentation](https://ctron.github.io/rpm-builder/rpm-mojo.html)

And of course a few bugs got fixed as well ;-)