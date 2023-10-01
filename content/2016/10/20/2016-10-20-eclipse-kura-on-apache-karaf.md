---
id: 866
title: 'Eclipse Kura on Apache Karaf'
date: '2016-10-20T16:13:39+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=866'
permalink: /2016/10/20/eclipse-kura-on-apache-karaf/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - Karaf
    - Kura
---

It took quite a while and triggered a bunch of pull request upstream, but finally I do have [Eclipse Kura™](https://www.eclipse.org/kura/) running with [Apache Karaf™](https://karaf.apache.org/).

Now of course I immediately got the question: Why is that good? After all the recent setup still uses Equinox underneath in Karaf. Now what? … isn’t Equinox and Karaf something different? Read on …

<!-- more -->

## What is Karaf?

Ok, back to the basics. [Eclipse Equinox™](https://www.eclipse.org/equinox/) is an implementation of [OSGi](https://www.osgi.org/). As is [Apache Felix™](https://felix.apache.org/). OSGi is a highly modular Java framework for creating modular applications. And it eats its own dogfood. So there is a thin layer of OSGi (the framework) and a bunch of “add-on” functionality (services) which is part of OSGi, but at the same time running on top of that thin OSGi layer. Now Equinox and Felix both provide this thin OSGi layer as well a set of “standard” OSGi services. But it is possible to interchange service implementations from Equinox to Felix, since both use OSGi. For example in [Package Drone](https://packagedrone.org/) I started to use Equinox as OSGi container, but in some release switched to the Apache Felix ConfigurationAdmin since it didn’t have the bugs of the Equinox implementation. So the final target is a plain Equinox installation with some parts from Apache Felix.

Apache Karaf can be seen as a distribution of OSGi framework and services. Like you have a Linux distribution starting with a kernel and a set of packages which work well together, Karaf is a combination of an OSGi framework (either Felix or Equinox or one of others) and a set of add-on functionality which is tested against each other.

And those add-on services are the salt in the OSGi soup. You can have a command line shell with completion support, JMX support, OSGi blueprint, webserver and websocket suport, JAAS, SSH, JPA and way more. Installing bundles, features or complete archives directly from local sources, HTTP or Maven central. It wraps some non-OSGi dependencies automatically into OSGi bundles. And many 3rd party components are already taking advantage of this. So for example installing [Apache Camel™](https://camel.apache.org/) into an Karaf contain is done with two lines on the Karaf shell.

## What Kura currently does

Eclipse Kura currently assembles its own distribution based on pure and simple Equinox components using a big Ant file. While this has an advantage when it comes to distribution size and the fact that you can control each an every aspect of that distribution, it also comes at a prize that you need to do exactly that. That Ant file needs to create each startup configuration file, knowing about each and every bundle version.

Karaf on the other hand already has a ready to run distribution in various flavors. And has some tooling to create new ones.

## What is different now

In order to bring Kura to Karaf there were a few changes necessary in Kura. In addition to that a new set of Maven projects assembly a target distribution. Right now it is not possible to simply drop Kura into Karaf as a Karaf feature. A special Karaf assembly has to be prepared which can then be uploaded and installed at a specific location. This is mostly necessary due to the fact that Kura expects files at a specific location in the file system. Karaf on the other hand can simple be downloaded, unzipped and started at any location.

In addition to that a few bugs in Kura had to be fixed. Kura did make a few assumption on how Equinox and its service implementations handle things which may no longer be true in other OSGi environments. these fixes will probably make it into Kura 2.1.

## Can I test it today?

If you just want to start up a stable build (not a release) you can easily do this with Docker:

```bash
sudo docker run -ti ctron/kura:karaf-stable # stable milestone  
sudo docker run -ti ctron/kura:karaf-develop # latest develop build  
```

This will drop you in a Karaf shell of Kura running inside docker. You can play around with the console, install some additional functionality or try out an example like [OPC UA with Apache Camel](https://github.com/ctron/de.dentrassi.camel.milo/tree/master/examples/milo-example1).

You can also check out the branch [feature/karaf](https://github.com/ctron/kura/tree/feature/karaf) in my fork of Kura which contains all the upstream patches and the Karaf distribution projects in one branch. This branch is also used to generate the docker images.

## What is next?

**Clean up the target assembly:** Right now assembling the target platform for Karaf is not as simple as I had hoped. This is mostly due to the complexity of such a setup (mixing different variants of Linux, processors and devices) and the way Maven works. With a bit of work this can made even simpler by adding a specific Maven plugin and make one or two fixes in the Karaf Maven plugin.

**Enable Network management:** Right now I disabled network management for the two bare-metal Linux targets. Simply because I did have a few issues getting this running on RHEL 7 and Fedora. Things like ethernet devices which are no longer named “eth0” and stuff like that.

**Bring Kura to Maven Central/More Kura bundles:** These two things go hand in hand. Of course I could simply create more Karaf features, packaging more Kura bundles. But it would be much better to have Kura artifacts available on Maven Central, being able to consume them directly with Karaf. That way it would be possible to either just drop in new functionality or to create a custom Kura+Karaf distribution based on existing modules.

## Will it become the default for Kura?

Hard to say. Hopefully in the future. My plan is to bring it into Kura in the 2.2 release cycle. But this also means that quite a set of dependencies has to go through the Eclipse CQ process I we want to provide Karaf ready distributions for download. A first step could be to just provide the recipes for creating your own Karaf distribution of Kura.

So the next step is to bring support for Karaf into Kura upstream.
