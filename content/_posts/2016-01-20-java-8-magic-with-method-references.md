---
id: 738
title: 'Java 8 magic with method references'
date: '2016-01-20T10:49:24+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=738'
permalink: /2016/01/20/java-8-magic-with-method-references/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:743;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Eclipse
    - 'Java 8'
---

When you start learning a new programming language you often encounter snippets of code which you have no idea why they work. The more you learn about that programming language to more you understand and these moments become rare.

Today, after programming many years in Java, I ran into such a situation with Java 8 and was really fascinated about it.

It all started with the problem of having a `Stream<T>` and wanting to “for-each” iterate over its content. The for-each construct in Java requires to have an array or `Iterable<T>`. However `Stream<T>` does only provide an `Iterator<T>`, which is not the same.

Now there are many solutions (good and bad) out there for this problem. However [one solution](http://codereview.stackexchange.com/questions/70469/streamiterable-create-an-iterable-from-a-java-8-stream#92424 "Solution #9242") really fascinated me:

\[code language=”java”\]  
Stream&lt;String&gt; s = …;

for (String v : (Iterable&lt;String&gt;) s::iterator) {  
 …  
}  
\[/code\]

Now wait … `Stream<T>` does have a method `iterator` which returns an `Iterator<T>`. But `Iterator<T>` cannot be cast to `Iterable<T>`! And also is “`s::iterator`” not calling the method, but referencing the method.

![Screenshot of Eclipse Quick Fix for Lambda expressions](https://dentrassi.de/wp-content/uploads/eclipse_ide_java_qf_1-e1453282144943.png)

Pasting this code fragment into the Eclipse IDE helps to understand what actually happens. Pressing <kbd>Ctrl+1</kbd> on a code fragment allows to convert method references to lambda expressions and lambda expressions to anonymous classes. Quite fantastic ;-)

So, lets see how this code fragment get expanded to a lambda expression:

\[code language=”java”\]  
for ( final String v : (Iterable&lt;String&gt;)() -&gt; s.iterator () ) {  
 …  
}  
\[/code\]

And this lambda expression is equivalent to:

\[code language=”java”\]  
for ( final String v : new Iterable&lt;String&gt; () {  
 public Iterator&lt;String&gt; iterator () {  
 return s.iterator ();  
 }} ) {  
 …  
}  
\[/code\]

The last snippet is rather bloated, as inner classes have always been in Java.

The magic which is happening is done by Java 8 new features “method references” and the “functional interfaces”. A functional interface is a java interface which only has one method to implement. “default” methods don’t count. Looking at `Iterable<T>` this is the case. So an `Iterable<T>` can be implemented with a lambda expression and or method reference. But for the for-each loop, Java does not “know” what you have mind. This is where the cast comes into play. By casting the method reference to `Iterable<T>`, Java infers that an `Iterable<T>` is requires, which can be provided by the method reference to `Iterator<T>`.

But looking at `Iterable<T>` there is no `@FunctionalInterface` present?!

That is right. But `@FunctionalInterface` is not a requirement for actually being a functional interface. It only tells the compiler to fail if the interface is not. So the downside of this example is, that there is no guarantee that `Iterable<T>` will always stay a functional interface, since the authors have not committed to that using `@FunctionalInterface`.

In the end, I am not sure if this is a good solution for my original problem. But is still is a fascinating piece of code and a great idea indeed.