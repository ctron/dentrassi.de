---
id: 383
title: 'APT Repository'
date: '2014-03-31T12:30:33+02:00'
author: 'Jens Reimann'
layout: page
guid: 'http://dentrassi.de/?page_id=383'
---

A mojo which creates APT repositories from a set of .deb files.

<!-- more -->

This mojo can create an [APT repository](https://en.wikipedia.org/wiki/Advanced_Packaging_Tool) based on an input directory of .deb files.

There are a number of other tools out there that can do the same task. “apt-repo” was created since:

- It can created multi component APT repositories (non-flat)
- It runs on plain java
- It can be used as Maven Mojo and plain jar library

More information:

- Documentation of the Maven Plugin – [/apt-repo-doc](/apt-repo-doc)
- github – <https://github.com/ctron/apt-repo>
- Travis CI – [![](https://travis-ci.org/ctron/apt-repo.svg?branch=master)](https://travis-ci.org/ctron/apt-repo)

Adding the mojo to you maven build:

\[code language=”xml”\]  
&lt;dependency&gt;  
 &lt;groupId&gt;de.dentrassi.build&lt;/groupId&gt;  
 &lt;artifactId&gt;apt-repo&lt;/artifactId&gt;  
 &lt;version&gt;0.0.1&lt;/version&gt;  
&lt;/dependency&gt;  
\[/code\]
