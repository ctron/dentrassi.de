---
id: 49
title: 'Workaround for LoadTimeWeaver issue with JBoss 6 and Spring 3'
date: '2011-02-01T11:21:12+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=49'
permalink: /2011/02/01/workaround-for-loadtimeweaver-issue-with-jboss-6-and-spring-3/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - AspectJ
    - Java
    - JBoss
    - Spring
---

A possible workaround for the LTW issue that appeared in JBoss 6 using Spring 3 ([SPR-7887](https://jira.springsource.org/browse/SPR-7887 "SPR-7887")) is to add an empty <tt>jboss-scanning.xml</tt> file to EAR *and* WAR files.

<!-- more -->

The reason to this issue as explained by [one comment](https://jira.springsource.org/browse/SPR-7887?focusedCommentId=62866&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#action_62866) that JBoss pre-loads classes when scanning for annotations. Which triggers the class loader before Spring has a chance to add the AspectJ transformer to the class loader. The LTW support of Spring loads fine but *after* all classes are loaded.

Adding the empty <tt>jboss-scanning.xml</tt> to EAR and WAR files will skip the scanning for the modules and trigger the transformer later.

Example for <tt>jboss-scanning.xml</tt>:

```xml  
<?xml version="1.0" encoding="UTF-8"?>

<scanning xmlns="urn:jboss:scanning:1.0">  
</scanning>  
```

Thanks to Marius Bogoevici and Costin Leau for looking into this issue.
