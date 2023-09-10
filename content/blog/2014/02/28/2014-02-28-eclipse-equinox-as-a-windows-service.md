---
id: 375
title: 'Eclipse Equinox as a Windows Service'
date: '2014-02-28T15:55:20+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=375'
permalink: /2014/02/28/eclipse-equinox-as-a-windows-service/
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
---

In the Eclipse SCADA project we finally wanted to create a setup of the server components for the Windows platform. Ideally all the server tasks should be integrated into the Windows service framework, so that you can stop and start services “the Windows way”.

<!-- more -->

While there seems to be a commercial solution (64bit) from [Tanuki Software](http://wrapper.tanukisoftware.com), we wanted (needed) to go the open source way. Which actually brings one to Apache Commons Daemon. Since we are already using “jsvc” (the Unix way) of the library, is made sense to use “prunsrv.exe” for the Windows side.

The idea is pretty simple, you specify a class that has two static methods (start and stop) which perform the task of starting and stopping your service. The service wrapper “prunsrv.exe” will take care of loading the JVM. “start” and “stop” will be executed in the same JVM instance, so if you have a global instance variable you have no issues here. Luckily Eclipse/Equinox already has an appropriate class: [EclipseStarter](http://help.eclipse.org/kepler/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fapi%2Forg%2Feclipse%2Fcore%2Fruntime%2Fadaptor%2FEclipseStarter.html).

Now comes the facepalm part: While the start method sure must have a signature of “void method ( String \[\] )” for prunsrv.exe to run, I don’t understand why the “stop” method MUST have the same signature. Of course the authors of EclipseStarter thought the same way, so the stop method (called “shutdown” in this case), accepts no arguments. Which makes prunsrv.exe fail to stop the service.

So it was necessary to wrap the call to EclipseStarter in a separate class and provide the correct method signatures:

```
@SuppressWarnings ( "restriction" )
public class EclipseDaemon
{
    public static void start ( final String[] args ) throws Exception {
        EclipseStarter.main ( args );
    }
    public static void stop ( final String[] args ) throws Exception {
        EclipseStarter.shutdown ();
    }
}

```

Since the EclipseStarter class marks itself as “internal” it necessary (or convenient) to use `@SuppressWarnings ( "restriction" )` for masking out the warnings.

Now the class has to be built to a JAR file and installed with the software. So assuming you installed everything to “C:\\MyApp\\” and you have “C:\\MyApp\\plugins” with the Equinox OSGi bundles (including “org.eclipse.osgi\_\*.jar” and “org.eclipse.scada.utils.osgi.daemon\_\*.jar”), you can create a service like this:

```
prunsrv.exe //IS/MyService
  --Classpath "C:\MyApp\plugins\org.eclipse.osgi_<version>.jar;C:\MyApp\plugins\org.eclipse.scada.utils.osgi.daemon_<version>.jar"
  --StartMode jvm
  --StartClass org.eclipse.scada.utils.osgi.daemon.EclipseDaemon
  --StartMethod start
  ++StartParams -console
  ++StartParams -consoleLog
  --StopMode jvm
  --StopClass org.eclipse.scada.utils.osgi.daemon.EclipseDaemon
  --StopMethod stop

```

See also:

- Full source code of bundle with wrapper class – <http://git.eclipse.org/c/eclipsescada/org.eclipse.scada.utils.git/tree/org.eclipse.scada.utils.osgi.daemon>
- [DAEMON-315](https://issues.apache.org/jira/browse/DAEMON-315)
- [bug #429293](https://bugs.eclipse.org/bugs/show_bug.cgi?id=429293)
