---
id: 3781
title: 'Manually reclaiming a persistent volume in OpenShift'
date: '2017-11-27T11:01:08+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3781'
permalink: /2017/11/27/manually-reclaim-persistent-volume-in-openshift/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - Infrastructure
    - 'Technical Stuff'
tags:
    - OpenShift
---

When you have a persistent volume in OpenShift configured with “Retain”, the volume will switch to “Released” after the claim has been deleted. But what now? How to manually recycle it? This post will give a brief overview on how to manually reclaim the volume.

<!-- more -->

### Deleting the claim

Delete the persistent volume *claim* in OpenShift is simple, either using the Web UI or by executing:

```bash
$ oc delete pvc/my-claim
```

If you check, then you will see the persistent volume is “Released” but not “Available”:

```
$ oc get pv
NAME              CAPACITY   ACCESSMODES   RECLAIMPOLICY   STATUS     CLAIM                         REASON    AGE
my-pv             40Gi       RWO           Retain          Released   my-project/my-claim                     2d
```

### What the documentation tells us

The [OpenShift documentation](https://docs.openshift.org/latest) states:

> By default, persistent volumes are set to Retain. NFS volumes which are set to Recycle are scrubbed (i.e., rm -rf is run on the volume) after being released from their claim (i.e, after the user’s PersistentVolumeClaim bound to the volume is deleted). Once recycled, the NFS volume can be bound to a new claim.

At a different location it simply says:

> Retained reclaim policy allows manual reclamation of the resource for those volume plug-ins that support it.

But how to actually do that? How to manually reclaim the volume?

### Reclaiming the volume

First of all ensure that the data is actually deleted. Using NFS you will need to manually delete the content of the share using e.g. `rm -Rf /exports/my-volume/*`, but the be sure to the keep the actual export directory in place.

Now it is time to actually make the PV available again for being claimed. For this the reference to the previous claim (`spec/claimRef`) has to be removed from the persistent volume. You can manually do this from the Web UI or with short command from the shell (assuming you are using `bash`):

```
$ oc patch pv/my-pv --type json -p $'- op: remove\n  path: /spec/claimRef'
"my-pv" patched
```

This should return the volume into state “Available”:

```
$ oc get pv
NAME              CAPACITY   ACCESSMODES   RECLAIMPOLICY   STATUS     CLAIM                         REASON    AGE
my-pv             40Gi       RWO           Retain          Available  my-project/my-claim                     2d
```
