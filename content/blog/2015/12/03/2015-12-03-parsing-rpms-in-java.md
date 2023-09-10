---
id: 699
title: 'Parsing RPMs in Java'
date: '2015-12-03T21:36:52+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=699'
permalink: /2015/12/03/parsing-rpms-in-java/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:3:"701";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/RPM_Logo.svg_.png
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Eclipse
    - 'Package Drone'
    - RPM
---

![RPM](https://dentrassi.de/wp-content/uploads/RPM_Logo.svg_.png)The core idea of [Package Drone](http://packagedrone.org) is to extract meta data from files and generated some sort of repository index. And although Package Drone’s main focus is on OSGi, we did want to implement a YUM repository adapter and for this we needed to extract metadata from RPM files.

<!-- more -->

Package Drone itself is written in Java. So I wanted some sort of Java approach. Of course it would be possible to run the `rpm` command in the background, parse the output somehow and gather the meta data information from that. Or make a JNI wrapper to `librpm` and extract the information with a native library call. However this is not only prone to error, but also a nightmare when it comes to porting.

So I really was looking for a plain Java solution, which also was compatible with the license of Eclipse (EPL). I came across [jRPM](http://jrpm.sourceforge.net/) and [redline](https://github.com/craigwblake/redline).

jRPM was last updated around 2005, still has an Apache 1.1 license and simply stuck in the past. redline is more up to date and sounded promising at first, but then the library is really more like a jar file with some “main” entry points and an ant task. There is no clear API for programmatically reading the RPM files. And the legal aspect was a little bit troublesome to me. 28 contributors according to GitHub, no CLA, an “MIT license” from a company simple named “FreeCompany” and the Google Tracking code backed right into the Maven POM file. So, I had to do it myself ;-)

## A fresh start

So not to fall into the same pitfalls, I did start to write a parsing library first, instead of directly writing the Package Drone extractor module. This way there is now a clean library which can parse RPM files. It also is an OSGi bundle, which was necessary for Package Drone, but does not make use of any OSGi functionality. So it still can be used as a simple JAR file. Licensed under the EPL, as requirement for Eclipse projects anyway and the Eclipse CLA and IP process to take care of the legal aspects. And if you are an Eclipse project, you even don’t need a CQ to use it.

## What’s the catch?

I did implement what I needed. And that was reading RPM metadata and building a YUM repository index. So writing RPM files or reading/writing signatures is not possible at the moment. However there are plans to sign YUM repositories and RPM files as well. So this limitation is only a matter of time. Also are there some fields which are not mapped to enums. RPM used numeric IDs internally, many are mapped, but not all. You can still access those, but by number not by enum in that case.

Also is this library currently not on maven central. But again, I am also working an a “deploy to Maven Central” feature in Package Drone, which will clear that blocker.

## So where are we now?

So the code is [right here](https://github.com/eclipse/packagedrone/tree/master/bundles/org.eclipse.packagedrone.utils.rpm) on GitHub. In a few weeks we will have a binary download, but right now the Eclipse IP process has to clear the way first.

Looking at the [source code of the test case](https://github.com/eclipse/packagedrone/blob/master/bundles/org.eclipse.packagedrone.utils.rpm.tests/src/org/eclipse/packagedrone/utils/rpm/tests/InputStreamTest.java) you can see how this library works. Instead of working on a plain [File](https://docs.oracle.com/javase/8/docs/api/java/io/File.html), it can work on an [InputStream](https://docs.oracle.com/javase/8/docs/api/java/io/InputStream.html), which can be important if your RPM file comes from a remote location.

The following example shows how to extract metadata and content from an RPM file.

\[code language=”java”\]  
try(RpmInputStream in = new RpmInputStream(new FileInputStream("file.rpm"))) {  
 String name = (String)in.getPayloadHeader ().getTag (RpmTag.NAME);

 CpioArchiveInputStream cpio = in.getCpioStream ();  
 CpioArchiveEntry entry;  
 while ((entry = cpio.getNextCPIOEntry ()) != null) {  
 process ( entry );  
 }  
}  
\[/code\]

There is also the [older JavaDoc](http://doc.packagedrone.org/javadoc/de/dentrassi/rpm/package-summary.html), which has to be updated to reflect the change to `org.eclipse.packagedrone`.

## What’s next?

Of course a binary release at Eclipse, an updated JavaDoc and publishing the binaries to Maven Central. Beside extending the library to be able to sign and write RPM files.

If you like to help or need some help using it, just let me know!
