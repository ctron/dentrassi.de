---
id: 4542
title: 'Recovering from an expired OpenShift certificate'
date: '2021-01-18T12:29:21+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4542'
permalink: /2021/01/18/recovering-from-an-expired-openshift-certificate/
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
    - 'Technical Stuff'
---

A not-so-great way to start into a new week, is to figure out that the certificate of your API server expired on the weekend. Fixing and expired OpenShift certificate should be straight forward, but it wasn’t. Here is what happened, or you can directly scroll down for the solution.

<!-- more -->

## The setting

I am running my own [OpenShift](https://www.openshift.com/) cluster for a while now, playing with [IoT stuff](https://dentrassi.de/category/iot/), and using [Let’s Encrypt](https://letsencrypt.org/) certificates to secure the API server endpoints and the application domain. Most of that is automated, only the certificate renewal is not. So every 60 days, I am refreshing the certificates, which gives me a buffer of 30 days, should something go wrong. And while I have that scripted as well, I need to manually trigger that.

So when you start a new week, try to log in an see the following output, you know that you forgot about something important:

```
error: x509: certificate has expired or is not yet valid: current time 2021-01-18T11:21:55+01:00 is after 2021-01-17T09:35:54Z
```

Then again, I do recall refreshing the certificates at the end of 2020. So what went wrong?

## What happened?

I only found out about the root cause later, once I fixed the issue. However, it is an important piece of the puzzle, because my case was a bit different from most cases of an expired OpenShift certificate.

OpenShift allows you to manage the certificates using a custom resource, and has an operator to roll out those certificates. In a nutshell, you need to provide two `Secrets`, containing a signed certificate and key each. OpenShift will do the rest for you. One combination is for the API server, and the other one is for the application domain, the default ingress mechanism.

I did make a change to my script, and that introduced a bug. The result was that the API server certificates was renewed, however the application domain certificate was not.

## What needed to be done?

All that I would needed to do in order to fix this, was to update the `Secret` which contains the key/cert combination. Providing a newer, non-expired version, would trigger a re-rollout and all things would be back to normal.

But how you can update a `Secret` if you no longer have access to your cluster? `oc login` failed with the certificate error.

## Why not skip TLS validation?

True, the `oc` command, as well as the `kubectl` command, offer you to provide `--insecure-skip-tls-verify=true` and just skip TLS validation. And that would have worked, if the issue was with the API server certificate.

However, the situation here was different. I didn’t have a valid access token anymore. In order to get a new one, you simply do `oc login`. That didn’t work out, reporting the same X.509 certificate error. In the background, the `oc` commands tries to refresh the token, but not using the API server, but using an OAuth endpoint. Which is hosted on the standard ingress endpoints, and not the API server endpoints. Unfortunately, `--insecure-skip-tls-verify` only works for the API server endpoints. I would call that a bit inconsistent, but hey.

## Other cases of expired OpenShift certificates

Searching on the internet for a solution, all kinds of “expired certificate” cases with Kubernetes showed up. Many of the on the control plane, but that wasn’t what I was looking for. Also some of the API server certificate fixes sounded rather invasive. I am glad I didn’t give any of them a try, as that might have actually caused more harm in the end.

Remember, all I needed was a way to replace some `Secrets`.

## The solution

After some debugging, I found the root cause, mentioned above. The API endpoint certificate was working, the OAuth one was expired. Making `oc login` fail, despite adding `--insecure-skip-tls-verify=true` to calls.

Fortunately, when creating an OpenShift cluster you will also get a cluster certificate, which you can use to access the API server as an admin user. You are supposed to keep this key/cert combination, for cases like this.

Setting the `KUBECONFIG` environment variable to the generated, original configuration gives you direct access to your cluster, without the need to log in:

```bash
export KUBECONFIG=/home/me/cluster/installation/auth/kubeconfig
```

After that, I was automatically “logged in”, and could re-run my custom scripts for replacing the `Secrets` necessary to fix the expired OpenShift certificates. The operator rolled them out, and the cluster was operational again.

The actual commands for re-creating the ingress certificates might be different in your case, depending on your settings and environment. Here is what works for me:

```bash
oc delete secret -n openshift-ingress ingress-cert --ignore-not-found=true
oc create secret tls ingress-cert \
  --cert=certs/apps.full.pem \
  --key=certs/apps.key \
  -n openshift-ingress
oc patch ingresscontroller.operator default \
  --type=merge -p \
  '{"spec":{"defaultCertificate": {"name": "ingress-cert"}}}' \
  -n openshift-ingress-operator
```

## Lessons learned

Maybe this helps you, and saves you a few minutes. I might help me in the future :-)
