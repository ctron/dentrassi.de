---
id: 4281
title: 'Changing the owner of an OpenShift project'
date: '2019-07-29T16:56:50+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4281'
permalink: /2019/07/29/changing-the-owner-of-an-openshift-project/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4286";s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4286";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/Logotype_RH_OpenShift_wLogo_RGB_Black_wordpress.png
taxonomies:
  categories:
    - Infrastructure
    - 'Technical Stuff'
  tags:
    - OpenShift
---

Today I wanted to change the owner of an OpenShift project. It actually is rather trivial. However finding out how, wasn’t so easy. Googling didn’t help much, and also the documentation has room for improvement. So I took a few minutes to document how it works.

<!-- more -->

## Pre-requisites

Of course you need to start with a user that already has access to the project. I will assume that you have the `oc` command installed, and are logged on to your cluster. Also I will assume that your new user is `newuser` and the project name is `test`.

## Making the change

The access to the project is tied to the cluster role `admin` for the project. Each project has a “role binding” (not a “cluster role binding”) named `admin`, which binds the “cluster role” `admin` to the user, for a specific project.

Assuming that the user `admin` created the project `test`, doing `oc -n test rolebinding admin -o yaml` would give you:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin
  namespace: test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: admin
```

Now you can simply replace (or add) the subject in the `subjects` list. Moving the project over to `newuser` would look like this:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin
  namespace: test
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: newuser
```

## The one liner

The `oc` command line tool can actually do this for you with a single call:

```bash
oc policy add-role-to-user admin newuser -n test
```

Of course this only adds the new user, but you can also remove the old user by:

```bash
oc policy remove-role-from-user admin olduser -n test
```

## One more thing

When you take a look at the list of projects in the Web UI, you will still see the old user as the “requester”:

![Web UI project list](https://dentrassi.de/wp-content/uploads/ocp_projects_test.png)

This information is read from the annotation `openshift.io/requester` from the “project”:

```yaml
apiVersion: project.openshift.io/v1
kind: Project
metadata:
  annotations:
    openshift.io/description: ""
    openshift.io/display-name: ""
    openshift.io/requester: admin
  name: test
…
```

Unfortunately OpenShift considers the project information immutable. However the OpenShift “project” is backed by the Kubernetes “namespace”, which has the same annotation and it allows editing. So you can change the “requester” there, and it will be reflected in the project as well.
