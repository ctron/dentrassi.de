---
id: 3529
title: 'Testing Kapua with simulated Kura gateways'
date: '2017-02-14T15:01:12+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3529'
permalink: /2017/02/14/testing-kapua-with-simulated-kura-gateways/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3531;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - Kapua
    - Kura
    - Testing
---

Now you got your pretty new OpenShift setup of Eclipse Kapua and want to give your IoT cloud a test run?! Testing it out with 100 devices, just for fun? Or even more? But you are too lazy to flash 1000 SD cards for your Raspberry Pi cluster? Here comes the Kura simulator framework. ;-)

<!-- more -->

In order to provide some automatic testing for Kapua I started working on a simulator framework which does simulate Kura instances completely in Java. No backend needed, no hardware needed, able to run multiple instances in a single JVM. And all hosted on GitHub at [ctron/kura-simulator](https://github.com/ctron/kura-simulator).

<figure aria-describedby="caption-attachment-3531" class="wp-caption aligncenter" id="attachment_3531" style="width: 840px">[![A screenshot of Kura simulator instances in Kapua](https://dentrassi.de/wp-content/uploads/kapua_sim_1-1024x630.png)](https://dentrassi.de/wp-content/uploads/kapua_sim_1.png)<figcaption class="wp-caption-text" id="caption-attachment-3531">Kura simulator instances in Kapua</figcaption></figure>The basic idea was to create a set of classes which can be used in automated unit tests in order to simulate a Kura gateway, but allow for a finer grained control over it for testing the good, the bad and the ugly. A real Kura instance would of course be a more realistic test partner, but then again this would have quite a few drawbacks. First of all, Kura cannot be embedded into a unit or integration test. It has far too many dependencies to directory structures, command line utilities, native libraries and it would also require an OSGi container to be started. Second, Kura would always behave like Kura. Now for some tests this may be fine, but if you want to test corner cases where the gateway responds in a way which is not expected by Kapua, then this cannot be done with Kura.

So running a single Kura simulator can be as easy as:

```
<pre class="lang:java decode:true ">
ScheduledExecutorService downloadExecutor = 
   Executors.newSingleThreadScheduledExecutor(new NameThreadFactory("DownloadSimulator"));

GatewayConfiguration configuration =
   new GatewayConfiguration("tcp://kapua-broker:kapua-password@localhost:1883", "kapua-sys", "sim-1");

Set<Application> apps = new HashSet<>();
apps.add(new SimpleCommandApplication(s -> String.format("Command '%s' not found", s)));
apps.add(AnnotatedApplication.build(new SimpleDeployApplication(downloadExecutor)));

try (MqttSimulatorTransport transport = new MqttSimulatorTransport(configuration);
     Simulator simulator = new Simulator(configuration, transport, apps);) {
    Thread.sleep(Long.MAX_VALUE);
    logger.info("Bye bye...");
} finally {
  downloadExecutor.shutdown();
}
```

Of course, scaling this up and running a few more instances of this isn’t a big deal either. Running this in a docker container and scaling this up even more with OpenShift works fine as well. So testing any number of Gateways just became a lot easier.

Currently the simulator can emulate the command service (V1) and most of the deploy service (V2). The configuration service is still missing, but should get implemented in the next few days. Of course it is also possible to register a custom application and provide some metrics yourself.
