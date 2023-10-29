---
id: 4107
title: 'Integrating Eclipse IoT'
date: '2019-02-20T13:28:51+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4107'
permalink: /2019/02/20/integrating-eclipse-iot/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4121";s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4121";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/Selection_583.png
taxonomies:
  categories:
    - IoT
    - 'Technical Stuff'
  tags:
    - Eclipse
    - IoT
---

The Eclipse IoT project is a top level project at the Eclipse Foundation. It currently consists of around 40 projects, which focus on different aspects of IoT. This may either be complete solutions, like the [Eclipse SmartHome](https://www.eclipse.org/smarthome/) project, the PLC runtime and IDE, [Eclipse 4DIAC](https://www.eclipse.org/4diac/). Or it may be building block projects, like the MQTT libraries of [Eclipse Paho](https://www.eclipse.org/paho/), or the cloud scale IoT messaging infrastructure of [Eclipse Hono](https://www.eclipse.org/hono/). I can only encourage you to have a look at the [list of projects](https://iot.eclipse.org/projects/) and do a bit of exploring.

And while it is great to a have a diverse set of projects, covering [the three tiers of IoT ](https://iot.eclipse.org/white-papers/iot-architectures/)(Device, Gateway and Cloud), it can be a challenge to explain people, how all of those projects can create something, which is bigger than the individual projects. Because having 40 different IoT projects is great, but imagine the possibilities of having a whole IoT ecosystem of projects. Mixing and matching, building your IoT solution as you see fit.

<!-- more -->

### IoT means different things to different people

Everyone sees something different in the “Internet of Things”. Looking at the introduction on Wikipedia, you may understand why:

> The Internet of things (IoT) is the network of devices such as vehicles, and home appliances that contain electronics, software, sensors, actuators, and connectivity which allows these things to connect, interact and exchange data
> 
> <cite>Wikipedia – “Internet of Things”</cite>

While it is absolutely valid, it is also rather vague and covers quite a few use cases. This is also being reflected by the different projects of Eclipse IoT. Different projects cover different areas, sometimes they overlap, but sometimes they don’t. Sometimes to follow similar principles, and sometimes they don’t. Most people are caught up in their daily work, contributing to the projects you focus on. But it might be beneficial for everyone, to look a bit over the fence and try to establish a common ground, creating a more integrated Eclipse IoT experience

### Let’s draw a map

One of the biggest problems, and not only when you are a newcomer to Eclipse IoT, is to understand what is already there, and how it works together. Because, yes it does work together! Finding out “how” can however be challenging. Many projects already have some kind of documentation on how to set up project X with project Y. In most cases such information stored in the project’s Git repository, some blog post or only lives in a forum or mailing list.

So we tried to find a format on how to bring this all together, and also motivate projects to actively contribute to that format. A single person cannot know and understand how all those different projects work together, but the committers on each project know their projects and existing integration points best. And they can also easily point you to the necessary documentation. The result, that resonated quite well with people is a simple, interactive map of the integrated projects:

<figure>

[![](https://dentrassi.de/wp-content/uploads/Selection_583.png)](https://ctron.github.io/eclipse-iot-integration-map/)

<figcaption>Eclipse IoT integration map – <a href="https://ctron.github.io/eclipse-iot-integration-map/">https://ctron.github.io/eclipse-iot-integration-map/</a></figcaption></figure>

This map represents a condensed view on the current state of [Eclipse IoT integration](https://ctron.github.io/eclipse-iot-integration-map/), to the best of my knowledge. But please fix that latter part, by using the “[Fork me!](https://github.com/ctron/eclipse-iot-integration-map)” button. Adding a new project to that map is only one pull request away. And if you are new to Eclipse IoT, then go ahead and explore the map.

### Get started quickly

Getting started still is hard. Yes, most projects do have some kind of “quick start” tutorial, which gets you started within a few minutes. However, the more components and projects you add, the more complex and time consuming it gets. Mostly because you need to figure out the integration part yourself:

> Getting us started with Eclipse IoT took us four months. On the other hand we don’t want to reinvent the wheel, especially when it comes to a complex piece of infrastructure like an IoT platform. Our target market requires being able to run on-premise, ruling out the majority of IoT platforms offered in the cloud. Using and actively participating in an open source IoT platform and exposing open API’s to our customers for integrating the IoT platform aligns perfectly with our vision.
> 
> <cite>Bob Claerhout – [Aloxy](http://www.aloxy.io/)</cite>

I was really glad that I joined the [bi-weekly Eclipse IoT community call](https://wiki.eclipse.org/IoT/M2MIWG/Weekly_call_minutes) that day. Because hearing that feedback, from someone who just started to look into the ecosystem, confirmed two things: Eclipse IoT can be a pretty valuable asset for the IoT solution you are building. But I think we should make it way easier to consume those projects, or at least to get people started quicker. Just a little bit later, a first, small PR from Bob landed in the Eclipse Hono project, proving that the open source approach works just fine.

But not everyone is that persistent and keeps trying that hard. What we need is good starting point, a super-opinionated deployment. Showing the basics of each of the projects, in some kind of integrated deployment. You will never take this out into production, but it should help you to get started, and allow you to explore what is already there. See how it works, let you play around with a running instance of the components you chose to deploy.

### We are close

And actually we are pretty close to that target. It just needs a bit of polish, and we have a nice starting point. Over the last year or so, we have built a kind of “example”, “demo setup”, whatever you will call it. It all started with a simple deployment of Eclipe Hono, including an IoT gateway simulator and a “Demo Gauge”, which acts as a web frontend, showing the simulated data in a web browser.

Over the time we extended this and now have an example of telemetry data ingestion, using [Eclipse Kura](https://www.eclipse.org/kura/) as an IoT gateway, connecting to [Eclipse Hono](https://eclipse.org/hono/) and [EnMasse](http://enmasse.io/) as the IoT messaging layer. Pushing data via [Apache Camel](https://camel.apache.org/) to [Apache Kafka](https://kafka.apache.org/), and then running the “[Demo Gauge](https://github.com/ctron/hono-example-demo-gauge)” application to show the data. Alongside we deploy [Eclipse Che](https://www.eclipse.org/che/), to show how you can start developing on the same cloud infrastructure that the IoT stack is deployed to. All of that is running on Kubernetes based [OKD](https://www.okd.io/), using a source-to-image, devops style deployment model.

Like the integration map, it is right here on GitHub: <https://github.com/redhat-iot/iot-cloud-stack-ece2018>. A hand full of people already contributes to that effort over time. But, compared to the integration map, this “Tutorial” repository needs a bit of cleanup. And instead of running through it sequentially, it might be better to approach this from a feature based perspective. Deploying a core infrastructure, and then allowing for a few choices, of what you would like to deploy in addition.

### Gathering recipes

So let’s simply start with a fresh repository. Name it “[Eclipse IoT recipes](https://github.com/ctron/eclipse-iot-recipes)“, for the time being, and re-organize the content a little bit: <https://github.com/ctron/eclipse-iot-recipes> … that wasn’t too difficult :-)

The goal should be, that within a few hours, you have a system up and running. A system which allows you to play at least with the basics. And everyone who would like to add something, can easily do that with a PR. And “adding” might also be to provide an alternative path. Replace the IoT gateway, replace the messaging layer, … whatever you have in mind.

I still think it is helpful to have some manual steps, with a little bit of explanation, rather than a fully automated script. From my experience, you learn a lot more when you do things yourself, rather than watching a script doing things for you.

### Play with it … and contribute!

Now it is up to you, to test this, play with it, and contribute. Provide feedback, make suggestions, or fork it and turn it upside down.

Or just explore what Eclipse IoT has to offer.
