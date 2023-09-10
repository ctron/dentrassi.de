---
id: 3906
title: 'Using PKCS #1 PEM encoded X.509 certificates in Java'
date: '2018-05-18T14:43:19+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3906'
permalink: /2018/05/18/pem-encoded-x-509-certificates-java/
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
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";N;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - crypto
    - Java
    - KeyStore
    - pem
---

PEM is a well know file format when it comes to certificates. And when using Kubernetes (or OpenShift in my case) it is so easy to re-use the internal CA for some tasks.

<!-- more -->

 Except when it comes to Java. As Java does only use JKS (its Java-only, binary keystore) or PKCS12 for keys and certificates. Google offers you a bunch of tutorials, on how to convert PEM encoded certificates to JKS or PKCS12, so that Java can consume that. But that may be ugly in a lot of situations. Doing that manually once if fine. But adding this to e.g. a pod, becomes a lengthy YAML init container setup, which seems unnecessary to me.

But Java does allow the use of security providers, which may extend the security system. However searching the net, I couldn’t find anything which would provider a PEM based KeyStore. Maybe that was simply due to the fact that the over “convert PEM to …” tutorials spammed the search results.

So I went along and simply created my own provider. For my own use case, which is using the OpenShift service CA certificate. It only took a few minutes to do the actual implementation as reading a PEM file is no mystery.

In case you need to use a PEM encoded X.509 certificate in Java, you now can either re-encode that with `openssl `on the command line or simply drop on this provider and use `PEM` as the KeyStore type:

```
<pre class="wp-block-code">```
<dependency>
  <groupId>de.dentrassi.crypto</groupId>
  <artifactId>pem-keystore</artifactId>
  <version>2.0.0</version>
</dependency>
```
```

And then:

```
<pre class="wp-block-code">```
KeyStore keyStore = KeyStore.getInstance("PEM");
```
```

For more information see: [ctron/pem-keystore](https://github.com/ctron/pem-keystore) at GitHub

If you know some other provider which supports this, please let me know and I would be happy to switch as this is only a scratch to my itch :) On the other hand if this is useful to you, then please let me know. There are still a few things missing, like <del>keys</del> and Java 9+ support. But maybe you want to submit a pull request for that :D

**Update:** I did release an update of this provider. Version 2.0 has support for keys and CA bundles.
