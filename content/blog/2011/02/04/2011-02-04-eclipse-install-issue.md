---
id: 52
title: 'Eclipse Install Issue'
date: '2011-02-04T16:25:56+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=52'
permalink: /2011/02/04/eclipse-install-issue/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:53;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - Eclipse
---

I just stumbled over a strange issue when installing an additional plugin into a fresh Eclipse installation:

```
An error occurred while collecting items to be installed<br></br>session context was:(profile=SDKProfile, phase=org.eclipse.equinox.internal.p2.engine.phases.Collect, operand=, action=).

No repository found containing: osgi.bundle,org.eclipse.team.cvs.ssh,3.2.100.I20090508-2000
```  

I was unable to add any new plugin and searching Google for help was not successful. There was an issue somewhere in the Eclipse Bugzilla that the plugin <tt>org.eclipse.team.cvs.ssh</tt> was optional and no longer installed or required. Seems that P2 thinks the somewhat required for the installation process.

<!-- more -->

But I found one hint that deactivating the option “Contact all update sites during install to find required software” helps. And it did.

![Screenshot of Eclipse Dialog](/wp-content/uploads/other_repos.png "other_repos")
