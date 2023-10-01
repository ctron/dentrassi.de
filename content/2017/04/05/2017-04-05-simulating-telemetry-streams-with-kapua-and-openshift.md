---
id: 3576
title: 'Simulating telemetry streams with Kapua and OpenShift'
date: '2017-04-05T16:30:44+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3576'
permalink: /2017/04/05/simulating-telemetry-streams-with-kapua-and-openshift/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3587;s:11:"_thumb_type";s:10:"attachment";}'
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

Sometimes it is necessary to have some simulated data instead of fancy sensors attached to your IoT setup. As Eclipse Kapua starts to adopt Elasticsearch, it started to seem necessary to actually unit test the inbound telemetry stream of Kapua. Data coming from the gateway, being processed by Kapua, then stored into Elasticsearch and then retrieved back from Elasticsearch over the Kapua REST API. A lot can go wrong here ;-)

<!-- more -->

[The Kura simulator](https://github.com/eclipse/kapua/tree/develop/simulator-kura), which is now hosted in the Kapua repository, seemed to be right place to do this. That way we can not only test this inside Kapua, but we can also allow different use cases for simulating data streams outside of unit tests and we can leverage the existing [OpenShift integration of the Kura Simulator](https://github.com/eclipse/kapua/tree/develop/simulator-kura/openshift).

The Kura simulator has the ability now to also send telemetry data. In addition to that there is a rather simple simulation model which can use existing value generators and map those to a more complex metric setup.

From a programmatic perspective creating a simple telemetry stream would look this:

```java
GatewayConfiguration configuration = new GatewayConfiguration("tcp://kapua-broker:kapua-password@localhost:1883", "kapua-sys", "sim-1");
try (GeneratorScheduler scheduler = new GeneratorScheduler(Duration.ofSeconds(1))) {
  Set apps = new HashSet<>();
  apps.add(simpleDataApplication("data-1", scheduler, "sine", sine(ofSeconds(120), 100, 0, null)));
  try (MqttAsyncTransport transport = new MqttAsyncTransport(configuration);
       Simulator simulator = new Simulator(configuration, transport, apps);) {
      Thread.sleep(Long.MAX_VALUE);
  }
}
```

The `Generators.simpleDataApplication` creates a new `Application` from the provided map of functions (`Map<String,Function<Instant,?>>`). This is a very simple application, which reports a single metric on a single topic. The `Generators.sine` function returns a function which creates a sine curve using the provided parameters.

Now one might ask, why is this a `Function<Instant,?>`, wouldn’t a simple `Supplier` be enough? There is a good reason for that. The expectation of the data simulator is actually that the telemetry data is derived from the provided timestamp. This is done in order to generate predictable timestamp and values along the communication path. In this example we only have a single metric in a single instance. But it is possible to scale up the simulation to run 100 instances on 100 pods in OpenShift. In this case each simulation step in one JVM would receive the same timestamp and this each of those 100 instances should generate the same values. Sending the same timestamps upwards to Kapua. Now validating this information later on because quite easy, as you not only can measure the time delay of the transmission, but also check if there are inconsistencies in the data, gaps or other issues.

When using the [SimulationRunner](http://download.eclipse.org/kapua/docs/develop/user-manual/en/simulator.html), it is possible to configure data generators instead of coding:

```json
{
 "applications": {
  "example1": {
   "scheduler": { "period": 1000 },
   "topics": {
    "t1/data": {
     "positionGenerator": "spos",
     "metrics": {
      "temp1": { "generator": "sine1", "name": "value" },
      "temp2": { "generator": "sine2", "name": "value" }
     }
    },
    "t2/data": {
     "metrics": {
      "temp1": { "generator": "sine1", "name": "value" },
      "temp2": { "generator": "sine2", "name": "value" }
     }
    }
   },
   "generators": {
    "sine1": {
     "type": "sine", "period": 60000, "offset": 50, "amplitude": 100
    },
    "sine2": {
     "type": "sine", "period": 120000, "shift": 45.5, "offset": 30, "amplitude": 100
    },
    "spos": {
     "type": "spos"
    }
   }
  }
 }
}
```

For more details about this model see: [Simple simulation model](http://download.eclipse.org/kapua/docs/develop/user-manual/en/simulator.html#simple-simulation-model) in the Kapua User Manual.

And of course this can also be managed with the OpenShift setup. Loading a JSON file works like this:

```bash
oc create configmap data-simulator-config --from-file=KSIM_SIMULATION_CONFIGURATION=../src/test/resources/example1.json
oc set env --from=configmap/data-simulator-config dc/simulator
```

Finally it is now possible to visually inspect this data with Grafana, directly accessing the Elasticsearch storage:

[![](https://dentrassi.de/wp-content/uploads/grafana1.png)](https://dentrassi.de/wp-content/uploads/grafana1.png)
