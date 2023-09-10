---
id: 958
title: 'Remote managing Eclipse Kura on Apache Karaf with ECF'
date: '2016-12-16T11:39:36+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=958'
permalink: /2016/12/16/remote-managing-eclipse-kura-on-apache-karaf-with-ecf/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:959;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
    - IoT
    - 'Technical Stuff'
tags:
    - ECF
    - Eclipse
    - Karaf
    - Kura
---

To be honest, I had my troubles in the past with the [Eclipse Communication Framework](https://eclipse.org/ecf/) (ECF), not that it is a bad framework, but whatever I started it was complicated and never really worked for me. This story is different!

<!-- more -->

A few months back the [Eclipse Kura](http://eclipse.org/kura) project ran into an issue that the plugin which was being used for remote managing a Kura instance (mToolkit) from an IDE just kind of went away ([issue #496](https://github.com/eclipse/kura/issues/496)). There is some workaround for that now, but still the problems around mToolkit still exists. Beside the fact that it is no longer maintained, it is also rather buggy. Deploying a single bundle takes about a minute for me. Of course using the [Apache File Install package for Kura](https://dentrassi.de/kura-addons/#apache-file-install) would also help here ;-)

But having a decent IDE integration would also be awesome. So when [Scott Lewis](http://www.composent.com/) from the ECF project contacted me about that, I was ready to give it a try. Unfortunately the whole setup required more than Kura could handle at that time. But now we do have support for Java 8 in Kura and there also is some basic support for running Kura on Karaf, including a docker image with the Kura emulator running on Karaf.

So I asked Scott for some help in getting this up and running and the set of instructions was rather short. In the following examples I am assuming your are running RHEL 7, forgive me if you are not ;-)

First we need to spin up a new Kura emulator instance:

```
<pre class="lang:sh decode:true">sudo docker run -ti --net=host ctron/kura:karaf-stable
```

We are mapping all network to the host instance, since we are using another port, which is not configured in the upstream Dockerfile. There is probably another way, but this is just a quick example.

Then, inside the Karaf instance install ECF. We configure it first to use “ecftcp” instead of MQTT. But of course you can also got with MQTT or some other adapter ECF provides:

```
<pre class="highlight:0">
property -p service.exported.configs ecf.generic.server
property -p ecf.generic.server.id ecftcp://localhost:3289/server

feature:repo-add http://download.eclipse.org/rt/ecf/kura.20161206/karaf4-features.xml
feature:install -v ecf-kura-karaf-bundlemgr
```

Now Kura is read to go. Following up in the Eclipse IDE, you will need Neon running on Java 8:

Add the ECF 3.13.3 P2 repository using `http://download.eclipse.org/rt/ecf/3.13.3/site.p2` and install the following components:

- ECF Remote Services SDK
- ECF SDK for Eclipse

Next install the preview components for managing Karaf with ECF. Please note, those components are previews and may or may not be release at some point in the future. Add the following P2 repository: `http://download.eclipse.org/rt/ecf/kura.20161206/eclipseui` and install the following components (disable <q>Group Items by Category</q>):

- Remote Management API
- Remote Management Eclipse Consumer

Now comes the fiddly part, this UI is a work in progress, and you have been warned, but it works:

- Switch to the <q>Remote Services</q> perspective
- Open a new view: Window -&gt; Show View -&gt; Other… – Select <q>Remote OSGi Bundles</q>
- Click one of the green + symbols (choose either MQTT or ECFTCP) and enter the address of your Karaf instance (`localhost` and `3289` for me)

You should already see some information about that target device now. But when you open a new view (as before) named <q>Karaf Features</q> you will also have the ability to tinker around with the Karaf installation.

If you just want to have a quick look, here it is:

<figure aria-describedby="caption-attachment-959" class="wp-caption aligncenter" id="attachment_959" style="width: 750px">[![ECF connecting to Kura on Karaf](https://dentrassi.de/wp-content/uploads/kura_karaf_ecf_1-1024x549.png)](https://dentrassi.de/wp-content/uploads/kura_karaf_ecf_1.png)<figcaption class="wp-caption-text" id="caption-attachment-959">ECF connecting to Kura on Karaf</figcaption></figure>Of course you don’t need to use an IDE for managing Karaf. But having such an integration as an option, is a nice addition. And it shows how powerful a great OSGi setup can be ;-)
