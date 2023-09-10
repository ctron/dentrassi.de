---
id: 3607
title: 'Google Summer of Code 2017 with Eclipse Kapua'
date: '2017-05-08T10:18:31+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3607'
permalink: /2017/05/08/google-summer-of-code-2017-with-eclipse-kapua/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - gsoc
    - Kapua
---

I am happy to announce that Eclipse Kapua got two slots in this year’s [Google Summer of Code](https://summerofcode.withgoogle.com/). Yes, two projects got accepted, and both are for the [Eclipse Kapua](https://www.eclipse.org/kapua/) project.

<!-- more -->

[Anastasiya Lazarenko](https://www.facebook.com/AnastasiLa97) will provide a simulation of a fish tank and [Arthur Deschamps](https://arthurdeschamps.github.io/) will go for a supply chain simulation. Both simulations are planned to feed in their data into [Eclipse Kapua](https://www.eclipse.org/kapua/) using the [Kura simulator framework](https://github.com/eclipse/kapua/tree/develop/simulator-kura). Although both projects seem to be quite similar from a high level perspective, I think they are quite different when it comes to the details.

The basic idea is not to provide something like a statistically/physically/… valid simulation, but something to play around and interact with. Spinning up a few virtual instances of both models and hooking them up to our cloud based IoT solution and interact a bit with them, getting some reasonable feedback values.

For Kapua this will definitely mean evolving the simulator framework based on the feedback from both students, making it (hopefully) easier to use for other tasks. And maybe, just maybe, we can also got for the extra mile and make the same simulations available for [Eclipse Hono](https://www.eclipse.org/hono/).

If you want to read more about Anastasiya and Arthur just read through their introductions on [kapua-dev@eclipse.org](https://dev.eclipse.org/mailman/listinfo/kapua-dev) and give them a warm welcome:

[read Anastasiya’s introduction](https://dev.eclipse.org/mhonarc/lists/kapua-dev/msg00272.html)  
[read Arthur’s introduction](https://dev.eclipse.org/mhonarc/lists/kapua-dev/msg00271.html)

Best of luck to you!
