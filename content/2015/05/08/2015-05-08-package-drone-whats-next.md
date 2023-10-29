---
id: 537
title: "Package Drone – what' next?!"
date: '2015-05-08T19:09:43+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=537'
permalink: /2015/05/08/package-drone-whats-next/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:3:"532";s:11:"_thumb_type";s:5:"thumb";}'
spacious_page_layout:
    - default_layout
image: /wp-content/uploads/ibh_PD-Logo_2500x2500_150123-672x372.png
taxonomies:
  categories:
    - Development
    - Infrastructure
    - 'Technical Stuff'
  tags:
    - OSGi
    - 'Package Drone'
---

Every now and then there is some time for Package Drone. So let’s peek ahead what will happen in the next few weeks.

First of all, there is the [Eclipse DemoCamp](http://packagedrone.org/2015/05/06/package-drone-eclipse-democamp-mars-2015-in-munich/) in Munich, at which Package Drone will be presented. So if you want to talk in person, come over and pay us a visit.

<!-- more -->

Also I have been working on version 0.8.0. The more you think about it, the more ideas you get of what could be improved. If I only got the time. But finally it is time for validation! Channels and artifacts can be validated and the outcome will be presented in red and yellow, and a lot more detail ;-). This is a first step towards more things we hope to achieve with validation, like rejecting content and proving resolution mechanisms. Quick fix your artifacts ;-)

Also there are a few enhancements to make it easier for new users to start with Package Drone. “Channel recipes” for example setup up and configure a channel for a specific purpose, just to name one.

Of course this is important since, with a little bit of luck, there will be an article in the upcoming German “[Eclipse Magazin](https://jaxenter.de/magazine/eclipse-magazin)“, which might bring some new users. Helping them to have an easy start is always a good idea ;-)

The next version also brings a new way to upload artifacts. A plain simple HTTP request will do to upload a new artifact. While I would not call it “API”, it definitely is the starting point of exactly that. Planned is a command line client and already available is the [Jenkins plugin for Package Drone](https://github.com/ctron/package-drone-jenkins). It allows to archive artifacts directly to a Package Drone channel, including adding some meta data of the build.

So, if you have more ideas, please raise an issue in the [GitHub issue tracker](https://github.com/ctron/package-drone/issues).
