---
id: 633
title: 'A bit of Java 8 Optional&lt;T&gt;'
date: '2015-07-22T17:33:20+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=633'
permalink: /2015/07/22/a-bit-of-java-8-optional/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - 'Java 8'
---

For me Java 8 wasn’t a big deal … until I had to go back to Java 7. Suddenly I started missing things I started using without even realizing it. Here comes <tt>[Optional&lt;T&gt;](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html)</tt>:

<!-- more -->

Assume we have some sort of class (`Provider`) which does something and has a “getName” method. Now we also have a method in a class managing providers which returns the provider <q>by id</q>, so we pass in a string ID and get back a provider:

\[code language=”Java”\]  
static class Provider {  
 String getName () {  
 return "bar";  
 }  
}

static Provider getProvider ( final String id ) {  
 if ( "foo".equals ( id ) ) {  
 return new Provider ();  
 }  
 return null;  
}  
\[/code\]

In this simple example the manager only knows the provider “foo”, which will return “bar” as its name. All requests for other providers will return `null`. A real life scenario might have a `Map`, which also returns `null` in case of a missing element.

Now a pretty common code snippet before Java 8 would look like this:

\[code language=”Java”\]  
final Provider provider = getProvider ( "bar" );  
final String value;  
if ( provider != null ) {  
 value = provider.getName ();  
} else {  
 value = null;  
}  
System.out.println ( "Bar (pre8): " + value );  
\[/code\]

Pretty noisy. So the first step is to use the “Optional” type, and to guarantee that the `getProvider` method never returns `null`. So we don’t have to check for it:

\[code language=”Java”\]  
static Optional&lt;Provider&gt; getOptionalProvider ( final String id ) {  
 return Optional.ofNullable ( getProvider ( id ) );  
}  
\[/code\]

In this case a new method was added, which simply calls the old one. The next thing is to use <tt>[Optional.map(…)](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html#map-java.util.function.Function-)</tt> and <tt>[Optional.orElse(…)](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html#orElse-T-)</tt> to transform the value and return a default if we don’t have a value.

\[code language=”Java”\]  
String value1 = getOptionalProvider ( "foo" )  
 .map ( Provider::getName )  
 .orElse ( null );  
System.out.println ( "Foo: " + value1 );  
\[/code\]

Pretty simple actually. But still readable and understandable (although some people might disagree on that one ;-) ).

So what does happen? First the call to `getOptionalProvider` will now *never* return `null`. If the value itself would be `null`, it would return an empty `Optional` but still a class instance. Actually always the same, since there is only one instance of an empty `Optional`. Next the `map` method will call the provided expression (longer version would be: `value -> value.getName()`), but the method will only do this if the Optional is not empty. Otherwise it will return an empty Optional again. So after calling `map` we either have an Optional&lt;String&gt; with the value of `getName()`, or again an empty Optional. Calling `orElse` on this new `Optional` will either return the value of the `Optional` or the default value provided, `null` in this case.

Of course one could argue that internally the same logic happens as with Java 7 and before. But I think that this way, you actually can do a <q>one-liner</q> which is understandable but still does not obstruct the your actual class with to many lines of code just or checking about `null`.

Full sample:  
\[code language=”Java”\]  
import java.util.Optional;

public class Manager  
{

 static class Provider  
 {  
 String getName ()  
 {  
 return "bar";  
 }  
 }

 static Provider getProvider ( final String id )  
 {  
 if ( "foo".equals ( id ) )  
 {  
 return new Provider ();  
 }  
 return null;  
 }

 static Optional&lt;Provider&gt; getOptionalProvider ( final String id )  
 {  
 return Optional.ofNullable ( getProvider ( id ) );  
 }

 public static void main ( final String\[\] args )  
 {  
 final String value1 = getOptionalProvider ( "foo" ).map ( Provider::getName ).orElse ( null );  
 System.out.println ( "Foo: " + value1 );

 final String value2 = getOptionalProvider ( "bar" ).map ( Provider::getName ).orElse ( null );  
 System.out.println ( "Bar: " + value2 );

 // before Java 8

 final Provider provider = getProvider ( "bar" );  
 final String value3;  
 if ( provider != null )  
 {  
 value3 = provider.getName ();  
 }  
 else  
 {  
 value3 = null;  
 }  
 System.out.println ( "Bar (pre8): " + value3 );  
 }  
}  
\[/code\]
