---
id: 647
title: 'Maven Tycho/JGit based build timestamps and the `target` directory'
date: '2015-07-28T09:39:20+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=647'
permalink: /2015/07/28/maven-tychojgit-based-build-timestamps-and-the-target-directory/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Java
    - maven
    - OSGi
    - tycho
---

Now when you build OSGi bundles using Maven [Tycho](https://eclipse.org/tycho/), you probably ran into the issue of creating a meaningful version qualifier (remember, an OSGi versions always is `major.minor.micro.qualifier`, so no dash and definitely no `-SNAPSHOT`).

There are a few approaches ranging from fully manual assignment of the build qualifier, simple timestamps and timestamps based on the last Git change.

<!-- more -->

## The background

The latter one is described in the [“Reproducible Version Qualifiers”](https://wiki.eclipse.org/Tycho/Reproducible_Version_Qualifiers) wiki page of Tycho as a recipe to create the same qualifier from the same source code revision.

Actually the idea is pretty simple, so instead of the current timestamp, the last relevant change in the git repository, for the directory of the bundle, is located and then used to generate the timestamp based qualifier.

As a side note: Personally I came to the conclusion, that this sounds great in the beginning, but turns out to be troublesome later. First if all, the Build Qualifier plugin conflicts with the Source Ref Plugin, which generates a different manifest. Both plugins find different <q>last commits</q> and therefore a different <tt>MANIFEST.MF</tt> gets generated. So two builds produce two bundles, with the same qualifier, but actually (due to the <tt>MANIFEST.MF</tt>) different content, with two different checksums, which causes issues later on and has to be cleaned up by some <q>baseline</q> repository matching. In addition you simple cannot guarantee that two different builds come to the same result. Too many components (actually Maven and the local host) are outside of the source code repository and still influence the output of the build. But this post is about the JGit based timestamps ;-)

A simple configuration using the Git based approach looks like this in the parent <tt>pom</tt> file:  

```xml
<plugin>
  <groupId>org.eclipse.tycho</groupId>
  <artifactId>tycho-packaging-plugin</artifactId>
  <version>${tycho.version}</version>
  <dependencies>
    <dependency>
      <groupId>org.eclipse.tycho.extras</groupId>
      <artifactId>tycho-buildtimestamp-jgit</artifactId>
      <version>${tycho-extras.version}</version>
    </dependency>
  </dependencies>
  <configuration>
    <timestampProvider>jgit</timestampProvider>
    <jgit.ignore>
    pom.xml
    </jgit.ignore>
  </configuration>
</plugin>
```

As you can see, there is a configuration property `jgit.ignore` which allows to exclude a set of files in the search of the last relevant commit. So git changes, which are only changing files which are ignored, are also ignored in this search for the last modification timestamp. Since the <tt>pom.xml</tt> will probably just get changed to point to a different parent POM, this seems like a good idea.

## The problem

Now what does happen, when there are uncommitted changes in the working tree? Then it would not be possible for the build to determine the last relevant commit, since the change is not committed! Maven Tycho does provide a way to handle this (aka “Dirty working tree behaviour”) and will allow you to ignore this. Which might not be a good idea after all. The default behavior is to simply error and fail the build.

For me it became a real annoyance when it complained about the “<tt>target</tt>” directory itself. The truth is, this output directory should be added to the “<tt>.gitignore</tt>” file anyway, which would then also be respected by the git based build timestamp provider. But then again it should not fail the build just because of that.

## Solution

But the solution to that was rather trivial. The <tt>jgit.ignore</tt> property follows the [git ignore syntax](https://git-scm.com/docs/gitignore) and also allows to specify directories:

```xml  
<jgit.ignore>
pom.xml
target/
</jgit.ignore>
```

There are two things which have to be kept in mind: each entry goes to a new line, the root of the evaluation seems no the be the root of the project, so using “<tt>/target/</tt>” (compared to “<tt>target/</tt>“) does not work.
