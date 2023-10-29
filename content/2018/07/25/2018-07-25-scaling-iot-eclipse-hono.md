---
id: 3921
title: 'We scaled IoT – Eclipse Hono in the lab'
date: '2018-07-25T14:03:45+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3921'
permalink: /2018/07/25/scaling-iot-eclipse-hono/
inline_featured_image:
    - '0'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";N;s:11:"_thumb_type";s:10:"attachment";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
taxonomies:
  categories:
    - Development
    - IoT
    - 'Technical Stuff'
  tags:
    - Eclipse
    - Hono
    - IoT
---

Working for [Red Hat](https://jobs.redhat.com) is awesome. Not only can you work on amazing things, you will also get the tools you need in order to do just that. We wanted to test [Eclipse Hono](https://eclipse.org/hono) (yes, again) and see how far we can scale it. And of course which limits and issues we encounter on the way. So we took the current development version of Hono (0.7) from Eclipse IoT, backed by [EnMasse](http://enmasse.io) 0.21 and ran it on an OpenShift 3.9 cluster.

<!-- more -->

**Note:**  This blog post presents an intermediate result of the whole test, as it is still ongoing. Want to know more? We put in a talk for EclipseCon Europe about this scale test. With a bit of luck we can show you more in person at the end of October in Ludwigsburg.

## The lab

From the full test cluster, we received an allocation of 16 nodes with a bit of storage (mostly HDDs), Intel Xeon E5-2620, 2×6 cores (24 threads) each and a mix of 64GB/128GB RAM. 12 nodes got assigned for the IoT cluster, running Eclipse Hono, EnMasse and OpenShift. The remaining 4 nodes made up the simulation cluster for generating the IoT workload. For the simulation cluster, we also deployed OpenShift, simply to re-use the same features like scaling, deploying, building as we did for the IoT cluster. Both clusters are a single master setup. For the IoT cluster, we went with [GlusterFS](https://docs.openshift.com/container-platform/3.9/install_config/persistent_storage/persistent_storage_glusterfs.html) as the storage provider as we wanted to have dynamic provisioning for the broker deployments. Everything is connected by a 1GBit Ethernet link. In the IoT cluster, we allocated 3 nodes for infrastructure-only purposes (like the Docker registry and the OpenShift router). Which left 8 general-purpose compute nodes that Hono could make use of.

[<object class="img-fluid" data="https://dentrassi.de/wp-content/uploads/eclipse-hono-scaletest2-nodes.svg"></object>](https://dentrassi.de/wp-content/uploads/eclipse-hono-scaletest2-nodes.svg)

## The test

The focus of this test was put on telemetry data using HTTP as a transport. For this we simulated devices, sending one message per second. In the context of IoT, you have a bigger number of senders (devices), but they do send less payload and less frequent than e.g. a cloud-side enterprise system might do. It is also most likely that an IoT device wouldn’t send once each second over HTTP. But “per second” is easier to process. And, at least in theory, you could trade in 1.000 devices sending once per second with 10.000 devices sending once every 10 seconds.

The simulator cluster consisted of three main components. An InfluxDB to store some metrics. A “consumer” and a “HTTP simulator” deployment. The consumer directly consumed from the EnMasse [Qpid dispatch router](https://qpid.apache.org/components/dispatch-router/index.html) instance via AMQP 1.0, as fast as possible. The HTTP simulator tries to simulate 2.000 devices with a message rate of 1 message per second per device. If the HTTP adapter stalls, it will wait for requests to complete. For the HTTP client, we used the [Vert.x Web Client](https://vertx.io/docs/vertx-web-client/java/), as it turned out to be the most performant Java HTTP client (aside from having a nice API). So scaling up by single pod means that we increase the IoT workload by 2.000 devices (meaning 2.000 additional messages per second).

<object alt="Testing architecture" class="aligncenter size-full wp-image-3949" data="https://dentrassi.de/wp-content/uploads/eclipse-hono-scaletest2-architecture.svg"></object>

## To the max

As a first exercise we tried out a few configurations and see how far we could get. In the end, we were able to saturate the ethernet port of our (initially) two ingress nodes and so decided to re-allocate one node from Eclipse Hono to the OpenShift infrastructure. Having 3 ingress nodes and 8 compute nodes. This did reduce the capacity available for Hono and let us run into a limit of processing messages. However, it seemed better to run into a limit with Hono compared to running into a limit of network throughput. Adding an additional ingress node would be a simple task to do. And if we could improve Hono during the test, then we would actually see more throughput as we have some reserves in network throughput with that third node.

The final setup processed something around 80.000 devices with 1 message/second. There was a bit of room above that. But our DNS round-robin “load balancer” was not optimal, so we kept that reserve for further testing.

**Note:** Please note, that this number may be quite different on other machines, in other environments. We simply used this as a baseline for further testing.

## Scaling up

The first automated scenario we ran was a simple scale up test. For that we scaled down all producers and consumer and slowly started to scale up the producers. After adding a new pod it waited until the message flow has settled. If the failure rate is too high, then scale up an additional protocol adapter. Otherwise, scale up another producer and continue.

As an acceptable failure rate, this test used 2% of the messages over the last 3 minutes. And a “failure” is actually a rejection of the message at the current point in time. Devices may re-try at a later time to submit its data. For telemetry data, it may be fine to, drop some information (with QoS 0) every now and then. Or use QoS 1 instead and but be aware of the fact that the current request as rejected and re-try at a later time. In any case, if Hono responds with a failure of 503, then the adapter cannot handle any more requests at the moment, leading to an increased failure rate in the simulator.

## Initial results

So let’s have a quick look at the results of this test:

![Eclipse Hono scale testing results, number of pods](https://dentrassi.de/wp-content/uploads/eclipse-hono-scaletest2-chart1.svg)

This chart shows the scale-up of the simulator pods and the accompanying scale-up of the Eclipse Hono protocol adapter pods. You can also see the number of messages each instance of the protocol adapters processes. It looks like, once we push a few messages into the system, this evens out around 5.000 msgs/s. Meaning that each additional Hono HTTP adapter instance can serve 5.000 more messages/s, or 5.000 devices sending one message per second. Or 50.000 devices sending one message every 10 seconds. And each time we fire up a new instance the whole system can handle 5.000 msgs/s more.

In the second chart we can see the failure rate:

![Eclipse Hono scale testing results, failure rate](https://dentrassi.de/wp-content/uploads/eclipse-hono-scaletest2-chart2.svg)

Now the rule for the test was, that the failure rate has to be below 2% in order for the test to continue scaling up. We the test didn’t do well was to wait a bit longer and see if the failure rate declined even more. The failure rate is a moving average over 3 minutes. For that reason, this behavior has been changed in succeeding tests. The scenario now waits a bit longer before recording the final result of the current step.

So what you can see is that the failure rate stays below that “magic” 2% line. But that was the requirement. Except of course for the last entry, where the test was ended as there were no more resources to scale up in order for the scenario to compensate.

## Yes it scales

Does Eclipse Hono scale? With charts and numbers, there is always room for interpretation. ;-) But to me, it definitely looks that way. When we increase the IoT workload we can compensate by scaling up protocol adapters in a linear way. Settling around 5.000 msgs/s per protocol adapter instance and keeping that figure until the end of the test. Until we ran out of computing resources.

## Want more?

More background? You can have a look at the source code around this test on GitHub at [redhat-iot/hono-simulator](https://github.com/redhat-iot/hono-simulator) and [redhat-iot/hono-scale-test](https://github.com/redhat-iot/hono-scale-test). But please remember that this setup might be very specific to our infrastructure and test.

More details? Come to our talk at EclipseCon Europe if we get accepted and learn more about how we did the test. What improvements we tried out, which issues we ran in and how we set up of our infrastructure. And maybe have a chat with us in person about the gory details of IoT testing.

More throughput? Come and join the [Eclipse Hono community](https://github.com/eclipse/hono) and bring in your ideas about performance improvements.
