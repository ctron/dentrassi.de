---
id: 47
title: 'Name that pattern'
date: '2011-01-28T10:50:27+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=47'
permalink: /2011/01/28/name-that-pattern/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
---

In my day-to-day work, I encounter several interesting programming patterns that I don’t have a name for. Maybe you have?! So name the following pattern:

<!-- more -->

```java  
if ( !trans.getWeights ().isEmpty () ) {
 final Collection<Weight> weightList = trans.getWeights ();  
 WeightVo weightVo = null;  
 for (final Weight weight : weightList) {
   weightVo = getWeightDao ().toWeightVo ( weight );  
   break;  
 }
 truckVo.setWeightVo ( weightVo );  
}
```

While one can argue if this one-liner is more readable and understandable:

```java  
truckVo.setWeightVo ( trans.getWeights().isEmpty() ? null : getWeightDao ().toWeightVo ( trans.getWeights().get(0) ));  
```

The following definitely is:

```java  
if ( !trans.getWeights ().isEmpty () ) {
 truckVo.setWeightVo ( getWeightDao ().toWeightVo ( trans.getWeights().get(0) ) );  
}  
```
