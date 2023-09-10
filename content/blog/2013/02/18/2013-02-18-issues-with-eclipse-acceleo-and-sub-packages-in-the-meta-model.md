---
id: 258
title: 'Issues with Eclipse Acceleo and sub-packages in the meta model'
date: '2013-02-18T13:30:02+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=258'
permalink: /2013/02/18/issues-with-eclipse-acceleo-and-sub-packages-in-the-meta-model/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

Today I stumbled over an issue that was unsolved in my workspace for some days now. Finally I got the time to fix it. I have a ECore meta-model which consists of three sub-packages and has no class in the main package. Generating model, edit and editor for this I had a nice start for my task. Then I wanted to generate code from this meta model and ran into a strange problem. On the console I simply got the following message when I tried to launch the Acceleo UI generator action:

`The type of the first parameter of the main template named 'generateElement' is a proxy.`

<!-- more -->

Due to some strange behaviour Acceleo was not able to read the meta-model definition when loading its templates, although the model itself was loaded fine. Trying to re-produce the issue with a new meta-model, everything seemed to work fine until I noticed the difference between my test model and the real model. The test model did have a class in the main package of the meta-model, while the real model did not. So the real model was like:

```
model
   -> sub1
       -> class1
       -> class2
    -> sub2
       -> class1
       -> class2
```

while the test model was:

```
model
   -> class1
   -> sub1
      -> class1
```

Adding a dummy class to my main package and re-generating all files (including new plugin.xml files) solved the issue with Acceleo. Although I am still not sure where the problem actually lies. It is not in the Eclipse Bugzilla: https://bugs.eclipse.org/bugs/show\_bug.cgi?id=401075
