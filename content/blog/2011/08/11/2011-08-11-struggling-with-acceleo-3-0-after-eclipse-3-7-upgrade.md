---
id: 111
title: 'Struggling with Acceleo 3.0 after Eclipse 3.7 upgrade'
date: '2011-08-11T09:46:04+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=111'
permalink: /2011/08/11/struggling-with-acceleo-3-0-after-eclipse-3-7-upgrade/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:112;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

While the upgrade from Eclipse 3.6.2 to 3.7 went without nearly any trouble the upgrade of the Acceleo plugins to the versions provided with Eclipse Indigo was “a little bit more” problematic.

<!-- more -->

Starting the generator after the upgrade simply brought up:

```
Exception in thread "Main Thread" org.eclipse.acceleo.engine.AcceleoEvaluationException: The type of the first parameter of the main template named 'myTemplate' is a proxy.
    at org.eclipse.acceleo.engine.service.AcceleoService.doGenerate(AcceleoService.java:507)
    at org.eclipse.acceleo.engine.service.AbstractAcceleoGenerator.generate(AbstractAcceleoGenerator.java:175)
    at org.eclipse.acceleo.engine.service.AbstractAcceleoGenerator.doGenerate(AbstractAcceleoGenerator.java:154)
...
```

The main template did not accept the model anymore. Although everything was registered and working with the previous version.

Googling a bit I found out that Acceleo provides a different serialization model which stores models in binary form instead of XMI. Since all my models I flipped the switch in the project settings:

<figure aria-describedby="caption-attachment-112" class="wp-caption alignnone" id="attachment_112" style="width: 625px">

{% figure(caption="Acceleo Project Settings") %}
![](/wp-content/uploads/acceleo.png "Acceleo Project Settings")
{% end %}

Which worked at first until I stumbled over the next problem a few hours later:

```
org.eclipse.acceleo.engine.AcceleoEvaluationException: Invalid loop iteration at line 18 in Module myModule for block for (myObject.null). Last recorded value of self was com.thfour.config.model.model.impl.MyObjectImpl@81b69bf (....).
    at subModule.subModule(null)(subModule.mtl:18)
    at subModule.subModule(null)(subModule.mtl:6)
    at subModule.subModule(null)(subModule.mtl:4)
    at module.module(MyObject)(module.mtl:0)
    at module.module(MyObject)(module.mtl:7)
```

After some debugging it seemed as if the main module could not pass a model object to a template that is located in another bundle. We have structured our model generator to have a common part and a project specific bundle. At first, it looked like as it this stopped working by an unknown reason.

After some testing, flipping switches, debugging, restructuring I found out that the solution was rather simple. The same switch (Binary, XMI) has to be set to the common generator module as well. All modules must agree to a model format (either binary or XMI).

While I can understand this for the generator that is launched, I cannot understand this for submodules that provide common generating templates and should not even care about the serialization form. But it is as it is ;-)
