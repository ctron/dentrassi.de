---
id: 836
title: 'Bringing OPC UA to Apache Camel'
date: '2016-07-18T10:22:09+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=836'
permalink: /2016/07/18/bringing-opc-ua-to-apache-camel/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
    - IoT
    - 'Technical Stuff'
  tags:
    - Apache
    - Camel
    - Eclipse
    - IoT
    - Milo
    - 'OPC UA'
---

My first two weeks at Red Hat have been quite awesome! There is a lot to learn and one the first things I checked out was [Apache Camel](http://camel.apache.org/) and [Eclipse Milo](http://eclipse.org/milo). While Camel is more known open source project, Eclipse Milo is a newcomer project at the Eclipse Foundation. And while it is officially still in the Incubation Phase, it is a tool you can really work with! Eclipse Milo is an [OPC UA](https://opcfoundation.org/about/opc-technologies/opc-ua/) client and server implementation.

<!-- more -->

### Overview

Although Apache Camel already has an [OPC DA connector](https://github.com/summitsystemsinc/camel-opc), based on [OpenSCADA’s Utgard](http://openscada.org/projects/utgard/) library (sorry, but I couldn’t resist ;-) ), OPC UA is a complete different thing. OPC DA remote connectivity is based on DCOM and has always been really painful. That’s also the reason for the name: Utgard. But with OPC UA that has been cleared up. It features different communication layers, the most prominent, up until now, is the custom, TCP based binary protocol.

I started by investigating the way Camel works and dug a little bit in the API of Eclipse Milo. From an API perspective, both tools couldn’t be more different. Where Camel does try to focus on simplicity and reducing the full complexity down to a very slim and simple interface, Milo simply unleashes the full complexity of OPC UA into a very nice, but complex, Java 8 style API. Now you can argue night and day what is the better approach, with a little bit of glue code, both sides work perfectly together.

To make it short, the final result is an open source project on GitHub: [ctron/de.dentrassi.camel.milo](https://github.com/ctron/de.dentrassi.camel.milo), which features two Camel components providing OPC UA client and OPC UA server support. Meaning that it is possible now to consume or publish OPC UA value updates by simply configuring a Camel URI.

### Examples

For example:

```
milo-client:tcp://foo:bar@localhost:12685?nodeId=items-MyItem&namespaceUri=urn:org:apache:camel
```

Can be used to configure an OPC UA Client connection to “localhost:12685”. Implementing both Camel producer and consumer, it is possible to subscribe/monitor this item or write value updates.

The following URI does create a server item named “MyItem”:

```
milo-server:MyItem
```

Which can then be accessed using an OPC UA client. For the server component the configuration options like bind address and port are located on the Camel component, not the endpoint. However it is possible with Camel to register the same component type with different configurations.

Also see the [testing classes](https://github.com/ctron/de.dentrassi.camel.milo/tree/master/src/test/java/org/apache/camel/component/milo/testing), which show a few examples.

### What is next?

With help from [@hekonsek](https://github.com/hekonsek), who knows a lot more about Camel than I do, we hope to contribute this extension to the Apache Camel project. So once Eclipse Milo has it’s first release, this could become an “out-of-the-box” experience when using Apache Camel, thanks to another wonderful project of [Eclipse IoT](http://iot.eclipse.org/) of course ;-)

Also, with a little bit of luck, there will be [a talk at EclipseCon Europe 2016](https://www.eclipsecon.org/europe2016/session/bringing-opc-ua-apache-camel-and-eclipse-kura) about this adventure. It will even go a bit further because I do want to bring this module into Eclipse Kura, so that Eclipse Kura will feature OPC UA support using Apache Camel.
