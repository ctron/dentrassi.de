---
id: 594
title: 'OSGi + JSP + JSTL'
date: '2015-06-18T16:57:29+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=594'
permalink: /2015/06/18/osgi-jsp-jstl/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - OSGi
---

What is so easy with a standard JEE setup becomes quite painful using OSGi. Although there are very interesting projects and approaches like [OSGi enRoute](http://enroute.osgi.org), [Pax Web](https://github.com/ops4j/org.ops4j.pax.web) or [Equinox JSP](http://eclipse.org/equinox/server/jsp_support.php) (and probably a few more), taking a step beyond “Hello World” starts to get quite painful.

OSGi has had support for registering servlets for quite a while. And it becomes even smoother using the HTTP whiteboard approach. But writing a servlet is, in most cases, not what you actually want. It is more like wiring method calls, service methods calls, to URLs, finally rendering it to HTML. Looking at the [Spring WebMVC framework](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html), this can be as easy as annotating a class with some `@Controller` annotation, returning a redirect to a JSP page.

Living in OSGi land, this sounds even better. Dynamically registering and referencing controllers and services. Configuring the application on the fly, during runtime, a dream come true.

Pretty soon its gets quite frustrating from there on. Equinox JSP is not too bad, but suffers from the Equinox HTTP service implementation which has a few bugs and drawbacks. Pax Web is fine, but the whiteboard pattern, although the same name, has nothing to do with OSGi HTTP whiteboard. Most other tutorials around OSGi and HTTP focus on registering a servlet. Since this is pretty much the standard specification right now. Everything around JSP is self made for each framework and mostly works around issues in Apache Jasper. Since Jasper seems to be the only JSP implementation, but it is so deeply tied to JEE, that it is really hard to use it in a different environment. So most tools simply wrap classloaders and tweak “getResource” methods in order to let Jasper think it is in an JEE environment.

Looking at what other JEE applications do, it really seems that everybody does use Jasper. In different patched versions. Tomcat of course, JBoss (aka Wildfly), Glassfish an Geronimo. Also Equinox JSP and Pax Web have their own wrapped and patched Jasper version.

Now it comes to JSTL, sure, you want to have all the fuzz when you develop JEEish applications. Pax Web really does consider looking up dependent bundles for tag libraries. Where Equinox JSP only scans the “Bundle-ClassPath” jars. Apache Jasper however simply ignores the “core” JSTL tag library, although it might get detected on the class path.

Now the good point is, it’s OSGi, and with a little bit of effort you can throw different frameworks together into one pot. Taking Equinox as OSGi framework, Pax Web for providing the Http Service, Equinox JSP for a non-intrusive JSP servlet and a little bit of custom code for the Spring MVC controller like framework, [Package Drone](http://packagedrone.org) got a nice little web framework. The JSTL tags are provided by JBoss JSTL, which feature a OSGi version of the tags.

While the simple servlets are plain Pax Web registrations, including the Equinox JSP servlet, the Spring MVC like setup is a custom part of Package Drone, but with some reusability in mind. A main dispatcher servlet picks up all services which are registered with a @Controller annotation. Calls are simply routed to service methods. The result is a reference to a JSP page, which now actually is part of the controller bundle and not the servlet. The dispatcher mechanism takes care of this an on the one side alters the redirection to the JSP so that the bundle is part of the redirect path, and on the other side registers all relevant JSP resources in a bundle with the JSP servlet of Equinox JSP.

I took quite a while and cost some nerves … but it seems that the next version of Package Drone will have a web framework which is based on OSGi HttpService, supports controller style services and still feels a bit like JEE ;-)