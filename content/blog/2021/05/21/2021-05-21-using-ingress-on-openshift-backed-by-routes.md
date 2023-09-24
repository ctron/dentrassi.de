---
id: 4551
title: 'Using Ingress on OpenShift backed by Routes'
description: 'A blog post on using Kubernetes Ingres resources with OpenShift Routes'
date: '2021-05-21T21:10:42+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4551'
permalink: /2021/05/21/using-ingress-on-openshift-backed-by-routes/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:4286;s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:4286;s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/Logotype_RH_OpenShift_wLogo_RGB_Black_wordpress.png
categories:
    - 'Technical Stuff'
---

When you want to get traffic into your OpenShift cluster, `Routes` are just awesome. But every now and then, using `Ingress` instead might provide some benefits. Here are a few tricks how you can have the best of both worlds.

<!-- more -->

## Routes vs Ingress

[OpenShift Routes predate the Ingress resource](https://www.openshift.com/blog/kubernetes-ingress-vs-openshift-route), they have been part of OpenShift 3.0! Routes are just awesome. Instead of fiddling with services and load balancers, you have a single load balancer for bringing in multiple HTTP or TLS based services. The idea is pretty simply, instead of patching through multiple services, you patch through only one: HAproxy. Which then gets configured to direct traffic to the different services inside the cluster.

That way, it is possible to configure a single application domain, issue a wildcard certificate for that domain. So you can create route objects, auto-assign a DNS name and have it secured with TLS automatically. Without needing to issue or refresh certificates individually or maintain DNS entries yourself. It is absolutely simple.

Ingress was modeled after that approach. But for vanilla Kubernetes. It even allows to have different ingress controllers, which take the job of realizing what you configured with your ingress resources. There are few pros and cons on both sides, but if you have an OpenShift setup already, using routes is more convenient in most cases.

## Ingress backed by Routes

Most cases … so, sometimes using Ingress might be better. And I leave it to you to decide when that is. But if you want to use Ingress, [OpenShift brings an ingress controlled](https://docs.openshift.com/container-platform/4.7/networking/ingress-operator.html), backed by Routes. What it does is simple: When you create an Ingress object, it will [translate that into OpenShift Routes](https://docs.openshift.com/container-platform/4.7/networking/routes/route-configuration.html#nw-ingress-creating-a-route-via-an-ingress_route-configuration).

There are some pitfalls, and here are a few tricks.

## You must define a ‘host’ in your Ingress resource

Ingress objects allow you to set a host name for its rules:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress
spec:
  rules:
  - host: my.host.name # optional
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: test
            port:
              number: 80
```

So in that example, the hostname is set to `my.host.name`. However, for the Ingress object, it is perfectly fine to omit that. And the same is true for the OpenShift Route. However, both concepts have a different idea what that means. For Routes, that will auto-create a hostname, in most cases of the pattern `<name>-<namespace>.apps.<your.cluster.domain>`.

For Ingress, that means that there is no filtering (or routing) based on the virtual hostname. So all requests for all hosts match.

What happens in the case of OpenShift Route to Ingress conversion, is that it simply doesn’t create the Routes. You create the Ingress object, and nothing happens.

As soon as you set a hostname, the Routes get created.

## Getting the application domain name

So for Ingress resources, you need to know the application domain name. So far, the only way I found to extract that information from the cluster is be inspecting the ingress controller resource:

```bash
kubectl -n openshift-ingress-operator get ingresscontrollers.operator.openshift.io default -o jsonpath='{.status.domain}'
```

Note the name `default`, that is the name of the default ingress controller. Your cluster can have more. So you might need to tweak that in this case.

## TLS termination

By default, Ingress creates plain HTTP (non-TLS) mappings. A thing that shouldn’t exist anymore. And with Routes, it is super easy to fix that. You can configure the TLS termination, and so inside of your cluster you can still have HTTP, but at least externally, you can encrypt traffic with a cluster wide TLS certificate. With no extra effort.

Ingress backed by Routes can do that too, but it took me a while to find the right page explaining that.

With Ingress you can manually configure the TLS options in `.spec.tls`. But that isn’t necessary, if you simply want to use the OpenShift cluster wide TLS certificate.

Adding the following annotation will configure the route to do “edge” termination:

```yaml
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  annotations:
    route.openshift.io/termination: edge
spec:
  # …
```

This will assume that the traffic at the service is plain HTTP, and encrypt to so that you have HTTPS outside your cluster.

You can also use “re-encrypt” mode, using the following annotation:

```yaml
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  annotations:
    route.openshift.io/termination: "reencrypt" 
spec:
  # …
```

This will assume the traffic already is HTTPS for the service, and it will re-encrypt this at the route level. However, the internal HTTPS traffic can use the internal CA, in which case you don’t need to configure any key/cert on the route level, as that is already trusted internally.

## What else?

I had some issues finding the right information about Ingress on OpenShift, most documentation is about Routes. And I can understand why, because they are just awesome. But I wanted to document what I found out, also through digging through code and other blog posts. So I simply wanted to share what I have learned, in the hope that others might find that information more easily.

If you have some more tips and tricks, please post a comment. I would be happy to update the post with some more information.
