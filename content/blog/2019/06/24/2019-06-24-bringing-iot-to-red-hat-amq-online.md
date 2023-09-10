---
id: 4160
title: 'Bringing IoT to Red Hat AMQ Online'
date: '2019-06-24T09:47:59+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4160'
permalink: /2019/06/24/bringing-iot-to-red-hat-amq-online/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";N;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
---

[Red Hat AMQ Online 1.1](https://access.redhat.com/documentation/en-us/red_hat_amq/7.2/html/amq_online_1.1_on_openshift_container_platform_release_notes/index) was recently announced, and I am excited about it because it contains a tech preview of our Internet of Things [(IoT) support](https://access.redhat.com/documentation/en-us/red_hat_amq/7.2/html/amq_online_1.1_on_openshift_container_platform_release_notes/tech-preview-online#internet_of_things_iot_functionality). AMQ Online is the “messaging as service solution” from Red Hat AMQ. Leveraging the work we did on [Eclipse Hono](https://www.eclipse.org/hono/) allows us to integrate a [scalable](https://dentrassi.de/2018/07/25/scaling-iot-eclipse-hono/), cloud-native IoT personality into this general-purpose messaging layer. And the whole reason why you need an IoT messaging layer is so you can focus on connecting your cloud-side application with the millions of devices that you have out there.

<!-- more -->

*This post was originally published on [Red Hat Developers](https://developers.redhat.com/blog/), the community to learn, code, and share faster. To read the original post, click [here](https://developers.redhat.com/blog/2019/05/14/bringing-iot-to-red-hat-amq-online/).*

## What is Eclipse Hono™?

Eclipse Hono is an IoT abstraction layer. It defines APIs in order to build an IoT stack in the cloud, taking care of things like device credentials, protocols, and scalability. For some of those APIs, it comes with a ready-to-run implementation, such as the MQTT protocol adapter. For others, such as the device registry, it only defines the necessary API. The actual implementation must be provided to the system.

<div class="wp-block-image"><figure class="aligncenter is-resized">![Eclipse Hono IoT architecture overview](https://dentrassi.de/wp-content/uploads/hono-overview.svg)<figcaption>Eclipse Hono overview</figcaption></figure></div>A key feature of Hono is that it normalizes the different IoT-specific protocols on [AMQP 1.0](http://www.amqp.org/specification/1.0/amqp-org-download). This protocol is common on the data center side, and it is quite capable of handling the requirements on throughput and back-pressure. However, on the IoT devices side, other protocols might have more benefits for certain use cases. MQTT is a favorite for many people, as is plain HTTP due to its simplicity. LoRaWAN, CoAP, Sigfox, etc. all have their pros and cons. If you want to play in the world of IoT, you simply have to support them all. Even when it comes to custom protocols, Hono provides a software stack to easily implement your custom protocol.

## AMQ Online

Hono requires an AMQP 1.0 messaging backend. It requires a broker and a component called “router” (which doesn’t own messages but only forwards them to the correct receiver). Of course, it expects the AMQP layer to be as scalable as Hono itself. AMQ Online is a “self-service,” messaging solution for the cloud. So it makes sense to allow Hono to run on top of it. We had this deployment model for a while in Hono, allowing the use of [EnMasse](https://enmasse.io/) (the upstream project of AMQ Online).

## Self-service IoT

In a world of Kubernetes and operators, the thing that you are actually looking for is more like this:

```
<pre class="wp-block-code">```
kind: IoTProject
 apiVersion: iot.enmasse.io/v1alpha1
 metadata:
   name: iot
   namespace: myapp
 spec:
   downstreamStrategy:
     managedStrategy:
       addressSpace:
         name: iot
         plan: standard-unlimited
       addresses:
         telemetry:
           plan: standard-small-anycast
         event:
           plan: standard-small-queue
         command:
           plan: standard-small-anycast
```
```

You simply define your IoT project, by creating a new custom resource using `kubectl create -f` and you are done. If you have the IoT operator of AMQ Online 1.1 deployed, then it will create the necessary address space for you, and set up the required addresses.

The IoT project will also automatically act as a Hono tenant. In this example, the Hono tenant would be `myapp.iot`, and so the full authentication ID of e.g. `sensor1` would be `sensor1@myapp.iot`. The IoT project also holds all the optional tenant configuration under the section `.spec.configuration`.

With the [Hono admin tool,](https://github.com/ctron/hat) you can quickly register a new device with your installation (the documentation will also tell you how to achieve the same with `curl`):

```
<pre class="wp-block-code">```
# register the new context once with 'hat'
hat context create myapp1 --default-tenant myapp.iot https://$(oc -n messaging-infra get routes device-registry --template='{{ .spec.host }}')

# register a new device and set credentials
hat reg create 4711
hat cred set-password sensor1 sha-512 hono-secret --device 4711
```
```

With that, you can simply use Hono as always. First, start the consumer:

```
<pre class="wp-block-code">```
# from the hono/cli directory
export MESSAGING_HOST=$(oc -n myapp get addressspace iot -o jsonpath={.status.endpointStatuses[?(@.name==\'messaging\')].externalHost})
export MESSAGING_PORT=443

mvn spring-boot:run -Drun.arguments=--hono.client.host=$MESSAGING_HOST,--hono.client.port=$MESSAGING_PORT,--hono.client.username=consumer,--hono.client.password=foobar,--tenant.id=myapp.iot,--hono.client.trustStorePath=target/config/hono-demo-certs-jar/tls.crt,--message.type=telemetry
```
```

And then publish some data to the telemetry channel:

```
<pre class="wp-block-code">```
curl -X POST -i -u sensor1@myapp.iot:hono-secret -H 'Content-Type: application/json' --data-binary '{"temp": 5}' https://$(oc -n enmasse-infra get routes iot-http-adapter --template='{{ .spec.host }}')/telemetry
```
```

For more detailed instructions, see: [Getting Started with Internet of Things (IoT) on AMQ Online](https://access.redhat.com/documentation/en-us/red_hat_amq/7.2/html/evaluating_amq_online_on_openshift_container_platform/assembly-iot-messaging).

## IoT integration

As mentioned before, you don’t do IoT just for the fun of it (well, maybe at home, with a Raspberry Pi, Node.js, OpenHAB, and mosquitto). But when you want to connect millions of devices with your cloud backend, you want to start working with that data. Using Hono gives you a pretty simple start. Everything you need is an AMQP 1.0 connectivity. Assuming you use Apache Camel, pushing telemetry data towards a Kafka cluster is as easy as (also see [ctron/hono-example-bridge](https://github.com/ctron/hono-example-bridge)):

```
<pre class="wp-block-code">```
<route id="store">
  <from uri="amqp:telemetry/myapp.iot" />

  <setHeader id="setKafkaKey" headerName="kafka.KEY">
    <simple>${header[device_id]}</simple>
  </setHeader>

  <to uri="kafka:telemetry?brokers={{kafka.brokers}}" />
</route>
```
```

Bringing together solutions like [Red Hat Fuse](https://www.redhat.com/en/technologies/jboss-middleware/fuse), [AMQ](https://www.redhat.com/en/technologies/jboss-middleware/amq) and [Decision Manager](https://www.redhat.com/en/technologies/jboss-middleware/decision-manager) makes it a lot easier to give your custom logic in the data center (your value add‑on) access to the Internet of Things.

## What’s next?

AMQ Online 1.1 is the first version to feature IoT as a tech preview. So, give it a try, play with it, but also keep in mind that it is a tech preview.

In the upstream project EnMasse, we are currently working on creating a scalable, general purpose device registry based on [Infinispan](https://infinispan.org/). Hono itself doesn’t bring a device registry, it only defines the APIs it requires. However, we think it makes sense to provide a scalable device registry, out of the box, to get you started. In AMQ Online, that would then be supported by using [Red Hat Data Grid](https://www.redhat.com/en/technologies/jboss-middleware/data-grid).

In the next months, we hope to also see the release of Eclipse Hono 1.0 and graduate the project from the incubation phase. This is a big step for a project at Eclipse but also the right thing to do. Eclipse Hono is ready, and graduating the project means that we will pay even closer attention to APIs and stability. Still, new features like LoRaWAN, maybe Sigfox, and a proper HTTP API definition for the device registry, are already under development.

So, there are lots of new features and enhancements that we hope to bring into AMQ Online 1.2.
