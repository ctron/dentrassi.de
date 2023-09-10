---
id: 3622
title: 'Just a bit of Apache Camel'
date: '2017-07-03T15:25:45+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3622'
permalink: /2017/07/03/just-a-bit-of-apache-camel/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Camel
    - Eclipse
    - IoT
    - Kura
---

Sometimes you write something and then you nearly forget that you did it … although it is quite handy sometimes, here are a few lines of Apache Camel XML running in Eclipse Kura:

<!-- more -->

I just wanted to publish some random data from [Kura](https://eclipse.org/kura) to [Kapua](https://eclipse.org/kapua), without the need to code, deploy or build anything. Camel came to the rescue:

```
<pre class="lang:xhtml mark:5 decode:true "><routes xmlns="http://camel.apache.org/schema/spring">
  <route id="route1">

    <from uri="timer:1"/>
    <setBody><simple>${bean:payloadFactory.create("value", ${random(100)})}</simple></setBody>
    <to uri="kura-cloud:myapp/topic"/>

  </route>
</routes>
```

Dropping this snippet into the default XML Camel router:

- Registers a Kura application named `myapp`
- Creates a random number between 0 and 100 every second
- Converts this to the Kura Payload structure
- And publishes it on the topic `topic`
