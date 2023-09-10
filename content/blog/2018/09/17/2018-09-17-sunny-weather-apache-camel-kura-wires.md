---
id: 4009
title: 'Sunny weather with Apache Camel and Kura Wires'
date: '2018-09-17T16:48:37+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4009'
permalink: /2018/09/17/sunny-weather-apache-camel-kura-wires/
inline_featured_image:
    - '0'
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
    - IoT
    - 'Technical Stuff'
tags:
    - Apache
    - Camel
    - Eclipse
    - IoT
    - Kura
---

[Part #1](https://dentrassi.de/2018/09/14/the-power-of-apache-camel-in-eclipse-kura/) of the [Apache Camel](https://camel.apache.org) to [Kura](https://eclipse.org/kura) Wires integration tutorial did focus on pushing data from Kura Wires to Camel and processing it there. But part #1 already mentioned that it is also possible to pull in data from Camel into Kura Wires.

<!-- more -->

![Apache Camel consumer node in Kura Wires](https://dentrassi.de/wp-content/uploads/drawing_2.png)

## Preparations

For the next step, you again need to install a Camel package, for interfacing with [Open Weather Map](https://openweathermap.org/): `https://repo1.maven.org/maven2/de/dentrassi/kura/addons/de.dentrassi.kura.addons.camel.weather/0.6.0/de.dentrassi.kura.addons.camel.weather-0.6.0.dp` The installation follows the same way as already described in part #1.

In addition to the installation of the package, you will also need to create an account at <https://openweathermap.org/> and create an API key. You can select the free tier plan, it is more than enough for our example.

## Back to Wires

Next, create a new Camel context, like before, and give it the ID “camel2”. Add the required component `weather`, the required language `groovy` and set the following XML router content (be sure to replace &lt;appid&gt; with your API token):

```
<routes xmlns="http://camel.apache.org/schema/spring">

  <route>

    <from uri="weather:dummy?appid=<YOUR API TOKEN>&amp;lat=48.1351&amp;lon=11.5820"/>
    <to uri="stream:out"/>

    <unmarshal><json library="Gson"></json></unmarshal>
    <transform><simple>${body["main"]["temp"]}</simple></transform>
    <convertBodyTo type="java.lang.Double"/>
    <to uri="stream:out"/>

    <transform><groovy>["TEMP": request.body-273.15]</groovy></transform>
    <to uri="stream:out"/>
    <to uri="seda:output1"/>

  </route>

</routes>

```

After applying the changes, you can create two new components in the Wire graph:

- Create a new “Camel Consumer”, name it `consumer1`
    - Set the Camel context ID `camel2`
    - Set the endpoint URI `seda:output1`
- Create a new “Logger”, name it `logger1`
    - Set it to “verbose”
- Connect `consumer1` with `logger1`
- Click on “Apply” to activate the changes

## What does it do?

What this Camel context does, is to first start polling information from the Open Weather Map API. It requests with a manually provided GPS location, Munich.

It then parses the JSON, so that we can work with the data. Then it extracts the current temperature from the rather complex Open Weather Map structure. Of course, we could also use a different approach and extract additional or other information.

The extracted value could still be a number, represented internally by a string. So we ask Camel to ensure that the body of the message gets converted to a Double. If the body already is a double, then nothing will be done. But, if necessary, Camel will pull in its type converter system and optionally convert e.g. a string to a double by parsing it.

Now the body contains the raw value, as a Java double. But we still have two issues with that. The first one is, that the value is in degree Kelvin. Living in Germany, I would expect degree Celsius ;-) The second issue is, that Kura Wires requires some kind of key to that value, like a Map structure.

Fortunately, we easily can solve both issues with a short snippet of Groovy: `["TEMP": request.body-273.15]`. This will take the message (request) body, convert it to degree Celsius, and using this as a value for the key `TEMP` in the newly created map.

## Checking the result

As soon as you apply the changes, you should see some output on the console, which shows the incoming weather data:

```
{"coord":{"lon":11.58,"lat":48.14},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":297.72,"pressure":1021,"humidity":53,"temp_min":295.15,"temp_max":299.15},"visibility":10000,"wind":{"speed":1.5},"clouds":{"all":20},"dt":1537190400,"sys":{"type":1,"id":4914,"message":0.0022,"country":"DE","sunrise":1537160035,"sunset":1537204873},"id":2867714,"name":"Muenchen","cod":200}
297.72
{TEMP=24.57000000000005}

```

Every change, which should happen every second, shows three lines. First the raw JSON data, directly from the Open Weather Map API. Then the raw temperature in degree Kelvin, parsed by Camel and converted into a Java type already. Followed by the custom Map structure, created by the Groovy script. The beauty here is again, that you don’t need to fiddle around with custom data structures of the Kura Wires system, but can rely on standard data structures likes plain Java maps.

Looking at the Kura log file, which is by default `/var/log/kura.log`, you should see some output like this:

```
2018-09-17T13:57:10,117 [Camel (camel-15) thread #31 - seda://output1] INFO  o.e.k.i.w.l.Logger - Received WireEnvelope from org.eclipse.kura.wire.camel.CamelConsume-1537188764126-1
2018-09-17T13:57:10,117 [Camel (camel-15) thread #31 - seda://output1] INFO  o.e.k.i.w.l.Logger - Record List content:
2018-09-17T13:57:10,118 [Camel (camel-15) thread #31 - seda://output1] INFO  o.e.k.i.w.l.Logger -   Record content:
2018-09-17T13:57:10,118 [Camel (camel-15) thread #31 - seda://output1] INFO  o.e.k.i.w.l.Logger -     TEMP : 24.57000000000005
2018-09-17T13:57:10,118 [Camel (camel-15) thread #31 - seda://output1] INFO  o.e.k.i.w.l.Logger -

```

This shows the same value, as processed by the Camel context but received by Kura Wires.

## Wrapping it up

Now, of course, a simple logger component isn’t really useful. But as you might now, Kura has the ability to connect to a GPS receiver. So you could also take the current position as an input to the Open Weather Map request. And instead of using my static GPS coordinates of Munich, you could query for the nearby weather information. So this might allow you to create some amazing IoT applications.

Stay tuned for [Part #3](https://dentrassi.de/2018/09/19/apache-camel-java-dsl-eclipse-kura-wires/), where we will look at a Camel based solution, which can run inside of Kura, as well as outside. Including actual unit tests, ready for continuous delivery.
