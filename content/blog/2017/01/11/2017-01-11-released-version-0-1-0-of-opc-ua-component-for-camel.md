---
id: 3481
title: 'Released version 0.1.0 of OPC UA component for Camel'
date: '2017-01-11T15:55:03+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3481'
permalink: /2017/01/11/released-version-0-1-0-of-opc-ua-component-for-camel/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3496;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - IoT
    - Java
    - Milo
    - 'OPC UA'
---

After [Eclipse Milo™](http://eclipse.org/milo) 0.1.0 was released a few days back and is available on [Maven Central](https://search.maven.org/#search|ga|1|g%3A%22org.eclipse.milo%22) since this week it was time to update my [OPC UA component for Apache Camel](https://dentrassi.de/camel-milo/) to use the release version of Milo:

<!-- more -->

> Finally! :-) [@Eclipse](https://twitter.com/eclipse) [\#Milo](https://twitter.com/hashtag/Milo?src=hash) 0.1.0 is released and on Maven Central! Super Awesome!! [@kevinherron](https://twitter.com/kevinherron) [@EclipseIoT](https://twitter.com/EclipseIoT) <https://t.co/nRdSx66B34>
> 
> — Jens Reimann (@ctron) [January 10, 2017](https://twitter.com/ctron/status/818863065630384128)

<script async="" charset="utf-8" src="//platform.twitter.com/widgets.js"></script>

This means that there is now a released version of, available on Maven Central as well, of the Apache Camel Milo component which can either be used standalone or dropped in directly to some OSGi container like [Apache Karaf](<http://Apache Karaf>).

#### The basics

The component is available from Maven Central under the group ID [de.dentrassi.camel.milo](https://search.maven.org/#search|ga|1|g%3A%22de.dentrassi.camel.milo%22) and the source code is available on GitHub: [ctron/de.dentrassi.camel.milo](https://github.com/ctron/de.dentrassi.camel.milo)

For more details also see: [Apache Camel component for OPC UA](https://dentrassi.de/camel-milo/)

If you want to use is as a dependency use:

```
<pre class="lang:xml">
<dependency>
  <groupid>de.dentrassi.camel.milo</groupid>
  <artifactid>camel-milo</artifactid>
  <version>0.1.0</version>
</dependency>
```

Or for the Apache Karaf feature:

```
<pre class="highlight:0">mvn:de.dentrassi.camel.milo/feature/0.1.0/xml/features
```

#### Plain Java

If you want to have a quick example you can clone the GitHub repository and simply compile and run an example using the following commands:

```
<pre class="highlight:0">git clone https://github.com/ctron/de.dentrassi.camel.milo
cd de.dentrassi.camel.milo/examples/milo-example1
mvn camel:run
```

This will compile and run a simple example which transfers all temperate measurements from the `iot.eclipse.org` MQTT server from the topic `javaonedemo/eclipse-greenhouse-9home/sensors/temperature` to the OPC UA tag `item-GreenHouse.Temperature`, namespace `urn:org:apache:camel` on the connection `opc.tcp://localhost:12685`.

The project is a simple OSGi Blueprint bundle which can be also be run by Apache Camel directly. The only configuration is the blueprint file:

```
<pre class="lang:xml mark:3-5,12 decode:true "><blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0">

    <bean id="milo-server" class="org.apache.camel.component.milo.server.MiloServerComponent">
        <property name="enableAnonymousAuthentication" value="true"/>
    </bean>

    <camelContext xmlns="http://camel.apache.org/schema/blueprint">
      <route id="milo1">
        <from uri="paho:javaonedemo/eclipse-greenhouse-9home/sensors/temperature?brokerUrl=tcp://iot.eclipse.org:1883"/>
        <convertBodyTo type="java.lang.String"/>
        <log message="iot.eclipse.org - temperature: ${body}"/>
        <to uri="milo-server:GreenHouse.Temperature"/>
      </route>
    </camelContext>

</blueprint>
```

This configures a Camel Milo server component and routes the data from MQTT to OPC UA.

#### Apache Karaf

If you compile the previous example using:

```
<pre class="highlight:0">mvn package
```

You can download and start an Apache Karaf instance, add the Camel Milo component as a feature and deploy the bundle:

```
<pre class="highlight:0">
feature:repo-add mvn:de.dentrassi.camel.milo/feature/0.1.0/xml/features
feature:repo-add mvn:org.apache.camel.karaf/apache-camel/2.18.0/xml/features
feature:install aries-blueprint shell-compat camel camel-blueprint camel-paho camel-milo
```

The next step will download and install the example bundle. If you did compile this yourself, then use the  
path of your locally compiled JAR. Otherwise you can also use a pre-compiled example bundle:

```
<pre class="highlight:0">
bundle:install -s https://dentrassi.de/download/camel-milo/milo-example1-0.1.0-SNAPSHOT.jar
```

To check if it works you can cannot using an OPC UA client or peek into the log file of Karaf:

```
<pre class="highlight:0">karaf> log:tail
2017-01-11 15:11:45,348 | INFO  | -930541343163004 | milo1  | 146 - org.apache.camel.camel-core - 2.18.0 | iot.eclipse.org - temperature: 21.19
2017-01-11 15:11:45,958 | INFO  | -930541343163004 | milo1  | 146 - org.apache.camel.camel-core - 2.18.0 | iot.eclipse.org - temperature: 21.09
2017-01-11 15:11:49,648 | INFO  | -930541343163004 | milo1  | 146 - org.apache.camel.camel-core - 2.18.0 | iot.eclipse.org - temperature: 21.19
```

#### FUSE tooling

If you want some more IDE integration you can quickly install the [JBoss FUSE tooling](https://developers.redhat.com/products/fuse/get-started/) and connect via JMX to either the Maven controlled instance (`mvn camel:run`) or the Karaf instance and monitor, debug and trace the active Camel routes:

<figure aria-describedby="caption-attachment-3496" class="wp-caption aligncenter" id="attachment_3496" style="width: 840px">[![FUSE tooling with Milo](https://dentrassi.de/wp-content/uploads/milo_fuse-1024x621.png)](https://dentrassi.de/wp-content/uploads/milo_fuse.png)<figcaption class="wp-caption-text" id="caption-attachment-3496">FUSE tooling with Milo</figcaption></figure>#### What is next?

For one this component will hopefully become part of Apache Camel itself. And of course there is always something to improve ;-)

I also did update the Kura Addon for Milo, which provides the Milo Camel component for Eclipse Kura 2.1.0 which was recently released. This component is now also available on Maven Central and can easily be deployed into Kura. See the [Kura Addons page](https://dentrassi.de/kura-addons/) for more information.

Then there are a few location where I used SNAPSHOT versions of Milo and for some I did promise an update. So I will try to update as many locations as I can with links to the released version of those components.
