---
id: 854
title: 'Collecting data to OpenTSDB with Apache Camel'
date: '2016-09-09T15:12:35+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=854'
permalink: /2016/09/09/collecting-data-to-opentsdb-with-apache-camel/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Camel
    - IoT
    - OpenTSDB
---

[OpenTSDB](http://opentsdb.net/) is an open source, scalable, &lt;buzzword&gt;big data&lt;/buzzword&gt; solution for storing time series data. Well, that what the name of the project actually says ;-) In combination with [Grafana](http://grafana.org/) you can pretty easy build a few nice dashboards for visualizing that data. The only question is of course, how do you get your data into that system.

<!-- more -->

My intention was to provide a simple way to stream metrics into OpenTSDB using [Apache Camel](http://camel.apache.org/). A quick search did not bring up any existing solutions for pushing data from Apache Camel to OpenTSDB, so I decided to write a small Camel component which can pick up data and send this to OpenTSDB using the HTTP API. Of course having a plain OpenTSDB HTTP Collector API for that would be fine as well. So I did split up the component into three different modules. A generic OpenTSDB collector API, an HTTP implementation of that and finally the Apache Camel component.

All components are already available in Maven Central, and although they have the version number 0.0.3, they are working quite well ;-)

\[code language=”xml”\]  
&lt;dependency&gt;  
 &lt;groupId&gt;de.dentrassi.iot&lt;/groupId&gt;  
 &lt;artifactId&gt;de.dentrassi.iot.opentsdb.collector&lt;/artifactId&gt;  
 &lt;version&gt;0.0.3&lt;/version&gt;  
&lt;/dependency&gt;  
&lt;dependency&gt;  
 &lt;groupId&gt;de.dentrassi.iot&lt;/groupId&gt;  
 &lt;artifactId&gt;de.dentrassi.iot.opentsdb.collector.http&lt;/artifactId&gt;  
 &lt;version&gt;0.0.3&lt;/version&gt;  
&lt;/dependency&gt;  
&lt;dependency&gt;  
 &lt;groupId&gt;de.dentrassi.iot&lt;/groupId&gt;  
 &lt;artifactId&gt;de.dentrassi.iot.opentsdb.collector.camel&lt;/artifactId&gt;  
 &lt;version&gt;0.0.3&lt;/version&gt;  
&lt;/dependency&gt;  
\[/code\]

Dropping those dependencies into your classpath, or into your OSGi container ;-), you can use the following code to easily push data coming from MQTT directly into OpenTSDB:

\[code language=”java”\]  
CamelContext context = new DefaultCamelContext();

// add routes

context.addRoutes(new RouteBuilder() {

@Override  
public void configure() throws Exception {  
 from("paho:sensors/test2/temperature?brokerUrl=tcp://iot.eclipse.org")  
 .log("${body}")  
 .convertBodyTo(String.class).convertBodyTo(Float.class)  
 .to("open-tsdb:http://localhost:4242#test2/value=temp");

 from("paho:tele/devices/TEMP?brokerUrl=tcp://iot.eclipse.org")  
 .log("${body}")  
 .convertBodyTo(String.class).convertBodyTo(Float.class)  
 .to("open-tsdb:http://localhost:4242#test3/value=temp");  
 }  
});

// start the context  
context.start();  
\[/code\]

You can directly push Floats or Integers into OpenTSDB. The example above shows a “to” component which does directly address a metric. Using `#test3/value=temp` If you need more tags, then those can be added using `#test3/value=temp/foo=bar`.

But it is also possible to have a generic endpoint and provide the metric information in the actual payload. In this case you have to use the type `<a href="https://dentrassi.de/iot/de.dentrassi.iot.opentsdb.collector/apidocs/de/dentrassi/iot/opentsdb/collector/Data.html" target="_blank">de.dentrassi.iot.opentsdb.collector.Data</a>` and fill in the necessary information. It is also possible to publish an array of `Data[]`.
