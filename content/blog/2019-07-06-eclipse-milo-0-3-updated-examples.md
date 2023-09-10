---
id: 4271
title: 'Eclipse Milo 0.3, updated examples'
date: '2019-07-06T22:22:28+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4271'
permalink: /2019/07/06/eclipse-milo-0-3-updated-examples/
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
    - Java
    - Milo
    - 'OPC UA'
---

A while back I wrote[ a blog post about OPC UA, using Milo](https://dentrassi.de/2017/09/14/creating-opc-ua-solutions-eclipse-milo/) and added a bunch of examples, in order to get you started. Time passed by and now Milo 0.3.x is released, with a changed API and so those examples no longer work. Not too much has changed, but the experience of running into compile errors isn’t a good one. Finally I found some time to update the examples.

This blog post will focus on the changes, compared to the old blog post. As the old blog post is still valid, I though it might make sense to keep it, and introduce the changes of Milo here. The examples repository however is updated to show the new APIs on the `master` branch.

## Making contact

This is the first situation where you run into the changed API, getting the endpoints. Although the new code is not much different, the old will no longer work:

```
<pre class="wp-block-code">```
List<EndpointDescription> endpoints =
  DiscoveryClient.getEndpoints("opc.tcp://localhost:4840")
    .get();
```
```

When you compare that to the old code, then you will notice that instead of an array, now a list is being used and the class name changed. Not too bad.

Also, the way you create a new client instance with Milo 0.3.x is a bit different now:

```
<pre class="wp-block-code">```
OpcUaClientConfigBuilder cfg = new OpcUaClientConfigBuilder();
cfg.setEndpoint(endpoints[0]); // please do better, and not only pick the first entry

OpcUaClient client = OpcUaClient.create(cfg.build());
client.connect().get();
```
```

Using the static `create` method instead of the constructor allows for a bit more processing, before the class instance is actually created. Also may this new method throw an exception now. Handling this in an async way isn’t too hard when you are using Java 9+:

```
<pre class="wp-block-code">```
public static CompletableFuture<OpcUaClient> createClient(String uri) {
  return DiscoveryClient
    .getEndpoints(uri) // look up endpoints from remote
    .thenCompose(endpoints -> {
      try {
        return CompletableFuture.completedFuture(
            OpcUaClient.create(buildConfiguration(endpoints)) // "buildConfiguration" should pick an endpoint
        );
      } catch (final UaException e) {
        return CompletableFuture.failedFuture(e);
      }
    });
}
```
```

## That’s it? That’s it!

Well, pretty much. However, we have only been looking at the client side of Milo. Implementing your own server requires to use the server side API, and that change much more. But to be fair, the changes improve the situation a lot, and make things much easier to use.

## Milo examples repository

As mentioned, the examples in the repository [ctron/milo-ece2017](https://github.com/ctron/milo-ece2017) have been updated as well. They also contain the changed server side, which changed a lot more than the client side.

When you [compare the two branches](https://github.com/ctron/milo-ece2017/compare/milo-0.2x...master) `master` and `milo-0.2.x`, you can see the changed I made for updating to the new version.

I hope this helps a bit in getting started with Milo 0.3.x. And please be sure to read the [original post](https://dentrassi.de/2017/09/14/creating-opc-ua-solutions-eclipse-milo/), giving a more detailed introduction, as well.