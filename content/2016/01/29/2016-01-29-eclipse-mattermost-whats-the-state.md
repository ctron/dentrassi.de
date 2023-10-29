---
id: 753
title: "Eclipse Mattermost – What's the state?!"
date: '2016-01-29T16:47:40+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=753'
permalink: /2016/01/29/eclipse-mattermost-whats-the-state/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:754;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Infrastructure
    - 'Technical Stuff'
  tags:
    - Eclipse
    - Mattermost
---

A few weeks ago we started to [test Mattermost](https://dentrassi.de/2015/12/16/test-driving-mattermost-at-the-eclipse-foundation/) as a communication channel for Eclipse Foundation projects. So, how is it going?

<!-- more -->

First of all [Cédric Brun](http://cedric.brun.io/about/) wrote a [bunch of Java tasks](https://github.com/cbrun/jstuart) which create Mattermost events based on various other Eclipse systems (like Gerrit, Bugzilla, Twitter, Forum, …) which integrate nicely with the Mattermost channels and allow each project to aggregate all these events in a single location. So you actually can get a notification about a new Forum entry for your Eclipse project in Mattermost now. Cool stuff! Many thanks!

From the usage side we are currently approaching the 100 user mark. At the moment of writing there are 94 registered users, 24 public and 8 private channels. About 150 posts per day and between 10 to 20 active users. You can have a look at the statistics below.

So is it a success? Well I goes into the right direction. Please don’t forget that this is just a test, but on the other hand there are people which are using it on a day by day basis for their Eclipse process. The usage of one big team with many channels (even multiple per project) seem to work fine. Single-sign-on will be a topic, right now Mattermost does have its user management. Also is the setup for projects still a manual process, which could be automated somehow. So there are a few topic left to solve.

But for me it is really amazing to see how quickly a new communication platform was established if all people work together. And it seems that people accept the new system quite well. I really hope we can establish this as a permanent solution.

[![Mattermost Statistics 2016-01-29](https://dentrassi.de/wp-content/uploads/mattermost_stats_1.png)](https://dentrassi.de/wp-content/uploads/mattermost_stats_1.png)
