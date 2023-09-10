---
id: 36
title: 'Equinox Remote Terminal Console'
date: '2010-02-25T18:54:26+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=36'
permalink: /2010/02/25/equinox-remote-terminal-console/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
tags:
    - Eclipse
    - Equinox
    - Java
    - OSGi
---

Although Equinox offers some sort of remote TCP console it is not what you actually want to have. Being limited to one session, having not authentication and allowing the user to execute any command and shut down the OSGi container is not an option for a productive system.

In OpenSCADA we faced the same problem so we simply developed an OSGi Remote Console based on Apache Mina.

Our equinox console works around the limits of the original OSGi TCP console and can simply be dropped in as a replacement.

SVN Link to the project: <http://pubsvn.inavare.net/openscada/modules/aurora/trunk/org.openscada.osgi.equinox.console/>

Also we played a little bit with an IRC bot that exposes the OSGi console of Equinox to an IRC server. This is not really tested and just a proof of concept. But it works. If you like check out <http://pubsvn.inavare.net/openscada/modules/aurora/trunk/org.openscada.osgi.equinox.ircbot/> and play with it ;-)
