---
id: 440
title: 'Spring WebMVC &#8211; Bad request for most pages'
date: '2014-11-21T13:21:29+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=440'
permalink: /2014/11/21/spring-webmvc-bad-request-for-most-pages/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

Today I stumbled over an easy configuration mistake you can make, which will cause “400 Bad request” for most static resources. It took me a little bit of time to figure out what went wrong.

I had a classic Spring WebMVC setup, DispatcherServlet, resource mapping for static resources (CSS mostly).

After making a few changes all CSS files started to have “400 Bad request”. Which was strange, since these were only static resources. Bad request sounded like something went wrong in the Jetty that I used. So I started debugging into this issue.

It turned out that all requests were directed to my newly added @Controller class that already was active in the Spring context. It’s handler method was causing the “400” error. By why for all CSS files?

It was a missing “value” property in the @RequestMapping annotation. I had:

\[code language=”Java”\]  
@Controller  
public class ArtifactController {  
 @RequestMapping ( name = "/artifact/{artifactId}/get", method = RequestMethod.GET )  
 public void get ( HttpServletResponse response,  
 @PathVariable ( "artifactId" ) String artifactId ) {  
 final StorageService service = Activator.getTracker ().getStorageService ();  
 }  
}  
\[/code\]

Where it should have been:

\[code language=”Java”\]  
@Controller  
public class ArtifactController {  
 @RequestMapping ( value = "/artifact/{artifactId}/get", method = RequestMethod.GET )  
 public void get ( HttpServletResponse response,  
 @PathVariable ( "artifactId" ) String artifactId ) {  
 final StorageService service = Activator.getTracker ().getStorageService ();  
 }  
}  
\[/code\]

**Note:** the @RequestMapping attribute should have been “value” instead of “name”.