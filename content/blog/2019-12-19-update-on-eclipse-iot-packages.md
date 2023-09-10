---
id: 4373
title: 'An update on Eclipse IoT Packages'
date: '2019-12-19T13:17:44+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4373'
permalink: /2019/12/19/update-on-eclipse-iot-packages/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4405";s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4405";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/icon_wp.png
categories:
    - Development
    - IoT
tags:
    - Eclipse
    - IoT
---

A lot has happened, since [I wrote last about the Eclipse IoT Packages project](https://dentrassi.de/2019/09/10/from-building-blocks-to-iot-solutions/). We had some great discussions at [EclipseCon Europe](https://www.eclipsecon.org/europe2019), and started to work together online, having new ideas in the progress. Right before the end of the year, I think it is a good time to give an update, and peek a bit into the future.

## Homepage

One of the first things we wanted to get started, was a home for the content we plan on creating. An important piece of the puzzle is to explain to people, what we have in mind. Not only for people that want to try out the various Eclipse IoT projects, but also to possible contributors. And in the end, an important goal of the project is to attract interested parties. For consuming our ideas, or growing them even further.

<div class="wp-block-image"><figure class="aligncenter is-resized">![Eclipse IoT Packages logo](https://dentrassi.de/wp-content/uploads/logo.svg)</figure></div>So we now have a logo, [a homepage](https://www.eclipse.org/packages/), built using using templates in a continuous build system. We are in a position to start focusing on the actual content, and on the more tricky tasks and questions ahead. And should you want to create a PR for the homepage, you are more than welcome. There is also already some content, explaining the main goals, the way we want to move forward, and demo of a first package: “Package Zero”.

## Community

While the homepage is a good entry point for people to learn about Eclipse IoT and packages, [our GitHub repository](https://github.com/eclipse/packages/) is the home for the community. And having some great discussions on GitHub, quickly brought up the need for [a community call](https://github.com/eclipse/packages/issues/4) and [a more direct communication channel](https://github.com/eclipse/packages/issues/6).

If you are interested in the project, come and join [our bi-weekly community call](https://www.eclipse.org/packages/contribute/#join-the-community-call). It is a quick, 30 minutes call at 16:00 CET, and open to everyone. Repeating every two weeks, starting 2019-12-02.

The URL to the call is: <https://eclipse.zoom.us/j/317801130>. You can also subscribe to the [community calendar](https://calendar.google.com/calendar/ical/lu98p1vc1ed4itl7n9qno3oogc%40group.calendar.google.com/public/basic.ics) to get a reminder.

In between calls, we have a chat room [eclipse/packages](https://gitter.im/eclipse/packages) on Gitter.

## Eclipse IoT Helm Chart Repository

One of the earliest discussion we had, was around the question of how and were we want to host the Helm charts. We would prefer not to author them ourselves, but let the projects contribute them. After all, the IoT packages project has the goal of enabling you to install a whole set of Eclipse IoT projects, with only a few commands. So the focus is on the integration, and the expert knowledge required for creating project Helm chart, is in the actual projects.

On the other side, having a one-stop shop, for getting your Eclipse IoT Helm charts, sounds pretty convenient. So why not host our own Helm chart repository?

Thanks to a company called [Kiwigrid](https://github.com/kiwigrid/helm-charts), who contributed a CI pipeline for validating charts, we could easily extend our existing homepage publishing job, to also publish Helm charts. As a first chart, we published the [Eclipse Ditto](https://www.eclipse.org/ditto/) chart. And, as expected with Helm, installing it is as easy as:

<div class="wp-block-columns is-layout-flex wp-container-3 wp-block-columns-is-layout-flex"><div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow"><figure class="wp-block-image size-large">[![](https://dentrassi.de/wp-content/uploads/h1-1024x427.png)](https://dentrassi.de/wp-content/uploads/h1.png)</figure></div><div class="wp-block-column is-layout-flow wp-block-column-is-layout-flow"><figure class="wp-block-image size-large">[![](https://dentrassi.de/wp-content/uploads/h2-1024x427.png)](https://dentrassi.de/wp-content/uploads/h2.png)</figure></div></div>Of course having a single chart is only the first step. Publishing a single Helm charts isn’t that impressive. But getting an agreement on the community, getting the validation and publishing pipeline set up, attracting new contributors, that is definitely a big step in the right direction.

## Outlook

I think that we now have a good foundation, for moving forward. We have a place called “home”, for documentation, code and community. And it looks like we have also been able to attract more people to the project.

While our first package, “Package Zero”, still isn’t complete, it should be pretty close. Creating a first, joint deployment of Hono and Ditto is our immediate focus. And we will continue to work towards a first release of “Package Zero”. Finding a better name is still an item on the list.

Having this foundation in place also means, that the time is right, for you to think about contributing your own Eclipse IoT Package. Contributions are always welcome.