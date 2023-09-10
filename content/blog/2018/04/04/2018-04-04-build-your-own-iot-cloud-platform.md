---
id: 3833
title: 'Build your own IoT cloud platform'
date: '2018-04-04T16:37:31+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3833'
permalink: /2018/04/04/build-your-own-iot-cloud-platform/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - disable
fabulous-fluid-featured-image:
    - disable
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3856;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
    - IoT
    - 'Technical Stuff'
tags:
    - Cloud
    - Eclipse
    - Hono
    - IoT
    - Kubernetes
    - OpenShift
---

If you want to do large scale IoT and build your own IoT cloud platform, then you will need a messaging layer which can actually handle this. Not only handle the sheer load of messages, the number of connections. Even more important may be ability to integrate your custom bits and pieces and be able to make changes to every layer of that installation, in a controlled, yet simple way.

<!-- more -->

### An overview

[Eclipse Hono](https://www.eclipse.org/hono/) is an open source project under umbrella of the [Eclipse IoT](https://iot.eclipse.org/) top level project. It provides a set of components and services used for building up your own IoT cloud platform:

![Overview of Eclipse Hono IoT cloud platform](https://dentrassi.de/wp-content/uploads/hono_s2i_overview.png)

In a nutshell, Hono does provide a framework to create protocol adapters, and also delivers two “standard” protocol adapters, one for HTTP and one for MQTT. Both options are equally important to the project, because there will always be a special case for which you might want a custom solution.

Aside from the standard components, Hono also defines at set of APIs based on AMQP 1.0 in order to mesh in other services. Using the same ideas from adding custom protocol adapters, Hono allows to hook up your custom device registry and your existing authentication/authorization system (read more about [Eclipse Hono APIs](https://www.eclipse.org/hono/api/)).

The final direct or store-and-forward message delivery is offloaded to an existing messaging layer. The scope of Hono is to create an IoT messaging infrastructure by re-using an existing, use case agnostic messaging layer and not to create another one. In this post we will assume that [EnMasse](http://enmasse.io) is being used for that purpose. Simply because EnMasse is the best choice for AMQP 1.0 when it comes to Kubernetes/OpenShift. It is a combination of Apache Qpid, Apache Artemis, Keycloak and some EnMasse native components.

In addition to that, you will of course need to plug in your actual custom business logic. Which leaves you with a zoo of containers. Don’t get me wrong, containers are awesome, simply imagine you would need to deploy all of this on a single machine.

### Container freshness

But this also means that you need to take care of containers freshness at some point. Most likely making changes to your custom logic and maybe even to Hono itself. What is “container freshness”?! – Containers are great to use, and easy to build in the beginning. Simply create a `Dockerfile`, run `docker build` and you are good to go. You can also do this during your Maven release and have one (or more) final output containers(s) for your release, like Hono does it for example. The big flaw here is, that a container is a stack of layers, making up your final (application) image. Starting with a basic operating system layer, adding additional tools, adding Java and maybe more. And finally your local bits and pieces (like the Hono services).

All those layers link to exactly one parent layer. And this link cannot be updated. So Hono 0.5 points to a specific version of the “openjdk” layer, which again points to a specific version of “debian”. But you want your IoT cloud platform to stay fresh and up-to-date. Now assume that there is some issue in any of the Java or Debian base layers, like a security issue in the “glibc”. Unless Hono releases a new set of images, you are unable to get rid of this issue. In most cases you want to upgrade your base layers more frequently than you actual application layer.

Or consider the idea of using a different base layer than the Hono project had in mind. What if you don’t want to use Debian as a base layer? Or want to use Eclipse J9 instead of the OpenJDK JVM?

### Building with OpenShift

When you are using OpenShift as a container platform (and Kubernetes supports the same approach) you can make use of image streams and builds. An image stream simply is a way to store images and maintaining versions. When an image stream is created, it normally is empty. You can start to populate it with images, either by importing them from existing repositories, like DockerHub or your internal ones. Or by creating images yourself with a build running inside of OpenShift. Of course you are in charge of all operations, including tagging versions. This means that you can easily replace an image version, but in a controlled way. So no automatic update of a container will break your complete system.

There are different types of builds. A rather simple one is the well known “Dockerfile” approach. You define a base image and add a few commands which will make up the new container layer. Then there is the “source-to-image” (S2I) build, which we will have a look at in a second.

### Building &amp; Image Streams

Now with that functionality you can define a setup like this:

![Diagram of example image streams](https://dentrassi.de/wp-content/uploads/hono_s2i_image_streams.png)

The base image gets pulled in from an external registry. And during that process you map versions to your internal versioning schema. What a move from “v1” to “v2” means in your setup is completely up to you.

The pulled in image gets fed into a build step, which will produce a new image based on the defined parent, e.g. your custom base image. Maybe this means simply adding a few command line utilities to the existing base image. Or some policy file, … The custom base image can then be used by the next build process to create an application specific container, hosting your custom application. Again, what a versioning schema you use, is completely up to you.

If you like you can also define triggers between these steps. So that when OpenShift pulls in a new image from the external source or the source code of the git repository changes, all required builds get executed and finally the new application versions gets deployed automatically. Old image versions may be kept so that you can easily switch back to an older version.

### Source-to-Image (S2I)

Hono uses a plain Maven build and is based on Vert.x and Spring Boot. The default way of building new container images is to check out the sources from git and run a local maven build. During the build Maven wants to talk to some Docker Daemon in order to assemble new images and storing it into its registry.

Now that approach may be fine for developers. But first of all this is a quite complex, manual job. And second, in the context described above, it doesn’t really fit.

As already described, OpenShift supports different build types to create new images. One of those build types is “S2I”. The basic idea behind S2I is that you define a build container image, which adheres to a set of entry and exit points. Processing the provided source, creating a new container image which can be used to actually run this source. For Java, Spring Boot and Maven there is an S2I image from “fabric8”, which can be tweaked with a few arguments. It will run a maven build, find the Spring Boot entry point, take care of container heap management for Java, inject a JMX agent, …

That way, for Hono you can simply reuse this existing S2I image in a build template like:

```
source:
  type: Git
  git:
    uri: "https://github.com/eclipse/hono"
    ref: "0.5.x"
strategy:
  type: source
  sourceStrategy:
    from:
      kind: ImageStreamTag
      name: "fabric8-s2i-java:2.1"
    env:
      - name: MAVEN_ARGS_APPEND
        value: "-B -pl org.eclipse.hono:hono-service-messaging --also-make"
      - name: ARTIFACT_DIR
        value: "services/messaging/target"
      - name: ARTIFACT_COPY_ARGS
        value: "*-exec.jar"

```

This simple template allows you to reuse the complete existing Hono source code repository and build system. And yet you can start making modifications using custom base images or changes in Git right away.

Of course you can reuse this for your custom protocol adapters as well. And for your custom application parts. In your development process you can still use plain Maven, Spring Boot or whatever your prefer. When it comes to deploying your stack in the cloud, you hand over the same build scripts to OpenShift and S2I and let your application be built in the same way.

### Choose your stack

The beauty of S2I is, that it is not tied to any specific language or toolset. In this case, for Hono, we used the “fabric8” S2I image for Java. But if you would prefer to write your custom protocol adaptor in something else, like Python, Go, .NET, … you still could use S2I and the same patterns to go with this language and toolset.

Also, Hono supports creating protocol adapters and services in different (non-JVM based) languages. Hono components get meshed up using Hono’s AMQP 1.0 APIs, which allow to use the same flow control mechanism for services as they are used for IoT data, building your IoT cloud platform using a stack you prefer most.

### … and beyond the infinite

OpenShift has a lot more to offer when it comes to building your platform. It is possible to use build pipelines, which allow workflows publishing to some staging setup before going to production. Re-using the same generated images. Or things like:

- Automatic key and certificate generation for the inter-service communication of Hono.
- Easy management of Hono configuration files, logging configuration using “ConfigMaps”.
- Application specific metrics generation to get some insights of application performance and throughput.

That would have been a bit too much for a single blog post. But I do encourage you to have a look at the [OpenShift Hono setup](https://github.com/ctron/hono/tree/feature/support_s2i_05x/openshift#deploy-hono-template) at my forked Hono repository on GitHub, which makes use of some of this. This setup tries to provide a more production ready deployment setup for using Hono. However it can only be seen as a reference, as any production grade setup would definitely require replacements for the example device registry, a better tuned logging configuration and definitely a few other tweaks of your personal preference ;-)

Hono also offers a lot more than this blog post can cover when building your own IoT cloud platform. One important aspect definitely is data privacy, yet supporting multiple tenants on the same instance. Hono already supports full mulit-tenancy, down to the messaging infrastructure. This makes it a perfect solution for honoring data privacy in the public and private cloud. Read more about [new multi-tenant features of the next Hono version](https://blog.bosch-si.com/developer/using-multi-tenancy-in-eclipse-hono/) in Kai Hudalla’s blog post.

### Take a look – EclipseCon France 2018

[Dejan](http://sensatic.net/about) and I will have a [talk about Hono at the EclipseCon France](https://www.eclipsecon.org/france2018/session/cloud-scale-iot-messaging) in Toulouse (June 13-14). We will present Hono in combination with EnMasse as an IoT cloud platform. We will also bring the setup described above with us and would be happy to you show everything in action. See you in Toulouse.
