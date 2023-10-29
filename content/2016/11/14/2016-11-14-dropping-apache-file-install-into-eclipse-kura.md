---
id: 888
title: 'Dropping Apache File Install into Eclipse Kura'
date: '2016-11-14T16:48:59+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=888'
permalink: /2016/11/14/dropping-apache-file-install-into-eclipse-kura/
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
taxonomies:
  categories:
    - Development
    - IoT
    - 'Technical Stuff'
  tags:
    - Eclipse
    - Java
    - Kura
    - OSGi
---

Sometimes the simple things may be the most valuable. Testing with [Eclipse Kura™](https://www.eclipse.org/kura/) on a Raspberry Pi (or any other Eclipse Kura device) may be a bit tricky. Of course can use the Eclipse UI in combination with mToolkit. But if you want to edit, compile, deploy from a local desktop machine, to a Kura device, then you either need to click through the Web UI for uploading your application. But for this to work you also need to assembly a DP (distribution package).

But what if you could simply drop an OSGi bundle into a directory and let it get picked up by Kura automatically. Thanks to [Apache File Install](https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html), there already is such a solution. File Install scans a folder and loads every OSGi bundle located in this folder. If a bundle is started and it gets overwritten in the file system, then File Install will reload and restart the bundle.

<!-- more -->

So deploying and re-deploying to a Kura device is as easy a copying a file to your target with SCP (or the remote copy tool of your choice).

And installing Apache File Install into Eclipe Kura now just got a bit simpler.

### Using Maven Central

Simply navigate to the <q>Packages</q> section of the Eclipse Kura Web UI. Press the “Install” button and choose “URL” and enter the following URL:

<https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.utils.fileinstall/0.1.0/de.dentrassi.kura.addons.utils.fileinstall-0.1.0.dp>

After confirming using the <q>Submit</q> button it will take a bit and then File Install will be installed into your Kura installation. Sometimes it takes as bit longer than Kura expects and you need to reload the Web UI (Ctrl-R) until Kura has performed the installation.

### Using the Eclipse Marketplace

Currently the Eclipse Marketplace is focused on hosting plugins for the Eclipse IDE, but this should change rather soon. But still it is possible right now to drag and drop Apache File Install into Eclipse Kura with the use of the following install button:

[![Drag to your running Eclipse workspace to install Apache File Install for Eclipse Kura](https://marketplace.eclipse.org/sites/all/themes/solstice/public/images/marketplace/btn-install.png)](http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3160594 "Drag to your running Eclipse workspace to install Apache File Install for Eclipse Kura")

Dragging this button into the Kura Web UI will bring up a confirmation dialog if you want to install the addon. After confirming it will go and fetch the DP and install Apache File Install into the running Kura instance.

### Deploying bundles

Now it is time to deploy some bundles. By default the directory where Apache File Install looks for bundles is `/opt/eclipse/kura/load`. At first this directory will not exist, so it has to be created. Next we simply fetch and example bundle using `wget`:

```bash
cd /opt/eclipse/kura
mkdir load
wget "https://dentrassi.de/download/kura/org.eclipse.kura.example.camel.publisher-1.0.0.jar"
```

This is an example publisher bundle from the upcoming Kura 2.1.0 release. So if you are still using Kura 2.0, then you can either try a different OSGi bundle, or maybe give Kura 2.1 a try ;-)

Due to a regression in Kura ([eclipse/kura#123](https://github.com/eclipse/kura/issues/757)) there is currently no way to manually start OSGi bundles. So you need to stop Kura and start the local command console (`/opt/eclipse/kura/bin/start_kura.sh`). On the OSGi shell you can then:

```
osgi> ss example
"Framework is launched."


id	State       Bundle
116	RESOLVED    org.eclipse.kura.example.camel.publisher_1.0.0
osgi> start 116
osgi> ss example
"Framework is launched."


id	State       Bundle
116	ACTIVE      org.eclipse.kura.example.camel.publisher_1.0.0
osgi>
```

Now once this initial activate has been performed, File Install and OSGi will keep the bundle active. You can re-deploy this OSGi bundle by simply copying a new version over the old one. File Install will detect the change and refresh the bundle.

### There is more…

Apache File Install can also update OSGi configurations and it can be configured using a set of system properties. For the full set of options check out the [Apache File Install documentation](https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html).
