---
id: 417
title: 'OSGi EE – Modular Web Applications'
date: '2014-11-14T17:10:12+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=417'
permalink: /2014/11/14/osgi-ee-modular-web-applications/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
    - 'Technical Stuff'
  tags:
    - Eclipse
    - OSGi
---

Creating a modular web application in Java still is a tricky task. While there has been some improvement with web fragments, this still is far away from what you actually want.

But what is it that you (or better I) want:

- Modularity – Make the application extensible using plugins. Not just one big block. Install additional functionality with a few clicks
- Easy setup – Setting up a JEE server like JBoss can be a pain in the ass. First you have to configure your datasource with some obscure XML file. It would be way better to be directed to some sort of setup screen, asking for all database (etc.) information first. Guiding you through a setup process. With JEE your web application won’t even start if your JPA data source cannot be loaded since the driver is not specified.

<!-- more -->

Now there are a lot of applications which provide this flexibility. Atlassian, Jenkins, and a few more, all do a great job. Most PHP web applications guide you through a web setup when you first install the software. So why can’t Java do this out of the box?

When you think of modularity and services, OSGi immediately comes into my mind. However “the Web” still is a strange place for OSGi setups. Yes you can register a servlet with OSGi and access it through “http”. But that is just the start. You want JSP, Form Validation, maybe even Spring WebMVC.

There are a few setups I stumbled over, pax runner with pax web. However they bring in a pretty old jetty 7, when there is jetty 9.2.x with Servlet 3.1 support. There are [some Apache Karaf tutorials](http://liquid-reality.de/display/liquid/Karaf+Tutorials), however there is also no JSP support, just a custom Vaadin bridge.

Jetty 9.2.x [claims to have OSGi support](https://www.eclipse.org/jetty/documentation/current/framework-jetty-osgi.html) out of the box. In combination with Eclipse Equinox this should be an easy setup. And although it really works, you know what you have to do. I got it working in the Eclipse IDE, but it still provides most things you really want.

In order to be able to reproduce it myself, I made a few ant script and sample projects out of what I learned and decided to put them up on github.

So if you want to build modular web applications with Jetty, Equinox, Eclipse, Hibernate Validation, Spring WebMV and more (with a recent version of all components) you can have a look at <https://github.com/ctron/osgiee>.

If you have more examples working or find a bug, please let me know ;-)
