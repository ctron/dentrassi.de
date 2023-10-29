---
id: 478
title: 'Package Drone 0.0.4'
date: '2015-01-14T12:31:27+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=478'
permalink: /2015/01/14/package-drone-0-0-4/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
    - 'Technical Stuff'
  tags:
    - bndtools
    - Eclipse
    - Maven
    - OSGi
    - Tycho
    - 'Package Drone'
---

I am happy to announce that [package drone 0.0.4 is released](https://github.com/ctron/package-drone/releases/tag/v0.0.4).

Be sure to check out [the most recent release](https://github.com/ctron/package-drone/releases).

<!-- more -->

The new features are:

- Support for OSGi R5 XML repository index
- Create Eclipse source bundles from Maven source attachments
- Manage database structure from within package drone (nor more command line SQL)

See the full release information at [github](https://github.com/ctron/package-drone/releases/tag/v0.0.4).

Especially the OSGi R5 repository support allows a few more use cases, like letting Bndtools consume artifacts from a P2 build, PDE or Tycho.
