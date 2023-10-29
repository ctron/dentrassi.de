---
id: 795
title: 'Building RPMs on any platform with Maven'
date: '2016-04-26T11:52:53+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=795'
permalink: /2016/04/26/building-rpms-on-any-platform-with-maven/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
    - 'Technical Stuff'
  tags:
    - Maven
    - RPM
    - 'Package Drone'
---

In several occasions I had to build RPM packages for installing software. In the past I mostly did it with a Maven build using the <q>[RPM Maven Plugin](http://www.mojohaus.org/rpm-maven-plugin/)</q>.

The process is simple: At the end of your build you gather up all resources, try to understand the [mapping configuration](http://www.mojohaus.org/rpm-maven-plugin/map-params.html), bang your head a few times in order to figure out way to work with `-SNAPSHOT` versions and that’s it. In the end you have a few RPM files.

<!-- more -->

The only problem is, that the plugin actually creates a <q>spec</q> file and runs the `rpmbuild` command line tool. Which is, of course, only available on an RPM like system. Fortunately Debian/Ubuntu based distributions, although they use something different, provide at least the `rpmbuild` tool.

On Windows or Mac OS the situation looks different. Adding `rpmbuild` to Windows can be quite a task. Still the question remains, why this is necessary since Java can run on all platforms.

So time to write a Maven plugin which does not the `rpmbuild` tool, but create RPM packages native in Java:

[`de.dentrassi.maven:rpm`](https://ctron.github.io/rpm-builder/) is a Maven Plugin which does create RPM packages using plain Java as a Maven Plugin. The process is simply and fast and does not require additional command line tool. The plugin is open source and the source code is available on GitHub [ctron/rpm-builder](https://github.com/ctron/rpm-builder).
