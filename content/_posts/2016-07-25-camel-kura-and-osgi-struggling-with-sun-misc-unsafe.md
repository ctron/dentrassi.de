---
id: 842
title: 'Camel, Kura and OSGi, struggling with &#8216;sun.misc.Unsafe&#8217;'
date: '2016-07-25T13:23:44+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=842'
permalink: /2016/07/25/camel-kura-and-osgi-struggling-with-sun-misc-unsafe/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:847;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - Equinox
    - OSGi
---

So here comes a puzzle for you … You do have Apache Camel (2.17), which internally uses `com.googlecode.concurrentlinkedhashmap`, which uses `sun.misc.Unsafe`. Now you can argue a lot about this is necessary or not. I just is that way. So starting up Apache Camel in an OSGi container which does strict processing of classes, using Apache Camel will run into a “java.lang.NoClassDefFoundError” issue due to “sun/misc/Unsafe”.

## The cause

The cause is rather simple. Apache Camel makes use of `sun.misc` and so it should declare that in the OSGi manifest. OSGi R6 (and version before that as well) defines in section “3.9.4” of the core specification that `java.*` is forwarded to he parent class loader, but the rest is not. So `sun.misc` will not go the parent class loader (which finally is the JVM) by default.

## Solutions

As always, there are a few. There may be a few more possible than I describe here, but I don’t want to list any which require changing Apache Camel itself.

### Fragments

<figure aria-describedby="caption-attachment-847" class="wp-caption alignright" id="attachment_847" style="width: 300px">[![Two Fragments](https://dentrassi.de/wp-content/uploads/sun_misc_1-300x67.png)](https://dentrassi.de/2016/07/25/camel-kura-and-osgi-struggling-with-sun-misc-unsafe/sun_misc_1/)<figcaption class="wp-caption-text" id="caption-attachment-847">Two Fragments</figcaption></figure>OSGi fragments are a way to enhance an already existing OSGi bundle. So the kind of merge in into the bundle. So it is possible to create a fragment for Apache Camel which does `Import-Package: sun.misc`. This should quickly resolve the issue as long as the bundle is installed into you OSGi container at the same time Apache Camel is, so that it is available at the time Apache Camel is started. The host bundle has to be `org.apache.camel.camel-core`, since this is the bundle requiring `sun.misc.Unsafe`.

Of course this brings up the next issue, there is nobody who exports `sun.misc`. But there is again a way to fix this.

The actual provider of `sun.misc` is the JVM. However the JVM does not know about OSGi. But the OSGi container itself, the framework, can act as a proxy. So if the framework bundle (aka bundle zero) would export `sun.misc` it would be able to actually resolve the class by using the JVM bootclasspath. The solution therefore is another fragment, which performs an `Export-Package: sun.misc`. That will bring both bundles with their fragments together, correctly wiring up `sun.misc`.

But as we have seen before, the fragment requires a “host bundle” and this would be different when e.g. using Apache Felix instead of Eclipse Equinox.

Again, there is a solution. The system bundle is also know as `system.bundle`. So the fragment can specify `system.bundle` with the attribute `extension:=framework` as bundle host:

```
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-SymbolicName: my.sun.misc.provider
Bundle-Version: 1.0.0
Fragment-Host: system.bundle; extension:=framework
Export-Package: sun.misc

```

Of course you can also export other JVM internal packages using that way.

There are only two things to keep in mind. First of all, but is is true to all other solutions as well, if the JVM does not provide `sun.misc` then this won’t work. Since the class cannot be found. Second, and this is specific to this solution, if you start “camel-core” before those two fragments are installed, then you need to “refresh” the Apache Camel Core bundle in order for the OSGi framework to re-wire your imports/exports.

There are also some pre-made extension bundles for this setup. Just [search maven central](http://search.maven.org/#search|ga|1|sun.misc).

### Equinox and Felix

Some setups of Felix and Equinox do provide an “out of the box” workaround. Equinox for example does automatically forward all failed class lookups to the boot class loader, as a last resort, in the case the framework is started by using the `org.eclipse.equinox.launcher_*.jar` instead of the `org.eclipse.osgi_*.jar` launcher.

### Bootclasspath delegation for Equinox

Eclipse Equinox also allows to set a few system properties in order to allow falling back to the bootclasspath and delegating the lookup of “sun.misc” to the JVM:

Also see: [https://wiki.eclipse.org/Equinox\_Boot\_Delegation](https://wiki.eclipse.org/Equinox_Boot_Delegation)

<dl><dt>osgi.compatibility.bootdelegation=true</dt><dd>This fill fall back to the bootclassloader like using the launcher “org.eclipse.equinox.launcher”</dd></dl>### Bootclasspath delegation for all

The OSGi core specification also allows to configure direct delegation of lookups to the boot classloader (Section 3.9.3 of the OSGi core specificion):

<dl><dt>org.osgi.framework.bootdelegation=sun.misc.\*</dt><dd>This will forward requests for “sun.misc.\*” directly to the boot class loader. </dd></dl>## Conclusion

Now people may complain “oh how complicates this OSGi-thingy is”. Well, “sun.misc.Unsafe” was never intended to be used outside the JVM. Java 9 will correct this with their module system. OSGi already can do that. But it also provides a way to solve this.

If you prefer to use system properties, a different launcher or the “two fragment” approach, that is up to you and your situation. For me the problem simply was to make it happen without changing either Apache Camel or the launcher configuration of Eclipse Kura. So I went with the “two fragments” approach.

## Thanks

I am just writing this down in order to help others. And I got help from others to solve this myself. So thanks to some people who posted this “on the net”, it is a long time, I stumbled over you googling about a solutions some time ago. Sorry I forgot where I initially found this solution.

Also thanks to [Neil Bartlett](https://twitter.com/nbartlett) for pointing out the OSGi conform solution with “org.osgi.framework.bootdelegation”.