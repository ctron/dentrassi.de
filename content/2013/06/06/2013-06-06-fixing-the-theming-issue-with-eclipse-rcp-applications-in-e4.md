---
id: 295
title: 'Fixing the theming issue with Eclipse RCP applications in E4'
date: '2013-06-06T13:47:35+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=295'
permalink: /2013/06/06/fixing-the-theming-issue-with-eclipse-rcp-applications-in-e4/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
  tags:
    - e4
    - Eclipse
    - RCP
---

It seems that migrating from Eclipse RCP 3.x to E4 (Eclipse 4.x) is not a quick win. If you already have an RCP based application the switch to E4 turns out to be a real problem. As is the E4 way if you want some sort of “custom” application that features some IDE components (like a perspective switcher or about dialog). It seems a bit strange that the migration from 3 to 4 is such a bumpy ride. Although there a are lots of tutorials, they mostly only scratch the surface of the task to convert a full-blown RCP application. But this should be a rant on E4, I hope that the next releases improve that situation a lot.

<!-- more -->

When I migrated our RCP Application (OSTC from openSCADA) to E4 using the RCP bundle of E4. This seems not to be a real E4 application, but allows one to run a legacy, 3.x, application inside the new E4 environment. A quick it-just-works migration, still you miss all the E4 fun. But at the first start the user interface looked up bit garbled up. Some black line drawing artifacts. The tabs where a bit “dull” compared to the facy new tabs in E4.

The solution was pretty simple, the final RCP application was missing the bundle “org.eclipse.platform” which contained the themes and the necessary resources.
