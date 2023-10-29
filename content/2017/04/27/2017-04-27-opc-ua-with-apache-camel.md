---
id: 3592
title: 'OPC UA with Apache Camel'
date: '2017-04-27T14:44:42+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=3592'
permalink: /2017/04/27/opc-ua-with-apache-camel/
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:3598;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
    - IoT
    - 'Technical Stuff'
  tags:
    - Apache
    - Camel
    - Eclipse
    - IIoT
    - IoT
    - Milo
    - OPC UA
---

Apache Camel 2.19.0 is close to is release and the [OPC UA](https://en.wikipedia.org/wiki/OPC_Unified_Architecture) component called “camel-milo” will be part of it. This is my [Eclipse Milo](https://eclipse.org/milo) backed component which was previously hosted in my personal GitHub repository [ctron/de.dentrassi.camel.milo](https://github.com/ctron/de.dentrassi.camel.milo). It now got accepted into Apache Camel and will be part of the 2.19.0 release. As there are already a release candidates available, I think it is a great time to give a short introduction.

<!-- more -->

In a nutshell OPC UA is an industrial IoT communication protocol for acquiring telemetry data and command and control of industrial grade automation systems. It is also known as IEC 62541.

The Camel Milo component offers both an OPC UA client (`milo-client`) and server (`milo-server`) endpoint.

### Running an OPC UA server

The following Camel example is based on Camel Blueprint and provides some random data over OPC UA, acting as a server:

<figure>

[![Example project layout](https://dentrassi.de/wp-content/uploads/camel_milo_ex_prj_1.png)](https://dentrassi.de/wp-content/uploads/camel_milo_ex_prj_1.png)

<figcaption class="wp-caption-text" id="caption-attachment-3598">Example project layout</figcaption></figure>

The blueprint configuration would be:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="
	http://www.osgi.org/xmlns/blueprint/v1.0.0 https://osgi.org/xmlns/blueprint/v1.0.0/blueprint.xsd
	http://camel.apache.org/schema/blueprint https://camel.apache.org/schema/blueprint/camel-blueprint.xsd
	">

	<bean id="milo-server"
		class="org.apache.camel.component.milo.server.MiloServerComponent">
		<property name="enableAnonymousAuthentication" value="true" />
	</bean>

	<camelContext xmlns="http://camel.apache.org/schema/blueprint">
		<route>
			<from uri="timer:test" />
			<setBody>
				<simple>random(0,100)</simple>
			</setBody>
			<to uri="milo-server:test-item" />
		</route>
	</camelContext>

</blueprint>
```

And adding the following Maven build configuration:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

	<modelVersion>4.0.0</modelVersion>

	<groupId>de.dentrassi.camel.milo</groupId>
	<artifactId>example1</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>bundle</packaging>

	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<camel.version>2.19.0</camel.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-classic</artifactId>
			<version>1.2.1</version>
		</dependency>
		<dependency>
			<groupId>org.apache.camel</groupId>
			<artifactId>camel-core-osgi</artifactId>
			<version>${camel.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.camel</groupId>
			<artifactId>camel-milo</artifactId>
			<version>${camel.version}</version>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.felix</groupId>
				<artifactId>maven-bundle-plugin</artifactId>
				<version>3.3.0</version>
				<extensions>true</extensions>
			</plugin>
			<plugin>
				<groupId>org.apache.camel</groupId>
				<artifactId>camel-maven-plugin</artifactId>
				<version>${camel.version}</version>
			</plugin>
		</plugins>
	</build>

</project>
```

This allows you to simply run the OPC UA server with:

```bash
mvn package camel:run
```

Afterwards you can connect with the OPC UA client of your choice and subscribe to the item `test-item`, receiving that random number.

### Release candidate

As this is currently the release candidate of Camel 2.19.0, it is necessary to add the release candidate Maven repository to the `pom.xml`. I did omit  
this in the example above, as this will no longer be necessary when Camel 2.19.0 is released:

```xml
<repositories>
		<repository>
			<id>camel</id>
			<url>https://repository.apache.org/content/repositories/orgapachecamel-1073/</url>
		</repository>
	</repositories>

	<pluginRepositories>
		<pluginRepository>
			<id>camel</id>
			<url>https://repository.apache.org/content/repositories/orgapachecamel-1073/</url>
		</pluginRepository>
	</pluginRepositories>
```

It may also be that the URLs (marked above) will change as a new release candidate gets built. In this case it is necessary that you update the URLs to the appropriate  
repository URL.

### What’s next?

Once Camel 2.19.0 is released, I will also mark my old, personal GitHub repository as deprecated and point people towards this new component.

And of course I am happy to get some feedback and suggestions.
