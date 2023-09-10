---
id: 3555
title: 'Developing for Eclipse Kura on Windows'
date: '2017-03-21T16:54:58+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3555'
permalink: /2017/03/21/developing-for-eclipse-kura-on-windows/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3568;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Docker
    - Eclipse
    - IDE
    - IoT
    - Kura
---

Every now and then it is fun to leave the environment you are used to and do something completely different. So this journey take me to IntelliJ and Windows 10. And yes, I am glad to be back in Linux/Eclipse-land. But still, I think something rather interesting came out of this.

It all started when I helped my colleague [Aurélien Pupier](https://www.linkedin.com/in/aurelienpupier/) to get his environment ready for his talk at the Eclipse IoT day Grenoble. If you missed this talk, you can [watch a recording of it](https://gricad.univ-grenoble-alpes.fr/video/integration-apache-camel-eclipse-kura). He wanted to present the [Camel Developer Tools](https://tools.jboss.org/features/apachecamel.html). The <q>problem</q> was the he was working on a Windows laptop. And he wanted to demonstrate [Eclipse Kura](https://eclipse.org/kura) in combination JBoss Tools IDE. However Kura can only run on Linux and he wanted to run the JBoss Tools native on his Windows machine.

Of course you could come up with some sort of Virtual Machine setup, but we wanted something which was easier to re-produce in the case there would be some issue with the laptop for the presentation.

### Creating a docker image of Kura

The first step was to create a docker image of Kura. Currently Kura doesn’t offer any support for Docker. So that had to be created from scratch. As there is even no <tt>x86\_64</tt> distribution of Kura and no emulator distribution, it was necessary to do some rather unusual hacks. The background is, that Kura has a rather crude build system which assembles a few distributions in the end of the build. Kura also requires some hardware interfaces in order to work properly. For those hardware interfaces there exist <q>emulator</q> replacements for using in a local developer setup. However there is neither a distribution assembly for <tt>x86\_64</tt> nor one using the emulator replacements. The whole build system in the end is focused around creating Linux-only images. The solution was to simply rip out all functionality which was <q>in the way</q> and create a patch file.

This patch file and the docker build instructions are now located at a different repository where I can easily modify those and hook it up to the DockerHub build system: [ctron/kura-emulator](https://github.com/ctron/kura-emulator). Currently there are three tags for docker images in the [Kura Emulator DockerHub repository](https://hub.docker.com/r/ctron/kura-emulator/tags/): latest (which is the most recent, but stable release), 3.0.0-RC1 and develop (most recent, less stable). As there is currently no released version of Kura 3.0.0, the latest tag is also using the <tt>develop</tt> branch of Kura. The <tt>3.0.0-RC1</tt> tag is a stable version of the emulator which is known to work and won’t be updated in the future.

There is a more detailed [README file](https://github.com/ctron/kura-emulator/blob/master/README.md) in the GitHub repository which explains how to use and build the emulator yourself. In a nutshell you can start it with:

```
docker run -ti -p 8080:8080 ctron/kura-emulator
```

And afterwards you can navigate with your browser to http://localhost:8080 and use the Kura Web UI.

As Docker is also available for Windows, this will work the same way on either Linux or Windows, and although I didn’t test it, it should also work on Mac OS X.

### JMX &amp; Debugging

As the Camel tooling makes use of JMX, it was necessary to also enable JMX support for Kura, which normally is not available with Kura. By setting the `JAVA_OPTS` environment variable it is not only possible to enable JMX, but also to enable plain Java debugging for the docker image. Of course you will need to publish the selected ports with `-p` when running the docker image. And for Windows you cannot simply use <tt>localhost</tt> but you will need to use the IP addresses created by docker for windows: also see [README.md](https://github.com/ctron/kura-emulator/blob/master/README.md#running-with-jmx-enabled).

### Drop in &amp; activate

After the conference was over, I started to think about what we actually had achieved by doing all this. We had a read-to-run Kura image, dockerized, capable of running of Windows (with docker), debuggable. The only part which was still missing was the ability to add a new, custom bundle to the emulator.

Apache Felix File Install to the rescue! In the past I created an [Apache Felix File Install DP](https://dentrassi.de/kura-addons/#apache-file-install) for Kura (DP = deployment package for Kura). File Install works in a way that it monitors a directory and automatically loads, unloads and updates an OSGi JAR file which you drop into this directory. The DP can simply be dropped into Kura, which extends Kura with this File Install functionality.

So I pre-seeded the Kura docker image with the File Install DP and declared a volume mount, so that you can simply mount a path of the docker image onto your host system. Dropping a file into the directory on the host system will make it available to the docker container and File Install will automatically pick it up and start it, but inside the docker container.

```
docker run -ti -p 8080:8080 -v c:/path/to/bundles:/opt/eclipse/kura/load ctron/kura-emulator
```

And this even works with Docker for Windows, if you share your drive first:

<figure aria-describedby="caption-attachment-3563" class="wp-caption aligncenter" id="attachment_3563" style="width: 852px">[![](https://dentrassi.de/wp-content/uploads/kura_docker_win_1.png)](https://dentrassi.de/wp-content/uploads/kura_docker_win_1.png)<figcaption class="wp-caption-text" id="caption-attachment-3563">Share drive with Docker</figcaption></figure>### Choose your tools

Currently Kura requires you to use a rather complicated setup for developing applications for Kura. You will need to learn about Eclipse PDE, target platforms, Tycho for Maven and bunch of other things to get your Kura application developed, built and packaged.

I already created a GitHub repository for showing a different way to develop Kura applications: [ctron/kura-examples](https://github.com/ctron/kura-examples). Those project use plain maven, the `maven-bundle-plugin` and my [osgi-dp](https://ctron.github.io/osgi-dp/) plugin to create the final DP. Those examples also make use of the newer OSGi annotations instead of requiring your to craft all OSGi metadata by hand.

So if you wanted, you could already use your favorite IDE and start developing Kura application with style. But in order to run them, you still needed a Kura device. But with this docker image you can now simply let the emulator run and let File Install pick up the compiled results:

 <style>
			#gallery-3 {
				margin: auto;
			}
			#gallery-3 .gallery-item {
				float: left;
				margin-top: 10px;
				text-align: center;
				width: 33%;
			}
			#gallery-3 img {
				border: 2px solid #cfcfcf;
			}
			#gallery-3 .gallery-caption {
				margin-left: 0;
			}
			/* see gallery_shortcode() in wp-includes/media.php */
		</style><div class="gallery galleryid-3555 gallery-columns-3 gallery-size-thumbnail" id="gallery-3"><dl class="gallery-item"> <dt class="gallery-icon landscape"> [![](https://dentrassi.de/wp-content/uploads/kura_docker_win_2-150x150.png)](https://dentrassi.de/wp-content/uploads/kura_docker_win_2.png) </dt> <dd class="wp-caption-text gallery-caption" id="gallery-3-3566"> Start docker container </dd></dl><dl class="gallery-item"> <dt class="gallery-icon landscape"> [![](https://dentrassi.de/wp-content/uploads/kura_docker_win_3-150x150.png)](https://dentrassi.de/wp-content/uploads/kura_docker_win_3.png) </dt> <dd class="wp-caption-text gallery-caption" id="gallery-3-3567"> Deploy application </dd></dl><dl class="gallery-item"> <dt class="gallery-icon landscape"> [![](https://dentrassi.de/wp-content/uploads/kura_docker_win_4-150x150.png)](https://dentrassi.de/wp-content/uploads/kura_docker_win_4.png) </dt> <dd class="wp-caption-text gallery-caption" id="gallery-3-3568"> Application is activated </dd></dl>  
 </div>### Summary

So yes, it is possible to use IntelliJ on Windows to develop and debug your Kura application, in a stylish fashion. Or you can simply do the same, just using an excellent IDE like Eclipse and an awesome operating system like Linux, with the same stylish approach ;-)