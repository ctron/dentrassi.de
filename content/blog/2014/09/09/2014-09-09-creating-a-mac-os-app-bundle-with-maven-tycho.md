---
id: 404
title: 'Creating a Mac OS App Bundle with Maven Tycho'
date: '2014-09-09T15:09:56+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=404'
permalink: /2014/09/09/creating-a-mac-os-app-bundle-with-maven-tycho/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

Using [Maven Tycho](http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CB8QFjAA&url=http%3A%2F%2Fwww.eclipse.org%2Ftycho%2F&ei=4fgOVP23PObXyQPSr4DoDw&usg=AFQjCNGx8I2dPaFgwDailli6vmc1ufJFsg&sig2=s1I6dsQrtlAQ-2RbTq7yag&bvm=bv.74649129,d.bGQ "Maven Tycho") it is possible to build OSGi applications and therefore Eclipse RCP applications easily with Maven. Creating a ready to run product is [already described](http://git.eclipse.org/c/tycho/org.eclipse.tycho-demo.git/tree/) on [the internet](http://www.vogella.com/tutorials/EclipseTycho/article.html) a [few times](http://codeandme.blogspot.de/2012/12/tycho-build-1-building-plug-ins.html).

<!-- more -->

But what is mostly missing is, how to make an nice Mac OS X application bundle, that looks like a real Mac OS X application and not like a bunch of files extracted from a ZIP/TAR file.

Assuming you already have set up your Maven Tycho RCP build and are building products using the packaging type “eclipse-repository” here is what you need to do in addition.

Extend the configuration in the “eclipse-repository” project by calling (or enhancing the call) to:

```xml
<plugin>
  <groupId>org.eclipse.tycho</groupId>
  <artifactId>tycho-p2-director-plugin</artifactId>
  <version>${tycho-version}</version>
</plugin>
```


If you don’t have a `configuration` element for this plugin yet, then add it as a child element and configure the specific product you are building:

```xml
<plugin>
  <groupId>org.eclipse.tycho</groupId>
  <artifactId>tycho-p2-director-plugin</artifactId>
  <version>${tycho-version}</version>
  <configuration>
    <formats>
      <win32>zip</win32>
      <linux>tar.gz</linux>
      <macosx>tar.gz</macosx>
    </formats>

    <products>
      <product>
        <id>${group.id}.${artifact.id}</id>
        <rootFolders>
          <macosx>My Application.app</macosx>
        </rootFolders>
      </product>
    </products>
  </configuration>
</plugin>
```

`${group.id}` and `${artifact.id}` make up the id of your application. Which must be consistent with the `id` property in the `.product` file.

The most important thing is the configuration of the “rootFolder” for the target type Mac OS X here. It would also be possible to use the plain “rootFolder” property, but using “rootFolders” (with the “s”) it is possible to just make an alternate name for Mac OS X.

In addition to that tell the repository bundle (in the same Maven project) to generate for Mac OS X.

```xml
<plugin>
  <groupId>org.eclipse.tycho</groupId>
  <artifactId>tycho-p2-repository-plugin</artifactId>
  <version>${tycho-version}</version>
  <configuration>
    <includeAllDependencies>true</includeAllDependencies>
    <profileProperties>
      <macosx-bundled>true</macosx-bundled>
    </profileProperties>
  </configuration>
</plugin>
```

Running `maven package` will now give you a `products` folder under your output folder (normally `target`) which hosts a zipped version of your Mac OS X app bundle, which extracts to “My Application.app” and shows in the finder as “My Application”.
