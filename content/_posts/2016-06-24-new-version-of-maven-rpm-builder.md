---
id: 829
title: 'New version of Maven RPM builder'
date: '2016-06-24T13:03:30+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=829'
permalink: /2016/06/24/new-version-of-maven-rpm-builder/
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
    - Development
    - 'Technical Stuff'
tags:
    - Java
    - maven
    - RPM
---

I just released a new version of the [Maven RPM builder](https://ctron.github.io/rpm-builder/). Version 0.6.0 allows one to influence the way the RPM release information is generated during a SNAPSHOT build (also see [issue #2](https://github.com/ctron/rpm-builder/issues/2)).

While the default behavior is still the same, it is now possible to specify the `snapshotBuildId`, which will then be added as release suffix instead of the current timestamp. Setting `forceRelease` can be used to disable the SNAPSHOT specific logic altogether and just use the provided release information.