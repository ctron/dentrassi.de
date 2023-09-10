---
id: 625
title: 'IAdapterFactory with generics'
date: '2015-07-17T12:37:00+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=625'
permalink: /2015/07/17/iadapterfactory-with-generics/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Eclipse
    - OSGi
    - RCP
---

Now I have been working with the Eclipse platform for quite a while. If you do so, you already might have run into the “adaptable” mechanism the Eclipse platform provides ([article on EclipseZone](http://www.eclipsezone.com/articles/what-is-iadaptable/)).

## The basics

The basic idea is to “cast” one object into the class of another, allowing to step into the process and maybe return a new object instance if casting is not possible, so adapting to the requested interface. This is nothing new, but comes in handy every now and then. Especially since the Eclipse platform allows an “external” adapter mechanism to control this adaption process. Simply assume you do have a class “MyModelDocument”, which is used throughout your Eclipse application. Now somebody selects the UI element, backed by an instance of your class and you want the Eclipse UI to show the properties of your instance in the Eclipse properties view. This is done by an instance of [IPropertySource](http://help.eclipse.org/mars/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fui%2Fviews%2Fproperties%2FIPropertySource.html). At first this would mean you need you class to implement `IPropertySource` and do this for every other aspect you want to add to your model. In addition of implementing the interface you would also aggregate a lot of dependencies in the bundle of your model.

But there is a better way thanks to the adapter framework. First of all your class “MyModelDocument” can use the adapter framework and simply create and adapter class, which has to implement IPropertySource, but is backed by the original instance of your “MyModelDocument” class. Second, you can create a new bundle/plugin which defines an [extension point named “org.eclipse.core.runtime.adapters”](http://help.eclipse.org/mars/topic/org.eclipse.platform.doc.isv/reference/extension-points/org_eclipse_core_runtime_adapters.html?cp=2_1_1_26) and implement a class based on [IAdapterFactory](http://help.eclipse.org/mars/topic/org.eclipse.platform.doc.isv/reference/api/org/eclipse/core/runtime/IAdapterFactory.html).

## Generics

Now a typical implementation of this class in Java 5+ looked like this:

\[code language=”Java”\]  
public class MyAdapterFactory implements IAdapterFactory {  
 @SuppressWarnings ( "unchecked" )  
 @Override  
 public Object getAdapter (  
 final Object adaptableObject,  
 final Class adapterType ) {

 if ( !(adaptableObject instanceof MyModelDocument) ) {  
 return null;  
 }

 if ( IPropertySource.class.equals ( adapterType ) ) {  
 return new MyModelDocumentPropertySourceAdapter ( adaptableObject );  
 }

 return null;  
 }

 @SuppressWarnings ( "unchecked" )  
 @Override  
 public Class\[\] getAdapterList () {  
 return new Class\[\] { IPropertySource.class };  
 }  
}  
\[/code\]

Of course the `@SuppressWarnings` for “unchecked” could be left out, but would trigger a bunch of warnings. The cause simply was that `IAdapterFactory` did not provide make use of Java 5 generics.

In a recent update of the Eclipse platform this interface has been extended to allow the use of generics, the method `Object getAdapter (…)` is now `<T> T getAdapter(…)`. While this does not really benefit implementations of the class itself (IMHO), it cleans up the warnings if you do it right ;-)

Keep in mind that the type parameter `<T>` is a complete variable thing for the factory itself, since it will allow adapting to any kind if type some other class requests. So you actually will never be able to make a specific substitution for `<T>`. The return type of `getAdapter()` will change to `T`, which requires you to actually cast to `T`. Which can be done in two ways. Either by casting using:

\[code language=”Java”\]  
return (T)new MyModelDocumentPropertySourceAdapter ( adaptableObject );  
\[/code\]

Which will trigger the next warning right away. Since there is no way to actually do the cast. Type erasure will kill the type information during runtime! The way to work around this has always been in Java to actually pass the type in such situations. Like a `TypedQuery` in JPA, the `IAdapterFactory` already has the type information as a parameter an so you can a programmatic cast instead:

\[code language=”Java”\]  
return adapterType.cast ( new MyModelDocumentPropertySourceAdapter ( adaptableObject ) );  
\[/code\]

So the full code would look like:  
\[code language=”Java”\]  
public class MyAdapterFactory implements IAdapterFactory {  
 @Override  
 public &lt;T&gt; T getAdapter (  
 final Object adaptableObject,  
 final Class&lt;T&gt; adapterType ) {

 if ( !(adaptableObject instanceof MyModelDocument) ) {  
 return null;  
 }

 if ( IPropertySource.class.equals ( adapterType ) ) {  
 return adapterType.cast (  
 new MyModelDocumentPropertySourceAdapter ( adaptableObject )  
 );  
 }

 return null;  
 }

 @Override  
 public Class&lt;?&gt;\[\] getAdapterList () {  
 return new Class&lt;?&gt;\[\] { IPropertySource.class };  
 }  
}  
\[/code\]