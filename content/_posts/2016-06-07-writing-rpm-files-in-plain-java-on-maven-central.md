---
id: 810
title: 'Writing RPM files … in plain Java … on Maven Central'
date: '2016-06-07T15:05:44+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=810'
permalink: /2016/06/07/writing-rpm-files-in-plain-java-on-maven-central/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - Java
    - maven
    - RPM
---

A few weeks back I wrote a blog post about [writing RPM files in plain Java](https://dentrassi.de/2016/04/15/writing-rpm-files-in-plain-java/).

What was left over was the fact that the library was not available outside of Package Drone itself. Although it was created as a stand alone functionality you would need to fetch the JAR and somehow integrate it into your build.

With the recent [release of Package Drone 0.13.0](https://packagedrone.org/2016/06/06/package-drone-0-13-0-released/) I was finally able to officially push the module to [Maven Central](https://search.maven.org/#artifactdetails|org.eclipse.packagedrone|org.eclipse.packagedrone.utils.rpm|0.13.0|jar).

\[code language=”xml”\]  
&lt;dependency&gt;  
 &lt;groupId&gt;org.eclipse.packagedrone&lt;/groupId&gt;  
 &lt;artifactId&gt;org.eclipse.packagedrone.utils.rpm&lt;/artifactId&gt;  
 &lt;version&gt;0.13.0&lt;/version&gt;  
&lt;/dependency&gt;  
\[/code\]

In the meanwhile I did work on a [Maven RPM builder plugin](https://dentrassi.de/2016/04/26/building-rpms-on-any-platform-with-maven/), which allows creating RPM files on any platform. The newest version (0.5.0) has been released today as well, which already uses the new library.

So working with RPM files just got a bit easier ;-)