---
id: 4293
title: 'From building blocks to IoT solutions'
date: '2019-09-10T09:07:37+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4293'
permalink: /2019/09/10/from-building-blocks-to-iot-solutions/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"3752";s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"3752";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/eclipse-IoT-light-420x283.png
taxonomies:
  categories:
    - Development
    - IoT
    - 'Technical Stuff'
  tags:
    - Eclipse
    - IoT
extra:
    article_image:
        src: /wp-content/uploads/eclipse-IoT-light.png
        alt: Eclipse IoT
---

The Eclipse IoT ecosystem consists of around 40 different projects, ranging from embedded devices, to IoT gateways and up to cloud scale solutions. Many of those projects stand alone as “building blocks”, rather than ready to run solutions. And there is a good reason for that: you can take these building blocks, and incorporate them into your own solution, rather than adopting a complete, pre-built solution.

<!-- more -->

This approach however comes with a downside. Most people will understand the purpose of building blocks, like “[Paho](https://www.eclipse.org/paho/)” (an MQTT protocol library) and “[Milo](https://github.com/eclipse/milo)” (an [OPC UA protocol library](https://dentrassi.de/2019/07/06/eclipse-milo-0-3-updated-examples/)) and can easily integrate them into their solution. But on the cloud side of things, building blocks become much more complex to integrate, and harder to understand.

Of course, the “getting started” experience is extremely important. You can simply [download an Eclipse IDE package](https://www.eclipse.org/downloads/packages/), tailored towards your context (Java, Modelling, Rust, …), and are up and running within minutes. We don’t want you to design your deployment descriptors first, and then let you figure out how to start up your distributed cluster. Otherwise “getting started” will become a week long task. And a rather frustrating one.

## Getting started. Quickly!

<div class="float-start">

[![Eclipse IoT building blocks](https://dentrassi.de/wp-content/uploads/Selection_583-300x236.png)](https://dentrassi.de/2019/02/20/integrating-eclipse-iot/)

</div>

During the [Eclipse IoT face-to-face meeting in Berlin](https://www.eclipse.org/lists/iot-wg/msg01495.html), early this year, the Eclipse IoT working group discussed various ideas. How can we enable interested parties to get started, with as little effort as possible. And still, give you full control. Not only with a single component, which doesn’t provide much benefit on its own. But get you started with a complete solution, which solves actual IoT related problems.

The goal was simple. Take an IoT use case, which is easy to understand by IoT related people. And provide some form of deployment, which gets people up and running in less than 15 minutes. With as little as possible external requirements. At best, run everything on your local laptop. Still, create everything in a close-to-production style of deployment. Not something completely stripped down. But use a way of deployment, that you could actually use as a basis for extending it further.

## Kubernetes &amp; Helm

We quickly agreed on [Kubernetes](https://kubernetes.io/) as the runtime platform, and [Helm](https://helm.sh/) as the way to perform the actual deployments. With Kubernetes being available even on a local machine (using [minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) on Linux, Windows and Mac) and being available, at the same time, in several enterprise ready environments, it seemed like an ideal choice. Helm charts seemed like an ideal choice as well. Helm designed directly for Kubernetes. And it also allows you to generate YAML files, from the Helm charts. So that the deployment only requires you to deploy a bunch of YAML files. Maintaining the charts, is still way easier than directly authoring YAML files.

## Challenges, moving towards an IoT solution

<div class="float-end">

![](https://dentrassi.de/wp-content/uploads/logo_stack_proper_200px.png)

</div>

A much tougher question was: how do we structure this, from a project perspective. During the meeting, it soon turned out, there would be two good initial candidates for “stacks” or “groups of projects”, which we would like to create.

It also turned out that we would need some “glue” components for a package like that. Even though it may only be a script here, or a “readme” file there. Some artifacts just don’t fit into either of those projects. And what about “in development” versions of the projects? How can you point people towards a stable deployment, only using a stable (released) group of projects, when scripts and readme’s are spread all over the place, in different branches.

A combination<mark class="annotation-text annotation-text-yoast" id="annotation-text-789d9cb0-a34d-4a6b-962f-7411b212884b"></mark><mark class="annotation-text annotation-text-yoast" id="annotation-text-789d9cb0-a34d-4a6b-962f-7411b212884b"></mark><mark class="annotation-text annotation-text-yoast" id="annotation-text-0d66c531-3ad2-4ebf-a49c-2a3b362cb3b9"></mark> of “[Hono](https://www.eclipse.org/hono/), [Ditto](https://www.eclipse.org/ditto/) &amp; [Hawkbit](https://www.eclipse.org/hawkbit/)” seemed like an ideal IoT solution to start with. People from various companies already work across those three projects, using them in combination for their own purpose. So, why not build on that?

But in addition to all those technical challenges, the governance of this effort is an aspect to consider. We did not want to exclude other Eclipse IoT projects, simply by starting out with “Hono, Ditto, and Hawkbit”. We only wanted to create “an” Eclipse IoT solution, and not “the” Eclipse IoT solution. The whole Eclipse IoT ecosystem is much too diverse, to force our initial idea on everyone else. So what if someone comes up with an additional group of Eclipse IoT projects? Or what if someone would like to add a new project to an existing deployment?

## A home for everyone

Luckily, creating an Eclipse Foundation project solves all those issues. And the [Eclipse Packaging project](https://projects.eclipse.org/projects/technology.packaging) already proves that this approach works. We played with the idea, to create some kind of a “meta” project. Not a real project in the sense of having a huge code base. But more a project, which makes use of the Eclipse Foundations governance framework. Allowing multiple, even competing companies, to work upstream in a joint effort. And giving all the bits and pieces, which are specific to the integration of the projects, a dedicated home.

A home, not only for the package of “Hono, Ditto and Hawkbit”, but hopefully for other packages as well. If other projects would like to present their IoT solution, by combining multiple Eclipse IoT projects, this is their chance. You can easily become a contributor to this new project, and publish your scripts, documentation and walk-throughs, alongside the other packages.

Of course everything will be open source, licensed under the EPL. So go ahead and fork it, add your custom application on top of it. Or replace an existing component with something, you think is even better than what we put it. We want to enable you to deploy what we provide in a few minutes. Offer you an explanation, what to expect from it, and what this IoT solution can do for you. And encourage you to play around with it. And enable you to extend it, and build something bigger.

## Let’s get started

<div class="float-end">

[![EclipseCon Europe 2019](https://dentrassi.de/wp-content/uploads/https___www.eclipsecon.org_sites_default_files_ECE_only_round_200x200.png.png)](https://www.eclipsecon.org/europe2019)

</div>

We created a new project [proposal for the Eclipse IoT packages](https://projects.eclipse.org/proposals/eclipse-iot-packages) project. The project is currently in the community review phase. Once we pass the creation review, we will start publishing the content for the first package we have.

The Eclipse IoT working group will also meet at the [IoT community day](https://www.eclipsecon.org/europe2019/eclipse-community-day) of [EclipseCon Europe 2019](https://www.eclipsecon.org/europe2019). Our goal is to present an initial version of the initial package. Ready to run!

But even more important, we would like to continue our discussions around this effort. All contributions are welcome: code, documentation, additional packages … your ideas, thoughts, and feedback!
