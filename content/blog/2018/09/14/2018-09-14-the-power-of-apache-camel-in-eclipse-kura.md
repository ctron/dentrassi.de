---
id: 3969
title: 'Leveraging the power of Apache Camel in Eclipse Kura'
date: '2018-09-14T15:52:25+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3969'
permalink: /2018/09/14/the-power-of-apache-camel-in-eclipse-kura/
inline_featured_image:
    - '0'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3999;s:11:"_thumb_type";s:10:"attachment";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3999;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Apache
    - Camel
    - Eclipse
    - IoT
    - Kura
---

With the upcoming version of [Eclipse Kura](https://eclipse.org/kura) 4, we will see some nice new features for the embedded [Apache Camel](https://camel.apache.org) runtime. This tutorial walks you through the Camel integration of Kura wires, which allows you to bridge both technologies, and leverage the power of Apache Camel for your solutions on the IoT gateway.

<!-- more -->

Kura Wires is a graph-oriented programming model of Eclipse Kura. It allows wiring up different components, like a Modbus client to the internal Kura Cloud Service. It is similar to [Node-RED](https://nodered.org/).

Apache Camel is a message-oriented integration platform with a rule-based routing approach. It has a huge eco-system of components, allowing to integrate numerous messaging endpoints, data formats, and scripting languages.

A graphical approach, like Kura Wires may be interesting for a single instance, which is manually administered. But assume that you want to re-deploy the same solution multiple times. In this case you would want to locally develop and test it. Have proper tooling like validation and debugging. And then you want to automatically package it and run a set of unit and integration tests. And only after that you would want to deploy this. This model is supported when you are using Apache Camel. There is a lot of tooling available, tutorials, training, books on how to work with Apache Camel. And you can make use of the over 100 components which Camel itself provides. In addition to that, you have a whole ecosystem around Apache Camel, which can extend this even more. So it is definitely worth a look.

## Prerequisites

As a prerequisite, you will need an instance of Kura 4. As this is currently not yet released, you can also use a snapshot build of Kura 3.3, which will later become Kura 4.

If you don’t want to set up a dedicated device just for playing around, you can always use the Kura container image and it e.g. with Docker. There is a short introduction on how to get started with this at the DockerHub repository: <https://hub.docker.com/r/ctron/kura/>

Starting a new Kura instance is as easy as:

```
docker run -ti ctron/kura:develop -p 8080:8080
```

The following tutorial assumes that you have already set up Kura, and started with a fresh instance.

## Baby Steps

The first step we take is to create a very simple, empty, Camel Context and hook and directly hook up a Camel endpoint without further configuration.

### New Camel Context

As a first step, we create a new XML Router Camel context:

- Open the Kura Web UI
- Click on the “+” button next to the services search box
- Select the `org.eclipse.kura.camel.xml.XmlRouterComponent` factory
- Enter the name `camel1`
- Press “Submit”

![New Camel Context Component](https://dentrassi.de/wp-content/uploads/Selection_524.png)

A new service should appear in the left side navigation area. Sometimes it happens that the service does not show up, but reloading the Web UI will reveal the newly created service.

Now select the service and edit the newly created context. Clear out the “Router XML” and only leave the root element:

```
<routes xmlns="http://camel.apache.org/schema/spring">
</routes>

```

In the field “Required Camel Components” add the `stream` component. Click on “Apply” to activate the changes. This will configure the Camel context to have no routes, but wait for the `stream` component to be present in the OSGi runtime. The `stream` component is a default component, provided by the Eclipse Kura Camel runtime. The Camel context should be ready immediately and will be registered as an OSGi service for others to consume.

![](https://dentrassi.de/wp-content/uploads/Selection_525.png)

### The Wires Graph

The next step is to configure the Kura Wires graph:

- Switch to “Wire Graph” in the navigation pane
- Add a new “Timer” component named `timer1`
    - Configure the component to fire every second
- Add a new “Camel Producer” named `producer1`
    - Set the Context ID field of the component to `camel1`
    - Set the endpoint URI to `stream:out`
- Connect the nodes `timer1` and `producer1`
- Click on `Apply` to activate the changes

![](https://dentrassi.de/wp-content/uploads/Selection_526.png)

If you look at the console of the Kura instance, then you should see something like this:

```
org.eclipse.kura.wire.WireEnvelope@bdc823c
org.eclipse.kura.wire.WireEnvelope@5b1f50f4
org.eclipse.kura.wire.WireEnvelope@50851555
org.eclipse.kura.wire.WireEnvelope@34cce95d

```

**Note:** If you are running Kura on an actual device, then the output might be in the file `/var/log/kura-console.log`.

What is happening is, that the Kura wires timer component will trigger a Wires event every second. That event is passed along to the Camel endpoint `stream:out` in the Camel context `camel1`. This isn’t using any Camel routes yet. But this is a basic integration, which allows you to access all available Camel endpoints directly from Kura Wires.

## Producer, Consumer, Processor

In addition to the “Producer” component, it is also possible to use the “Consumer”, or the “Processor”. The Consumer takes events from the Camel context and forwards them to the Kura Wires graph. While the “Processor” takes an event from the Wire Graph, processes it using Camel, and passes along the result to Wires again:

![](https://dentrassi.de/wp-content/uploads/drawing_1.png)  
![](https://dentrassi.de/wp-content/uploads/drawing_2.png)

For Producer and Consumer, this would be a unidirectional message exchange from a Camel point of view. The Processor component would use an “in”/”out” message exchange, which is more like “request/response”. Of course that only makes sense when you have an endpoint which actually hands back a response, like the HTTP client endpoint.

![](https://dentrassi.de/wp-content/uploads/drawing_3.png)

In the following sections, we will see that in most cases there will be a more complex route set up that the Camel Wire component would interact with, proxied by a `seda` Camel component. Still, the “in”, “out” flow of the Camel message exchange would be end-to-end between whatever endpoint you have and the Wires graph.

![](https://dentrassi.de/wp-content/uploads/drawing_4.png)

## Getting professional

Apache Camel mostly uses the concept of routes. And while accessing an endpoint directly from the Kura Camel component technically works, I wouldn’t recommend it. Mainly due to the fact that you would be missing an abstraction layer, there is no way to inject anything between the Kura Wires component and the final destination at the Camel endpoint. You directly hook up Kura Wires with the endpoint and thus lose all ways that Camel allows you to work with your data.

So as a first step, let’s decouple the Camel endpoint from Kura Wires and provide an API for our Camel Context.

In the `camel1` configurations screen, change the “Router XML” to:

```
<routes xmlns="http://camel.apache.org/schema/spring">
    <route>
        <from uri="seda:input1"/>
        <to uri="stream:out"/>
    </route>
</routes>

```

Then configure the `producer1` component in the Wire Graph to use the “Endpoint URI” `seda:input1` instead of directly using `stream:out`.

If everything is right, then you should still see the same output on the Kura console, but now Wires and Camel are decoupled and properly interfaced using an internal event queue, which allows us to use Camel routes for the following steps.

One benefit of this approach also is that you can now take the XML route definitions outside of Kura and test them in your local IDE. There are various IDE extensions for Eclipse, IntelliJ and Visual Studio, which can help to work with Camel XML route definitions. And of course, there are the JBoss Tools as well ;-). So you can easily test the routes outside of a running Kura instance and feed in emulated Kura Wires events using the `seda` endpoints.

## To JSON

This first example already shows a common problem, when working with data, and even so for IoT use cases. The output of `org.eclipse.kura.wire.WireEnvelope@3e0cef10` is definitely not what is of much use. But Camel is great a converting data, so let’s make use of that.

As a first step we need to enable the JSON support for Camel:

- Navigate to “Packages”
- Click on “Install/Upgrade”
- Enter the URL: `https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.gson/0.6.0/de.dentrassi.kura.addons.camel.gson-0.6.0.dp`
- Click on “Submit”

After a while, the package `de.dentrassi.kura.addons.gson` should appear in the list of installed packages. It may happen that the list doesn’t properly refresh. Clicking on “refresh” or reloading the Web page will help.

Instead of downloading the package directly to the Kura installation you can also download the file to your local machine and then upload it by providing the file in the “Install/Upgrade” dialog box.

As a next step, you need to change the “Router XML” of the Camel context `camel1` to the following configuration:

```
<routes xmlns="http://camel.apache.org/schema/spring">
    <route>
        <from uri="seda:input1"/>
        <marshal><json library="Gson"/></marshal>
        <transform><simple>${body}\n</simple></transform>
        <to uri="stream:out"/>
    </route>
</routes>

```

In the Kura console you will now see that we successfully transformed the internal Kura Wires data format to simple JSON:

```
{"value":[{"properties":{"TIMER":{}}}],"identification":"org.eclipse.kura.wire.Timer-1536913933101-5","scope":"WIRES"}

```

This change did intercept the internal Kura wires objects and serialized them into proper JSON structures. The following step simply appends the content with a “newline” character in order to have a more readable output on the command line.

## Transforming data

Depending on your IoT use case, transforming data can become rather complex. Camel is good at handling this. Transforming, filtering, splitting, aggregating, … for this tutorial I want to stick to a rather simple example, in order to focus in the integration between Kura and Camel, and less on the powers of Camel itself.

As the next step will use the “Groovy” script language to transform data, we will need to install an additional package using the same way as before: `https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.groovy/0.6.0/de.dentrassi.kura.addons.camel.groovy-0.6.0.dp`

Then go ahead and modify the “Router XML” to include a transformation step, add the following content before the JSON conversion:

```
<transform><groovy>
return  ["value": new Random().nextInt(10), "timer": request.body.identification ];
</groovy></transform>

```

The full XML context should now be:

```
<routes xmlns="http://camel.apache.org/schema/spring">
    <route>
        <from uri="seda:input1"/>
        <transform><groovy>
        return  ["value": new Random().nextInt(10), "timer": request.body.identification ];
        </groovy></transform>
        <marshal><json library="Gson"/></marshal>
        <transform><simple>${body}\n</simple></transform>
        <to uri="stream:out"/>
    </route>
</routes>

```

After applying the changes, the output on the console should change to something like:

```
{"value":2,"timer":"org.eclipse.kura.wire.Timer-1536913933101-5"}
```

As you can see, we now created a new data structure, based on generated content and based on the original Kura Wires event information.

## Off to the Eclipse Hono HTTP Adapter

Printing out JSON to the console is nice, but let’s get a bit more professional. Yes, Kura allows you to use its Kura specific MQTT data format. But what we want to send this piece of JSON to some HTTP endpoint, like the [Eclipse Hono](https://www.eclipse.org/hono) HTTP protocol adapter?

Camel has a huge variety of endpoints for connecting to various APIs, transport mechanisms and protocols. I doubt you directly would like your IoT gateway to contact Salesforce or Twitter, but using [OPC UA](https://dentrassi.de/2017/04/27/opc-ua-with-apache-camel/), MQTT, HTTP, [IEC 60870](https://dentrassi.de/2017/02/17/iec-60870-5-104-with-apache-camel/), might be a reasonable use case for IoT.

As a first step, we need to install Camel HTTP endpoint support: `https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.http/0.6.0/de.dentrassi.kura.addons.camel.http-0.6.0.dp`

The next step requires an instance of Eclipse Hono, thankfully there is a [Hono sandbox server](https://www.eclipse.org/hono/sandbox/) running at `hono.eclipse.org`.

In the XML Router we need two steps for this. You can add them after the `to` element, so that we still see the JSON on the command line:

```
<setHeader headerName=”Content-Type”><constant>application/json</constant></setHeader>
<to uri="https4://hono.eclipse.org:28080/telemetry?authenticationPreemptive=true&amp;authUsername=sensor1@DEFAULT_TENANT&amp;authPassword=hono-secret"/>

```

The first step sets the content type to `application/json`, which is passed along by Hono to the AMQP network.

Yes, it really is `http4://`, this is not a typo but the Camel endpoint using Apache HttpClient 4.

You may need to register the device with Hono before actually publishing data to the instance. Also, it is necessary that a consumer is attached, which receives the data. Hono rejects devices publish data if no consumer is attached. Also see: <https://www.eclipse.org/hono/getting-started/#publishing-data>

If you are using a custom deployment of Hono using the [OpenShift S2I](https://www.eclipse.org/hono/deployment/openshift_s2i/) approach, then the `to` URL would look more like:

```
<to uri="https4://hono-adapter-http-vertx-sec-hono.my.openshift.cluster/telemetry?authenticationPreemptive=true&amp;authUsername=sensor1@DEFAULT_TENANT&amp;authPassword=hono-secret"/>

```

## Wrapping it up

What we have seen so far is that, with a few lines of XML, it is possible to interface with Kura Wires, and start processing data that was originally not supported by Kura, sending to a target that also isn’t supported by Kura. On for that we only used a few lines of XML.

In addition to that, you can test and develop everything in a local, confined space. Without having to worry too much about actually running a Kura instance.

In [Part #2](https://dentrassi.de/2018/09/17/sunny-weather-apache-camel-kura-wires/), we will have a look at ways to get data from Camel back into Kura Wires. And in [Part #3](https://dentrassi.de/2018/09/19/apache-camel-java-dsl-eclipse-kura-wires/) of this tutorial, we will continue with this approach and develop a Camel based solution, which can run inside of Kura, as well as outside, including actual unit tests.
