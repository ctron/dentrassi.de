---
id: 621
title: 'Programmatically adding a host key with JSch'
date: '2015-07-13T18:18:29+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=621'
permalink: /2015/07/13/programmatically-adding-a-host-key-with-jsch/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Java
    - jsch
    - ssh
---

This article explains how to programmatically add a host key in Java with JSch. I did update the article early 2018, taking care of the missing argument to the `add` method.

<!-- more -->

Every now and then you stumble over an issue which seems easy in the beginning, but turns out to be something out of the ordinary.

For example establishing an SSH connection to a Linux server using Java. Of course there is the [JSch](http://www.jcraft.com/jsch/) library, which is also in Eclipse Orbit. So this sounds like an ideal solution when developing with OSGi.

However pretty soon I ran into the case that I did not want to write all host keys into my “known\_hosts” file, but would like to provide the host key to each new connection which is being created. And while JSch can do a lot of things, all sample projects somehow assume you are writing a Swing application, with full user interface, re-using all existing SSH options and configuration files.

But I did want to create a server side solution, embedded in OSGi, which allows to store the username, password and hostkey in a server side data store which can then be used to establish the connection.

So initially I got an “com.jcraft.jsch.JSchException: UnknownHostKey” exception. Not very helpful since it only contains a string with the key’s fingerprint instead of the full key. Asking Google for help brings up few solutions like this one [on Stackoverflow](https://stackoverflow.com/questions/2003419/com-jcraft-jsch-jschexception-unknownhostkey).

However simply disabling the host key check was not an option. And is not a good idea in most cases.

Gladly JSch allows to programmatically add host keys. Although the approach is rather undocumented. At least it seems that way.

Creating a new Jsch instance allows to specify the location of the host keys, but also allows to add them manually:

```java
String keyString = "....";

// parse the key
byte [] key = Base64.getDecoder().decode ( keyString ); // Java 8 Base64 - or any other

JSch jsch = new JSch ();
HostKey hostKey = new HostKey ( info.getHostname (), key );

// add the host key
jsch.getHostKeyRepository ().add ( hostKey, null );
```

Basically this does the trick. The only question is, what exactly is they “keyString”. It is not the fingerprint from the exception and it is not the full line from your known hosts file, just the last segment.

So for example if your “known\_hosts” entry is:

```
|1|DvS0JwyQni+Jqoht2n8BSYQjze4=|zHORICsezHdR1nIYhqsOxrgnUe4= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAwht8wWW+cqmGJa5KrgfgydvlgHxSmlV+8oSUINSm8ix+wG87jQHz56MeaFf0F3IvxiivfvIUxBGlb05CZC1rCTfinvS7H1ktDIwVUK3gv+SGNYtGGwWbtg+oMXAevpV5pMTvDS7Ue6OUnSXGDbAxcqXBA+ApKCG5oizhyrtzOrU=
```

Then the “keyString” is:

```
AAAAB3NzaC1yc2EAAAABIwAAAIEAwht8wWW+cqmGJa5KrgfgydvlgHxSmlV+8oSUINSm8ix+wG87jQHz56MeaFf0F3IvxiivfvIUxBGlb05CZC1rCTfinvS7H1ktDIwVUK3gv+SGNYtGGwWbtg+oMXAevpV5pMTvDS7Ue6OUnSXGDbAxcqXBA+ApKCG5oizhyrtzOrU=
```

Problem solved ;-)

### Update

After I received a few comments which asked for a missing parameter of the `add` method (the original blog post only had one argument) I did re-check and also noticed a (second) required argument. I am not sure if I missed this in the original post or if the API has evolved over time. So I did check out what this parameter is about and updated the blog post accordingly.

The second argument is an instance of `UserInfo` and it if safe to pass in `null`. `UserInfo` is a callback type interface which the caller can provide in order to pass on questions from the Jsch code to the end user. In this particular case the JSch method might ask if the parent directories of the host file should be created if they don’t already exists. At the time of writing it seems safe to pass in `null` if they do exist.

If you can’t be sure that they exist, then you could create them yourself before calling the `add` method. Or create a bogus “yes” implementation of `UserInfo`. Manually ensuring that the directories do exist seems the better way to me as otherwise you wouldn’t really know to which question you would actually answer “yes” with your implementation of `UserInfo`.

If you pass in `null` and the directories do no exist, then the host key will not be added and the `add` method will silently fail.
