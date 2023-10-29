---
id: 3540
title: 'IEC 60870-5-104 with Apache Camel'
date: '2017-02-17T10:10:23+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3540'
permalink: /2017/02/17/iec-60870-5-104-with-apache-camel/
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
    - IEC
    - IEC 60870
    - IIoT
    - IoT
---

Yesterday the release 0.4.0 of Eclipse NeoSCADA™ was made available. This release features a cool new feature, an IEC 60870-5-104 stack, written in Java, licensed under the EPL and available on Maven Central. See also the Eclipse Wiki: <https://wiki.eclipse.org/EclipseNeoSCADA/Components/IEC60870>

<!-- more -->

So it was time to update my Apache Camel component for IEC 60870 and finally release it to Maven Central with proper dependencies on Eclipse NeoSCADA 0.4.0.

For more information about the see my page about the [IEC 60870 Apache Camel component](/camel-iec60870).

In a nutshell you can install it with the following commands into a running Karaf container and start using it with Apache Camel:

```
feature:repo-add mvn:org.apache.camel.karaf/apache-camel/2.18.0/xml/features
feature:repo-add mvn:de.dentrassi.camel.iec60870/feature/0.1.1/xml/features
feature:install camel-iec60870
```

But of course it can also be used outside of OSGi. In a standalone Java application or in the various other ways you can use Apache Camel.
