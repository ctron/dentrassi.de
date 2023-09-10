---
id: 3639
title: 'Kapua micro client SDK, running on a microcontroller'
date: '2017-08-12T20:23:41+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3639'
permalink: /2017/08/12/kapua-micro-client-sdk-running-on-a-microcontroller/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - disable
fabulous-fluid-featured-image:
    - disable
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3647;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - IoT
    - Java
    - Kapua
---

A few weeks back, while being at [EclipseCon France](https://www.eclipsecon.org/france2017/), I did stumble over a nice little gadget. There was talk from [MicroEJ](http://developer.microej.com/getting-started.html#top_anchor) around Java on microcontrollers. And they where showing an IoT related demo based on their development environment. And it seemed they did have [Eclipse Paho](https://www.eclipse.org/paho/) (including TLS) and [Google Protobuf](https://developers.google.com/protocol-buffers/) running on their JVM without too much troubles.

<!-- more -->

<figure aria-describedby="caption-attachment-3642" class="wp-caption aligncenter" id="attachment_3642" style="width: 840px">[![](https://dentrassi.de/wp-content/uploads/20170802_113849_small-1024x768.jpg)](https://dentrassi.de/wp-content/uploads/20170802_113849_small.jpg)<figcaption class="wp-caption-text" id="caption-attachment-3642">ST Board with Thermocloud</figcaption></figure>My first idea was to simply drop the Kapua Gateway Client SDK on top of it, implementing the cloud facing API of MicroEJ and let their IoT demo publish data towards Kapua.  
After a few days I was able to order such a [STM32F746G-DISCO](http://www.st.com/en/evaluation-tools/32f746gdiscovery.html) board myself and play a little bit around with it. It quickly turned out that is was pretty easy to drop some Java code on the device, using the gateway client SDK was not an option. The MicroEJ JVM is based on Java CDLC 8. Sounds like Java 8, right? Well, it is more like Java 7. Aside from a few classes which are missing, the core features missing where Java 8’s lambdas and enhancements to interfaces (like static methods and default methods).

Rewriting the gateway client SDK in Java 7, dropping the shiny API which we currently have, didn’t sound very appealing. But then again, implementing the Kapua communication stack actually isn’t that complicated and such an embedded device wouldn’t really need the extensibility and modularity of the Java 8 based gateway client SDK. So in a few hours there was the Kapua micro client SDK, which doesn’t consume any dependencies other than Paho and Protobuf and also only uses a minimal set of Java 7 functionality.

The second step was to implement the MicroEJ specific APIs and map the calls to the Kapua micro SDK, which wasn’t too difficult either. So now it is possible to simply install the “[Kapua Data Channel Provider](https://communitystore.microej.com/applications/5971f311bd78b04800bb0f08)” from the MicroEJ Community Store. Alternatively you can compile the sources yourself as the code for this adapter is also on GitHub. Once the data channel provider is installed you can fire up any application consuming the DataChannel API, like the “[Thermocloud](https://communitystore.microej.com/applications/5943d714c38b7a4200d2e74d)” application, and publish data to Kapua. Please be sure to follow the installation instructions on the Kapua data channel provider for configuring the connection to your Kapua instance.

<figure aria-describedby="caption-attachment-3643" class="wp-caption aligncenter" id="attachment_3643" style="width: 840px">[![](https://dentrassi.de/wp-content/uploads/20170802_131244_small-1024x702.jpg)](https://dentrassi.de/wp-content/uploads/20170802_131244_small.jpg)<figcaption class="wp-caption-text" id="caption-attachment-3643">Kapua Data Channel Provider</figcaption></figure><figure aria-describedby="caption-attachment-3647" class="wp-caption aligncenter" id="attachment_3647" style="width: 840px">[![](https://dentrassi.de/wp-content/uploads/kapua-micro-1024x621.png)](https://dentrassi.de/wp-content/uploads/kapua-micro.png)<figcaption class="wp-caption-text" id="caption-attachment-3647">Data from Thermocloud in Kapua</figcaption></figure>As the micro client is capable of running on Java 7, it might also be a choice for people wanting to connect from Android to Kapua without the need to go for Java 8. As Java 8 on Android still seems to be rather painful, this could be an option.

Also see:

- [ctron/kapua-micro-client](https://github.com/ctron/kapua-micro-client)
- [Kapua Micro Client](https://ctron.github.io/kapua-micro-client)
- [Kapua Gateway Client SDK](https://github.com/eclipse/kapua/tree/develop/client/gateway)
- [ctron/kapua-ej-data-channel](https://github.com/ctron/kapua-ej-data-channel)

I would like to thank Laurent and Frédéric from MicroEJ, who did help me fix all the noob-issues I had.
