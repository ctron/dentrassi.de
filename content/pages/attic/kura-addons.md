---
id: 878
title: 'Eclipse Kura™ addons'
date: '2016-11-11T13:37:59+01:00'
author: 'Jens Reimann'
layout: page
guid: 'https://dentrassi.de/?page_id=878'
spacious_page_layout:
    - default_layout
inline_featured_image:
    - '0'
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
---

This page lists a few addons I created for Eclipse Kura. Be sure to check out the GitHub repository [ctron/kura-addons](https://github.com/ctron/kura-addons) as well.

<!-- more -->

Most addons are directly available on Maven Central and/or through the Eclipse Marketplace. For using Eclipse Marketplace just drag and drop the “Install” button onto the Eclipse Kura Web UI.

For using the Maven Central installation link, just follow click on the Maven shield, select the version to install and either download the `.dp` file manually and upload it to Kura, or copy the URL to the `.dp` artifact and past the URL in the package install dialog in the Kura Web UI.

**Note:**  As Kura does use the DP system for deploying functionality into Kura there is no isolation between different addons. And addition DP prevents two different packages to provide the same OSGi bundle. Such an installation will simply fail. So if you drop in two conflicting DPs, then this may simply fail. The proper solution would be to create a combined DP which then does not have a duplicate bundle. But providing all combinations of the available addons is just not possible. Also this is not a fault of OSGi, it could handle this situation, it just is a limitation of the DP system.

## Extensions

This sections lists addons which extend the Kura base platform.

#### Apache File Install [![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.utils.fileinstall.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.utils.fileinstall%22) 

This addon provides [Apache File Install](https://felix.apache.org/documentation/subprojects/apache-felix-file-install.html) for Eclipse Kura. It allows one to drop an OSGi bundle into `/opt/eclipse/kura/load` and it will get loaded. The bundle has to be started manually for the first time. Updating a bundle is as easy as overwriting the bundle file. Once the bundle was started manually for the first time, it will be restarted later on.  
[  
![Drag to your running Eclipse workspace to install Apache File Install for Eclipse Kura](https://marketplace.eclipse.org/sites/all/themes/solstice/public/images/marketplace/btn-install.png)  ](http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3280897 "Drag to your running Eclipse Kura Web UI to install Apache File Install for Eclipse Kura")

#### Jolokia JMX API [![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.utils.jolokia.svg)](https://search.maven.org/search?q=g:de.dentrassi.kura.addons%20AND%20a:de.dentrassi.kura.addons.utils.jolokia) 

The Jolokia package provides the [Jolokia JMX API](https://jolokia.org/), and integrates with the Kura configuration mechanism in order to allow configuration of the Jolokia endpoint. The Jolokia endpoint is registered with the default HTTP server of Kura at `/jolokia`. It will not allow anonymous access, so it will disable the endpoint if either user or password is empty. Also see [hawtio](http://hawt.io/) for a remote management console, which uses Jolokia.

####  OSGi JMX Management Model Specification [![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.utils.jmx.svg)](https://search.maven.org/search?q=g:de.dentrassi.kura.addons%20AND%20a:de.dentrassi.kura.addons.utils.jmx) 

The OSGi JMX Management Model Specification allows access to the OSGi framework via JMX. This may be interesting in combination with the Jolokia package, as it allows full visibility of OSGi specific information via the Jolokia remote API, and also support the hawtio OSGi extension. This way most aspects of the OSGi runtime can be monitored and managed via the hawtio console.

#### ActiveMQ Artemis Broker

**Note:** This addon is now an official part of Kura.

The Artemis addon provides an embedded Artemis broker instance for Kura. It can offer AMQP or MQTT at the moment.

For more information see: [artemis/README.md](https://github.com/ctron/kura-addons/blob/master/artemis/README.md)

## Camel Components

This section lists Apache Camel components. Please note, most bundles also bring their dependencies. So for example it is possible to use only the AMQP functionality of the AMQP addon, without using the Camel AMQP component.

#### Eclipse Milo™ – OPC UA[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.milo.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.milo%22)

This addon provides OPC UA based on [Eclipse Milo™](https://eclipse.org/milo), an OPC UA stack written in Java.

It contains the core Milo components and dependencies and includes the [Apache Camel Milo component](https://github.com/ctron/de.dentrassi.camel.milo).  
[  
![Drag to your running Eclipse workspace to install OPC UA component for Apache Camel](https://marketplace.eclipse.org/sites/all/themes/solstice/public/images/marketplace/btn-install.png)  ](http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3276130 "Drag to your running Eclipse Kura Web UI to install OPC UA component for Apache Camel")

#### AMQP[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.amqp.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.amqp%22)

This addon provides AMQP by using Qpid and the accompanying Camel component [camel-amqp](https://camel.apache.org/amqp.html).  
[  
![Drag to your running Eclipse workspace to install AMQP component for Apache Camel](https://marketplace.eclipse.org/sites/all/themes/solstice/public/images/marketplace/btn-install.png)  ](http://marketplace.eclipse.org/marketplace-client-intro?mpc_install=3276138 "Drag to your running Eclipse Kura Web UI to install AMQP component for Apache Camel")

#### Eclipse NeoSCADA™[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.neoscada.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.neoscada%22)

The NeoSCADA addon provides a Camel component for hosting a NeoSCADA server, providing data over the NeoSCADA NGP protocol. This way telemetry data can be served over the NeoSCADA APIs and for example the administrative UI based client can be used for testing and developing.

#### SNMP[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.snmp.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.snmp%22)

An addon which provides [camel-snmp](https://camel.apache.org/snmp.html) and its dependencies.

#### Eclipse Paho™ – MQTT[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.paho.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.paho%22)

As Kura currently does not provide a usable version of Paho, this bundle provides Eclipse Paho and the accompanying Camel component [camel-paho](https://camel.apache.org/paho.html).

#### Drools[![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.drools.core.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.drools.core%22) [![](https://img.shields.io/maven-central/v/de.dentrassi.kura.addons/de.dentrassi.kura.addons.drools.components.svg)](https://search.maven.org/#search|gav|1|g%3A%22de.dentrassi.kura.addons%22%20AND%20a%3A%22de.dentrassi.kura.addons.drools.components%22)

Drools is a Business Rules Management System which can do complex event processing, execute predicate models (PMML) and way more. The Kura addons offer two layers of integration for Drools. “core”, which bundles the Drools runtime ready to run inside the Kura OSGi runtime. This allows you to bake your own Drools solutions based on Kura and Drools. And then the “components”, which depend on the “core” package, but offer out of the box functionality and integration with Kura Wires and other Kura APIs.
