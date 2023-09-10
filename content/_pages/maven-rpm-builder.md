---
id: 3670
title: 'Maven RPM builder'
date: '2017-08-22T09:38:41+02:00'
author: 'Jens Reimann'
layout: page
guid: 'https://dentrassi.de/?page_id=3670'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - disable
fabulous-fluid-featured-image:
    - disable
---

The Maven RPM builder is a small [Apache Maven](https://maven.apache.org) plugin which I wrote. It allows you to create an [RPM](http://rpm.org/) file during a Maven build in plain Java. There already is a Maven RPM plugin available, however it does make use of the `rpm` binary. So it does require you to have a running version of RPM on your local build system. The Maven RPM builder however uses an RPM implementation in pure Java and thus allows you to create RPM files without the need to have the `rpm` binary. This makes it easier to build on platforms like Mac OS, Windows or Linux distributions which don’t use RPM.

Currently the plugins allows to create RPM files with content coming from the Maven build and allows provides support for creating a simple YUM repository. There is support for Unix file system permissions, directories, large files, dependencies. RPM metadata is by default taken from the Maven metadata, bit it can of course also be overridden  
using the Maven POM file.

Be sure to check out the [documentation page](https://ctron.github.io/rpm-builder), as it provides much more information including a few examples on how to assembly your RPM files properly.

This plugin is open source and you are welcome to make comments or provide bug fixes and feature enhancements. This work is based on my other project [Eclipse Package Drone](https://eclipse.org/package-drone). It provides the core functionality of reading and writing RPM files in plain Java. If you are interested in a programmatic way of creating or reading RPM files in Java, check this out as well.

### Maven coordinates 


Here are the Maven coordinates to the plugin, be sure to replace the version with the most recent (or version of your choice).

```
<pre class="lang:xhtml decode:true "><plugin>
  <groupId>de.dentrassi.maven</groupId>
  <artifactId>rpm</artifactId>
  <version><!-- version --></version>
</plugin>
```

### See also

- [Documentation](https://ctron.github.io/rpm-builder)
- [GitHub repository – ctron/rpm-builder](https://github.com/ctron/rpm-builder)
- [Search Maven Central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22de.dentrassi.maven%22%20AND%20a%3A%22rpm%22)