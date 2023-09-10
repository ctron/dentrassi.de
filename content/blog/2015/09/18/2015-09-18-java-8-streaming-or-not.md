---
id: 673
title: 'Java 8 streaming – or not?'
date: '2015-09-18T15:35:50+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=673'
permalink: /2015/09/18/java-8-streaming-or-not/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Java
    - 'Java 8'
---

One of the most advertised use cases of the new lambdas in Java 8 is the possibility to <q>stream</q> collections and transform it. The “series of tubes” has a lot of examples on how to do this, I just wanted to look at it from a different perspective, readability.

<!-- more -->

So starting with a real-life problem of a map `Map<ResultKey, List> result` which I want to transform into a `Set<String>`.

Before Java 8, I had something like:

\[code language=”java”\]  
Set&lt;String&gt; ids = new HashSet&lt;&gt; ();  
for ( List&lt;ResultEntry&gt; list : result.values () ) {  
 for ( ResultEntry entry : list ) {  
 if ( entry.getAction () == Action.DELETE ) {  
 String id = entry.getArtifact ().getId ();  
 ids.add ( id );  
 }  
 }  
}  
\[/code\]

Now, with Java 8, I can do:

\[code language=”java”\]  
Set&lt;String&gt; deleteSet = result.values ().stream ()  
 .flatMap ( list -&gt; list.stream () )  
 .filter ( entry -&gt; entry.getAction () == Action.DELETE )  
 .map ( entry -&gt; entry.getArtifact ().getId () )  
 .collect ( Collectors.toSet () );  
context.deleteArtifacts ( deleteSet );  
\[/code\]

Neither one is shorter nor seems less complex from an initial view. So, which one is <q>better</q>?
