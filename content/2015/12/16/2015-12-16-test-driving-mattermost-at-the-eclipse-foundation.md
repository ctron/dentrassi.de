---
id: 714
title: 'Test driving "Mattermost" at the Eclipse Foundation'
date: '2015-12-16T13:05:59+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=714'
permalink: /2015/12/16/test-driving-mattermost-at-the-eclipse-foundation/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:721;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
    - 'Technical Stuff'
tags:
    - Eclipse
    - mattermost
    - packagedrone
extra:
    article_image:
        src: /wp-content/uploads/matermost_square.png
        alt: Mattermost Logo
---

Thanks to [@bruncedric](https://twitter.com/bruncedric) and the Eclipse Webmasters we were able to quickly start a test of [Mattermost](http://www.mattermost.org/) at <https://mattermost-test.eclipse.org>.

“Mattermost” is a [Slack](https://slack.com/)/[HipChat](https://www.hipchat.com/)/… like web messaging system (aka webchat). I don’t want to go into too much detail of the system itself, but the main idea is to have a “faster-than-email” communication form for a team of people. Comparable to [IRC](https://en.wikipedia.org/wiki/Internet_Relay_Chat), but more HTML5-ish. It also features a REST API, which can be used to automate inbound and outbound messages to the different channels.

<!-- more -->

Why not Slack or HipChat? Simply because the Eclipse Foundation requires its IT components to be based on open source solutions and not rely on any service which can go away at any moment, without the possibility to rescue your data in a portable format. Which is quite a good approach if you ask me. Just imaging you have years of data and loose it due to fact that your service provider simply shuts down.

So right now there is a Mattermost instance at <https://mattermost-test.eclipse.org> which is intended to be a setup for testing “Mattermost” and figuring out how it can be used to give Eclipse projects a benefit. Simply adding more technical gimmicks might not always be a good idea.

Also does [Package Drone](http://packagedrone.org) have [a channel at mattermost](https://mattermost-test.eclipse.org/eclipse/channels/package-drone).

So go ahead and give it a test run …

… if you have troubles or ideas … just look at [eclipse/mattermost](https://mattermost-test.eclipse.org/eclipse/channels/mattermost).
