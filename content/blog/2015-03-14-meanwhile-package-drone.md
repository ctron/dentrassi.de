---
id: 529
title: 'Meanwhile @ Package Drone'
date: '2015-03-14T15:32:45+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=529'
permalink: /2015/03/14/meanwhile-package-drone/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:532;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - OSGi
    - 'Package Drone'
---

Since [Package Drone](http://packagedrone.org "Package Drone") has its own home now, I would simple like to sum up here what progress Package Drone has made in the last few weeks.

First of all, the most recent release, as of now, is 0.4.0. The last two releases were mostly focused about the processing of zipped P2 repositories and what comes with that. These can be processed in two different ways now. Either using the Unzip adapter, which is more like a way of deep linking, but still allows one to access a P2 repository inside that ZIP artifact. The second way it the P2 repository unzipper aspect, which unzips bundles and features and create virtual child artifacts. The second approach makes these artifacts available to all other Package Drone functionality, but also modifies the original content but unzipping and creating new meta data. However both variants can be used at the same time!

There is also a setup for [OpenShift](https://www.openshift.com/ "OpenShift"), and a [quickstart](https://hub.openshift.com/quickstarts/90-package-drone "Package Drone QuickStart") at the OpenShift Hub. So if you want to try out Package Drone, the most simplest ways, just create a free account at OpenShift und simply deploy a new Package Drone setup with a few clicks. Including the database setup.

If course there have been lots of things cleaned up and improved in the UI and the backend system, but this is more a topic for the actual release notes at GitHub.

So the question is, what the future will bring. One thing I would like to see Postgres again as a database. With the most recent Postgres JDBC driver and some help from my colleague, this might be feature appearing in one of the next versions. MySQL works fine, but also has a very bad behavior when it comes to BLOB support. And since all artifacts are stored in the database, this can cause some huge memory requirement. Hopefully Postgres does a better job here.

Of course there is also the idea of storing the artifacts separately in the file system. While this requires a little bit of extra processing when it comes to backup up your system, it might be right time to add a full backup and restore process to Package Drone. This would also solve the problem of how to switch between storage backends.

And of course, I you would like to help out, please report bugs and become a contributor ;-)