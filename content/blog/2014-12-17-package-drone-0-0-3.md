---
id: 464
title: 'Package Drone 0.0.3'
date: '2014-12-17T18:49:24+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=464'
permalink: /2014/12/17/package-drone-0-0-3/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - Eclipse
    - maven
    - OSGi
    - tycho
---

There is a new version of package drone – 0.0.3!

See the release notes on github for [Version 0.0.3](https://github.com/ctron/package-drone/releases/tag/v0.0.3)

Beside a lot new features, which are described in the release notes, the two most interesting topics are:

## Two working workflows

Now depending on the channel configuration it is now possible to run channels either for Maven Tycho or by manually uploading artifacts. The output always can be consumed as P2 repository.

With Maven Tycho the P2 metadata created by Tycho gets uploaded and used by the P2 adapter to create the P2 repository data.

In plain OSGi mode Package Drone extracts the dependency information directly from the uploaded artifacts and uses it in order to create virtual P2 meta data file. In both cases the P2 adapter uses the same way to construct the final repository.

For the plain OSGi mode it is also possible to create a generated P2 feature artifact. For this a new instance of a generated P2 feature is created, the meta data like Feature ID, version, etc are manually provided, and package drone will add all bundles in the channel to the feature automatically, so that there always is a feature available for plain OSGi bundles.

The plain OSGi mode is extremely interesting if you need to consume OSGi bundles which are hosted on Maven Central, but have no P2 repository available.

Which hopefully will also be one of the next features in package drone, a replicated artifacts, from Maven Central (or any other Maven 2 repository).

## The replacement of spring

I started with Spring WebMVC in order to have an easy start. The idea always was to have a OSGi style, modular application. And Spring simply can provide the base for that. While Spring might be a nice framework for monolithic web applications, it simply is not modular enough for OSGi. Yes, you head right, Spring is not modular enough. First of all, Spring cannot be brought into the OSGi environment, working between bundles. Having one bundle with all and everything inside is ok. But splitting it up seems impossible.

In the past there was [Spring Dynamic Modules](http://docs.spring.io/osgi/docs/current/reference/html/ "Spring Dynamic Modules") (Spring DM), which changed to [Eclipse Virgo](https://www.eclipse.org/virgo/ "Eclipse Virgo") now. However Spring DM is dead and Eclipse Virgo seems only provides part of what you need, and almost nothing when it comes to the web.

So the solution was to write a small web dispatching layer, use the idea of Spring’s @Controller mechanism and use real OSGi. Controllers now get registered as OSGi service, once they have all their dependencies met. A central dispatcher servlet provides access to all controllers, no matter which bundle registers them. Once the service is gone, the controller is removed. By having real dynamic services it is easily possible to add new functionality, menu entries, resources during runtime, running in the same web context. Install and update plugins, perform a simple setup, things that every PHP web application can do.

Of course the downside is, that part of Spring’s functionality gets replicated, but it simply was to much trouble to split off parts of Spring WebMVC.