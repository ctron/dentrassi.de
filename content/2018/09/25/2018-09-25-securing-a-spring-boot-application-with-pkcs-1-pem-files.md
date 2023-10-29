---
id: 4056
title: 'Securing a Spring Boot application with PKCS #1 PEM files'
date: '2018-09-25T17:17:27+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4056'
permalink: /2018/09/25/securing-a-spring-boot-application-with-pkcs-1-pem-files/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";N;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - 'Technical Stuff'
---

When you want to secure a Spring Boot application with e.g. [Let’s Encrypt](https://letsencrypt.org/) or the [OpenShift Service CA](https://docs.openshift.com/container-platform/3.10/dev_guide/secrets.html#service-serving-certificate-secrets), then you will pretty soon figure out that working with PKCS #1 PEM files is a nightmare when it comes to Java. When you Google for PKCS #1 and Java, you will find all kinds of tutorials which suggest to use `openssl` and `keytool` to create a JKS or PKCS #12 keystore. As Java actually supports pluggable KeyStore implementations, I think there is a better solution for that.

<!-- more -->

A while back I did work on a [PKCS #1 PEM keystore implementation](https://dentrassi.de/2018/05/18/pem-encoded-x-509-certificates-java/), but at the time, it did only support certificates. Now this problem came back to me, and so it was time for version 2.0.

## Spring Boot

Securing a Spring Boot application is rather simple, e.g have a look at [this tutorial](https://dzone.com/articles/spring-boot-secured-by-lets-encrypt). All you have to do is to provide a system properties:

```
server.ssl.enabled=true
server.ssl.key-store=/path/to/server.p12
server.ssl.key-store-type=PKCS12
server.ssl.key-store-password=secret
server.ssl.key-alias=server
server.ssl.key-password=secret
```

But most of the tutorial actually is about converting from PKCS #1 PEM files to PKCS #12. Because all that Java can directly process is PKCS #12 or its own JKS format.

## PKCS #1 PEM KeyStore

Now you can drop in the PKCS #1 PEM KeyStore, and directly use those PEM:

```
server.ssl.enabled=true
server.ssl.key-store=/path/to/keystore.properties
server.ssl.key-store-type=PEMCFG
server.ssl.key-store-password=dummy
server.ssl.key-alias=keycert
```

And then you create the file `keystore.properties`:

```
alias=keycert
source.cert=/etc/…/fullchain.pem
source.key=/etc/…/privkey.pem
```

Now you need to make the Java security system aware of the `PEMCFG` KeyStore provider. Gladly Java doesn’t easily allow to tamper with the security sub-system. So this needs to be an explicit action. In some way, you have to manually register the provider with Java. With Spring Boot the easiest option is in the main application entry-point:

```java
import de.dentrassi.crypto.pem.PemKeyStoreProvider;

…

public static void main(final String[] args) throws Exception {
  Security.addProvider(new PemKeyStoreProvider());
  SpringApplication.run(Application.class, args);
}

```

## OpenShift Service CA

This also works with the OpenShift Service CA. Assuming you mapped the TLS secret to `/etc/tls`, you could use the following `application.yaml` file for Spring Boot:

```yaml
server:
  port: 8443
  ssl:
    key-store-type: PEMCFG
    key-store: classpath:keystore.properties
    key-store-password: dummy
    key-alias: keycert

security:
  require-ssl: true
```

And the following “keystore.properties” file, which you put in your JAR:

```
alias=keycert
source.key=/etc/tls/tls.key
source.cert=/etc/tls/tls.crt
```
