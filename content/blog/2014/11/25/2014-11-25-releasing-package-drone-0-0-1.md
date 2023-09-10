---
id: 447
title: 'Releasing &#8220;Package Drone&#8221; 0.0.1'
date: '2014-11-25T20:14:19+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=447'
permalink: /2014/11/25/releasing-package-drone-0-0-1/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - Eclipse
    - maven
    - OSGi
    - tycho
---

A package repository for Maven Tycho, OSGi and all the rest.

**Itch**: I want to have a software repository where Maven Tycho can deploy to and P2 can read from. Also I would like to re-use this repository as an OBR or OSGi R5 repository, and possibly as Maven repository.

**Scratch**: Package Drone, [version 0.0.1](https://github.com/ctron/package-drone/releases/tag/v0.0.1)

<!-- more -->

Now there already is the Nexus Repository and the [Nexus Unzip Plugin](https://wiki.eclipse.org/Tycho/Nexus_Unzip_Plugin). However this essentially uploads a full P2 repository ZIP file and uses Nexus as a plain web server, hosting that zipped P2 repository.

Instead I would like to not only have a P2 repository, but also an OSGi R5 repository, based on the same OSGi bundles uploaded. I would also like to upload bundles created by the Maven Bundle Plugin, or BNDtools. Also would I like to make a full, Maven like, release using Tycho and later host this as a Maven 2 repository. Now package drone is not quite there yet, but the basic Tycho Deploy -&gt; P2 Consume workflow already works to some degree.

Package Drone is [hosted on github](https://github.com/ctron/package-drone) and there is a [small readme](https://github.com/ctron/package-drone/blob/master/README.md) and [wiki](https://github.com/ctron/package-drone/wiki).

Be warned, this is alpha quality software. If it works for you, fine. If not please help me fix it!
