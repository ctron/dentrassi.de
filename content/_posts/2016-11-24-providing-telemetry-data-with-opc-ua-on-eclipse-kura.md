---
id: 905
title: 'Providing telemetry data with OPC UA on Eclipse Kura'
date: '2016-11-24T16:00:31+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=905'
permalink: /2016/11/24/providing-telemetry-data-with-opc-ua-on-eclipse-kura/
spacious_page_layout:
    - default_layout
fabulous-fluid-layout-option:
    - default
fabulous-fluid-header-image:
    - default
fabulous-fluid-featured-image:
    - default
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:3:"906";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/Apache-camel-logo.png
categories:
    - Development
    - IoT
    - 'Technical Stuff'
tags:
    - Eclipse
    - IoT
    - Kura
    - Milo
    - 'OPC UA'
---

The upcoming version 2.1.0 of [Eclipse Kura™](https://www.eclipse.org/kura/) will feature an enhanced version of the [Apache Camel™](https://camel.apache.org/) integration which was introduced in Kura 2.0.0. There are various new ways on how to run Camel routes, configured either by XML routes or using the Java DSL. Apache Camel can act as a Kura application but, new in this release, there is also a way to simply configure Camel as a “cloud service”. In past releases of Kura, applications could only push data to one cloud target. The new 2.1.0 release will add the functionality of adding multiple cloud targets and one of those targets can be Apache Camel router instances.

With Camel you can have different ways of achieving this goal, but in this post I would like to focus on the “out of the box” way, by simply configuring (not developing) a set of Camel routes, which act as cloud service. Traditional instances of cloud services in Kura are only capable of delivering data to one cloud target or subscribing to one cloud infrastructure. But using Apache Camel as a technology it is possible to connect to a bunch of technologies at the same time.

#### The setup

The setup will be a Kura instance, running a pre-release version of Kura 2.1.0. The final version should be out in a few weeks and won’t differ much from the current version. We will be configuring a new cloud service instance which takes Kura application payload data and provide it as OPC UA, using the [Camel OPC UA adapter](https://github.com/ctron/de.dentrassi.camel.milo). As payload provider (aka Kura application) we will be using the “Example publisher” from my [Kura addons](https://dentrassi.de/kura-addons/) project.

Open up the Kura Web UI, navigate to “Packages” and select “Install/Update”. Switch to “URL” and provide the following URL:

`https://dentrassi.de/download/kura/de.dentrassi.kura.addons.example.publisher_0.1.0-SNAPSHOT.dp`

**Note:**  As an alternative you can also download the “dp” package with your desktop browser and deploy the file using the “file” upload instead of “URL”.

<figure aria-describedby="caption-attachment-932" class="wp-caption aligncenter" id="attachment_932" style="width: 607px">[![Adding packages to Kura](https://dentrassi.de/wp-content/uploads/kura_add_package.png)](https://dentrassi.de/wp-content/uploads/kura_add_package.png)<figcaption class="wp-caption-text" id="caption-attachment-932">Adding packages to Kura</figcaption></figure>The installation may take a bit and it may be necessary to press the “Refresh” button in order to see the installed package. After the packages was installed you should be able to see the service “Camel example publisher” on the left side.

Now we need to install the “Milo component for Camel”. Press “Install/Update” again and enter the following URL:

`http://central.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.milo/0.2.2/de.dentrassi.kura.addons.milo-0.2.2.dp`

This installation will take a lot longer and you will need to check again by pressing the “Refresh” button in the Web UI.

We will also need to allow TCP access to port 12685. If you have the network managed version of Kura installed switch to the UI section “Firewall” and open a new port “12685” allowing access from “0.0.0.0/0” (Permitted Network) and press “Apply”.

#### A new cloud service

By default the “example publisher” will publish to the default Kura cloud service instance. We will now create a new Cloud service instance and then redirect the data to OPC UA. The data will be available as an OPC UA server. OPC UA differs between client and server. And while the Camel component does provide both ways, in this case we want others to consume our data, so offering data as an OPC UA server is the way to go.

Navigate to “Cloud Services” and press the “New” button. From the list of possible providers select `org.eclipse.kura.camel.cloud.factory.CamelFactory`, enter a cloud service PID (e.g. `camel-opcua`) and press “Create”.

After the instance has been created select it and configure it with the following options:

Router XML:

```
<routes xmlns="http://camel.apache.org/schema/spring">
    <route id="opc-ua-example">
       <from uri="vm:camel:example"/>
       <split>
           <simple>${body.metrics().entrySet()}</simple>
           <setHeader headerName="item">
               <simple>${body.key()}</simple>
           </setHeader>
           <setBody>
               <simple>${body.value()}</simple>
           </setBody>
           <toD uri="my-milo:${header.item}"/>
       </split>
    </route>
</routes>
```

Initialzation Code:

```
var milo = new org.apache.camel.component.milo.server.MiloServerComponent();
milo.setEnableAnonymousAuthentication(true);
camelContext.addComponent("my-milo", milo);
```

<figure aria-describedby="caption-attachment-933" class="wp-caption aligncenter" id="attachment_933" style="width: 1123px">[![Screenshot of cloud service configuration](https://dentrassi.de/wp-content/uploads/kura_opcua_cs.png)](https://dentrassi.de/wp-content/uploads/kura_opcua_cs.png)<figcaption class="wp-caption-text" id="caption-attachment-933">OPC UA configuration</figcaption></figure>#### Assigning the cloud service

Now we need to configure the example publisher to actually use our new cloud service instance. Select “Camel example publisher” from the left navigation bar and enter “opcua” (or whatever PID you used before) as “Cloud Service PID”. Apply the changes.

#### Testing the result

First of all, if you log in into your device using SSH, you should be able to see that port 12685 is opened:

```
root@raspberrypi:/home/pi# ss -nlt | grep 12685
LISTEN     0      128                      :::12685                   :::*     
```

Now you can connect to your device using any OPC UA explorer to the URI: `opc.tcp://<my-ip>:12685`

I am using Android and the [“ProSYS OPC UA Client”](https://play.google.com/store/apps/details?id=com.prosysopc.ua.android2)

 <style>
			#gallery-2 {
				margin: auto;
			}
			#gallery-2 .gallery-item {
				float: left;
				margin-top: 10px;
				text-align: center;
				width: 50%;
			}
			#gallery-2 img {
				border: 2px solid #cfcfcf;
			}
			#gallery-2 .gallery-caption {
				margin-left: 0;
			}
			/* see gallery_shortcode() in wp-includes/media.php */
		</style><div class="gallery galleryid-905 gallery-columns-2 gallery-size-thumbnail" id="gallery-2"><dl class="gallery-item"> <dt class="gallery-icon landscape"> [![Screenshot of OPC UA client](https://dentrassi.de/wp-content/uploads/kura_milo_browse-150x150.png)](https://dentrassi.de/wp-content/uploads/kura_milo_browse.png) </dt> <dd class="wp-caption-text gallery-caption" id="gallery-2-926"> Screenshot of OPC UA client browsing </dd></dl><dl class="gallery-item"> <dt class="gallery-icon landscape"> [![Screenshot of OPC UA client](https://dentrassi.de/wp-content/uploads/kura_milo_monitor-150x150.png)](https://dentrassi.de/wp-content/uploads/kura_milo_monitor.png) </dt> <dd class="wp-caption-text gallery-caption" id="gallery-2-927"> Screenshot of OPC UA client browsing </dd></dl>  
 </div>#### Summing it up

This tutorial uses a SNAPSHOT version of Eclipse Milo. Simply due to the fact that no version of Milo is released just yet. This should change in the following weeks and my play is to update the blog post once it is available. However the functionality of Milo will not change and using the Camel component, most internals of Milo are hidden anyway.

**Update:** As Milo and the Camel Milo component are released now I did update the links.

Apache Camel on Eclipse Kura can provide a complete new way of communication. This example was a rather simple one, Camel can do a lot more when it comes to processing data. And not all real-life applications may be as easy as that. But of course the intention of this blog post was to give a quick introduction into Camel and Kura in combination. Using the Camel Java DSL or the Kura Camel programmatic API can give greater flexibility. And yet, the example shows that even with a few lines of Camel XML, amazing things can be achieved.