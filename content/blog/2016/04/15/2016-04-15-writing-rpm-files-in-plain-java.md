---
id: 779
title: 'Writing RPM files &#8230; in plain Java'
date: '2016-04-15T11:12:51+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=779'
permalink: /2016/04/15/writing-rpm-files-in-plain-java/
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
    - 'Package Drone'
    - 'Technical Stuff'
tags:
    - Java
    - RPM
---

Now creating an RPM file is easy. There are a lot of tutorials [out there](https://www.google.com/#q=create+rpm) on how write a [SPEC file](http://www.rpm.org/max-rpm/ch-rpm-inside.html) and build your RPM. Even when you are using Maven … with the exception that when you are on Windows or Mac OS X, the [Maven RPM plugin](http://www.mojohaus.org/rpm-maven-plugin/) will still try to invoke `rpmbuild` in order to actually build the RPM file. The maven bundle simply creates a SPEC file, layout out the payload data and lets `rpmbuild` do the processing.

<!-- more -->

My task now was to make it possible for [Eclipse NeoSCADA](https://www.eclipse.org/eclipsescada/) to create configuration RPMs directly from inside the Eclipse IDE (running in Java), without the need to have `rpmbuild` on a Windows platform. Since I did write an RPM reader for [Package Drone](https://packagedrone.org/) before, I did know a bit about the RPM file format. So this shouldn’t be a big deal?! … How naive ;-)

Now there is a bit of documentation about the RPM file format ([\[1\]](http://www.rpm.org/max-rpm/s1-rpm-file-format-rpm-file-format.html "RPM File Format"), [\[2\]](https://docs.fedoraproject.org/ro/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch-package-structure.html)) and there also is an implementation, called [jRPM](http://jrpm.sourceforge.net/), which can read RPM files in Java. But beside the fact that is was not updated for a long, long time, it cannot write RPM files.

### Reading RPMs

So why is writing RPM files so complicated? It isn’t. RPM is a binary format, designed in the 90ies using C. It uses structs, which get written out in the file stream. Some areas of the file are (the lead) are only left over for compatibility reasons and are ignored nowadays. The RPM file has two dictionary like structures, which can be used to store variable type data in a `integer` to `data` relation (called <q>headers</q>, one signature header, one package header). The end of the file is the actual payload section which holds a CPIO archive, which can be compressed e.g. using GZIP. Nothing fancy, easy to read if you are used to working with binary content. So in the past it was easy for me to write our own [RPM reader for Package Drone](https://dentrassi.de/2015/12/03/parsing-rpms-in-java/).

### Writing RPMs

Now writing RPMs is a completely different story. First of all you can’t simply ignore all those unused areas, you actually have to write them out. Next, the boths headers (which have nearly the same format) do have a fixed length record structure in the beginning and then a variable payload section.

Like this (please not, all <q>diagrams</q> in here are just sketches! For the real binary layout, please see the RPM documentations):

```

         -----------------------------------------------
         | Number Of Entries  | Payload Size           |
         -----------------------------------------------
Entry #1 | TAG #1 | TYPE | COUNT | OFFSET in payload   |
Entry #2 | TAG #2 | TYPE | COUNT | OFFSET in payload   |
Entry... | TAG... | TYPE | COUNT | OFFSET in payload   |
Entry #n | TAG #n | TYPE | COUNT | OFFSET in payload   |
         -----------------------------------------------
Payload  |                                             |
         |                                             |
         |                                             |
         |                                             |
         -----------------------------------------------

```

Reading this structure is easy. You read the tags, look up in the big payload BLOB and interpret the data using the type information. Writing this out the same way caused the official RPM tool to reject my content. I did run this in my own reader which worked fine though. The first error message I ran into was `BAD, tag`. So what to do?

Searching the internet for “RPM” and “BAD, tag” is not really helpful if you don’t know what you are looking for. So, thanks to open source, I did check out the RPM source and looked into the code what could cause this error message.

My first mistake was I assume the position of the payload header data was irrelevant. But no, it wasn’t. Payload data has to be aligned inside the big payload field. While the payload field itself is aligned to 8 bytes.

But I did learn another thing from my look into the RPM source code. I knew there would be a lot more things coming up until I would be done with this task. The RPM code is full of special cases, legacy handling, weird logic in order to keep work around creating incompatible file formats. I don’t want to complain here, I know how the history of a productive tool can get to you. And the RPM file format is not intended to be a standardized format.

### My highlight

I really don’t want to tell you about all the strange things I have seen. But there is one highlight which nearly made me give up until I ran into a helpful [mailing list entry from Jeff Johnson](https://www.redhat.com/archives/rpm-list/2000-December/msg00217.html "rpm-4.0.1 immutable header regions").

I did outline the header section above. And I managed to write it correctly. But still the SHA1 header check failed, which prevented RPM to accept the file. The MD5 check however passed. Strange, since the SHA1 header check only checks the package header, while the MD5 check does check the package header plus the payload data.

Turned out, there is one feature in the RPM header which marks a region in the header as <q>immutable</q>. This was added at a later version and was kind of <q>hidden</q> inside the actual data, in order not to break the file format.

In short, a part of this header structure above, should be considered unchangeable, tag entry information and payload data. A marker will draw the line between mutable and immutable region. Like that:

```

         -----------------------------------------------
         | Number Of Entries   | Payload Size          |
         -----------------------------------------------
Entry #1 | TAG #1 | TYPE | COUNT | OFFSET in payload   |
Entry #2 | TAG #2 | TYPE | COUNT | OFFSET in payload   |
========================================================
Entry... | TAG... | TYPE | COUNT | OFFSET in payload   |
Entry #n | TAG #n | TYPE | COUNT | OFFSET in payload   |
         -----------------------------------------------
Payload  |                                             |
         |                                             |
========================================================
         |                                             |
         |                                             |
         -----------------------------------------------

```

Now, interestingly, all RPM files which I did encounter marked the full header as immutable. So I am still not sure what that means.

The way this is stored is even more interesting, since the immutable region information is stored in the payload section, as a tag entry structure itself, pointing backwards with a negative offset, in bytes, of how many entries are considered immutable.

Look (␣ = padding):

```

         ------------------------------------------
         | Number Of Entries  | Payload Size      |
         ------------------------------------------
Entry #1 | 62     | BLOB      |   16  |   24      |
Entry #2 | TAG #1 | STRING    |    1  |    0      |
Entry #3 | TAG #2 | INT32     |    1  |   12      |
Entry #4 | TAG #3 | INT16     |    4  |   20      |
         ------------------------------------------
Payload  |FOO BAR!␀␣␣␣000011223344XXXXXXXXXXXXXXXX|  
         ------------------------------------------

XXX...X = | 62 | BLOB | 16 | -(5*16) = -80 |


```

Although I though I would write it out correctly, I made one mistake. The entry with the special tag 62 (or 63) comes first, but still, its payload data comes last. The data structure would allow for a different position. It would be possible to write out the payload of Entry #1 first, and let the rest follow. But that does not work and will cause a SHA1 failure. Only placing the special marker first in the tag entry list and last in the payload section seems to work.

All this special handling explained a lot of oddities when I looked in the RPM source code at first.

### So what?

First of all I have to say that a lot has been done from RPM version 4.11 to 4.13. I started out testing on Ubuntu, with RPM 4.11 and ended up using Fedora 23 with RPM 4.13. A few generic error messages where fixed into more helpful messages. The [source code is on GitHub](https://github.com/rpm-software-management/rpm) and has been cleaned up a lot.

While implementing the write support, I also tried to find another solution which is capable of writing RPM files in order to read their source code and get a better understanding. I did find none. Sure there is Python and Perl support for RPM, but this is all backed by native code and the `librpm`.

Well, now there is the first, independent implementation for reading AND writing RPM files aside the original RPM implementation. It is part of the Eclipse Package Drone project and [hosted on GitHub](https://github.com/eclipse/packagedrone/tree/master/bundles/org.eclipse.packagedrone.utils.rpm). You can find first binaries [on Sonatype’s OSS repository](https://oss.sonatype.org/content/groups/public/org/eclipse/packagedrone/org.eclipe.packagedrone.utils.rpm/), and when Package Drone 0.13.0 is being released, these will be pushed to Maven Central as well.

### What is next?

I do hope that I find some time in the future to write a Maven Plugin which is capable of creating RPMs using plain Java. So it should be easy to use Maven on Windows or Mac OS X to create RPMs during a Maven build.

There are probably also a <del datetime="2016-04-15T08:27:58+00:00">few</del> a lot special cases left over which need fixing … contributions are welcome ;-)
