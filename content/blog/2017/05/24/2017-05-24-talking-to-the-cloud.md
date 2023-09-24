---
id: 3616
title: 'Talking to the cloud'
date: '2017-05-24T17:49:18+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3616'
permalink: /2017/05/24/talking-to-the-cloud/
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
    - IoT
    - Kapua
    - Karaf
    - smarthome
---

While working on [Eclipse Kapua](https://www.eclipse.org/kapua/), I wanted to do different tests, pushing telemetry data into the system. So I started to work on the [Kura simulator](https://github.com/eclipse/kapua/tree/develop/simulator-kura), which can used to simulator an Eclipse Kura IoT gateway in a plain Java project, no special setup required. Now that helped a lot for unit testing and scale testing. Even [generating a few simple telemetry data streams](http://download.eclipse.org/kapua/docs/develop/user-manual/en/simulator.html) for simulating data works out of the box.

<!-- more -->

But then again I wanted to have something more lightweight and controllable. With the simulator you actually derive some a simple class and get fully controlled by the simulator framework. That may work well in some cases, but in others you may want to turn over the control to the actual application. Assume you already have a component which is “in charge” of your data, and now you want to push this into the cloud. Of course you can do this somehow, working around that. But creating a nice API for that, which is simple and easy to understand is way more fun ;-)

So here is my take on a Gateway Client API, sending IoT data to the cloud, consuming command &amp; control from it.

### Intentions

I wanted to have a simple API, easy to understand, readable. Preventing you from making mistakes in the first place. And if something goes wrong, it should go wrong right away. Currently we go with MQTT, but there would be an option to go with HTTP as well, or AMQP in the future. And also for MQTT we have Eclipse Paho and FUSE MQTT. Both should be available, both may have special properties, but share some common ground. So implementing new providers should be possible, while sharing code should be easy as well.

### Example

Now here is with what I came up with:

```java
try (Client client = KuraMqttProfile.newProfile(FuseClient.Builder::new)
  .accountName("kapua-sys")
  .clientId("foo-bar-1")
  .brokerUrl("tcp://localhost:1883")
  .credentials(userAndPassword("kapua-broker", "kapua-password"))
  .build()) {

  try (Application application = client.buildApplication("app1").build()) {

    // subscribe to a topic

    application.data(Topic.of("my", "receiver")).subscribe(message -> {
      System.out.format("Received: %s%n", message);
    });

    // cache sender instance

    Sender<runtimeexception> sender = application
      .data(Topic.of("my", "sender"))
      .errors(ignore());

    int i = 0;
    while (true) {
      // send
      sender.send(Payload.of("counter", i++));
      Thread.sleep(1000);
    }
  }
}
```

Looks pretty simple right? On the background the MQTT connection is managed, payload gets encoded, birth certificates get exchanges and subscriptions get managed. But still the main application is in control of the data flow.

### How to do this at home

If you want to have a look at the code, it is available on GitHub ([ctron/kapua-gateway-client](https://github.com/ctron/kapua-gateway-client)) and ready to consume on Maven Central ([de.dentrassi.kapua](https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22de.dentrassi.kapua%22)). But please be aware of the fact that this is a proof-of-concept, and may never become more than that.

Simply adding the following dependency to your project should be enough:

```xml
<dependency>
  <groupId>de.dentrassi.kapua</groupId>
  <artifactId>kapua-gateway-client-provider-mqtt-fuse</artifactId>
  <version>0.2.0</version> <!-- check for a more recent version -->
</dependency>
```

With this dependency you can use the example above. If you want to got for Paho instead of FUSE use `kapua-gateway-client-provider-mqtt-paho` instead.

### Taking for a test drive

Now taking this for a test drive as even more fun. [Eclipse SmartHome](https://eclipse.org/smarthome) has the concept of a persistence system, where telemetry data gets stored in a time series like database. There exists a default implementation for rrdb4j. So re-implementing this interface for Kapua was quite easy and resulted in an example module which can be installed into the Karaf based OpenHAB 2 distribution with just a few commands:

```
openhab> repo-add mvn:de.dentrassi.kapua/karaf/0.2.0/xml/features
openhab> feature:install eclipse-smarthome-kapua-persistence
```

Then you need to re-configure the component over the “Paper UI” and point it towards your Kapua setup. Maybe you will need to tweak the “kapua.persist” file in order to define what gets persisted and when. And if everything goes well, your temperate readings will get pushed from SmartHome to Kapua.

### More information

- GitHub repository – [ctron/kapua-gateway-client](https://github.com/ctron/kapua-gateway-client)
- Search Maven Central – [de.dentrassi.kapua](https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22de.dentrassi.kapua%22)
- [Documentation](https://ctron.github.io/kapua-gateway-client/)
