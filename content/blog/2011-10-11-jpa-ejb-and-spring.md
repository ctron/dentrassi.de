---
id: 116
title: 'JPA, EJB and Spring'
date: '2011-10-11T18:20:36+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=116'
permalink: /2011/10/11/jpa-ejb-and-spring/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

Today I stumbled over a rather interesting issue in combination with JBoss, Hibernate, Spring, JPA and EJB.

First of all, we have mixed environment of EJB3 and Spring 3 using JPA2. All in JBoss 6 AS, with default Hibernate 3.6 as JPA provider. Now for a long time everything works fine until we re-organize the dependencies of our modules. Starting with that we got some strange JPA behavior like “class is not an entity” and some rather weird getter issues.

Altogether it looked like some classloader issue. But it took some time to find that one.

In the beginning there was a JPA persistence unit called “someModel”. The problem with spring was, that it needs to be imported using the “jee:jndi-lookup” tag, which requires a JNDI name. That one was provided by JBoss itself using the “jboss.entity.manager.factory.jndi.name” property in the “persistence.xml” file. This triggers JBoss/Hibernate to bind the persistence unit with that specified name. Of course the name was “persistence/someModel”.

Now everything grew, EJB was added in order to gain modularity. And now that the dependencies and the start order was changed, the same persistence unit was used multiple times in multiple EJBs beside the spring application. While EJB seems not to have any problems finding its persistence unit, spring needs a bit more information and requires the already discusses “jee:jndi-lookup” tag in order to find its persistence unit.

As it turned out, the multiple persistence units all registered with the same name, leaving spring with the first (or last) registration, but not necessarily the correct registration. So spring accesses “some” persistence unit with that name and possible used the wrong classloader.

The solution was quite and and lot cleaner than using the “jboss.entity.manager.factory.jndi.name” property. But, less intuitive I have to say.

In the “web.xml” of the servlet that starts the application context a reference has to be added to the persistence unit:

\[sourcecode language=”xml”\]  
 &lt;persistence-unit-ref&gt;  
 &lt;persistence-unit-ref-name&gt;persistence/someModel&lt;/persistence-unit-ref-name&gt;  
 &lt;persistence-unit-name&gt;someModel&lt;/persistence-unit-name&gt;  
 &lt;/persistence-unit-ref&gt;  
\[/sourcecode\]

This will register the local (in the EAR file hosting the WAR) peristence unit “someModel” in the local JNDI space as “persistence/someModel” and you are done. Spring will can still import it as “persistence/someModel”.