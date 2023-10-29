---
id: 165
title: 'Extending OpenWRT'
date: '2012-07-26T15:35:32+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=165'
permalink: /2012/07/26/extending-openwrt/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - Development
  tags:
    - OpenWRT
---

We recently switched from IPfire to OpenWRT in our office. Not only because we let OpenWRT run on an ALIX board (which also IPfire could do), but mostly due to the fact that if you want to extend the system, you really can do it. Development of IPfire seems to be quite difficult, not only technically.

<!-- more -->

On the other hand, OpenWRT quickly provides help if you want to contribute. Even to the “noob” questions you will post in the beginning ;-)

My initial idea was to create a small plugin for OpenWRT which allows one to configure “pptpd” and VPN users using the web interface LUCI. While OpenWRTs configuration system (called UCI) handles the configuraton model in the background, LuCI brings this models to a Lua driven web user interface. UCI and LuCI play well together, you only need to know how it works together.

At first, you will need to set up your build environment (<http://wiki.openwrt.org/doc/howto/buildroot.exigence>) and compile at least the basics (<http://wiki.openwrt.org/doc/howto/build>). This was ok for me since I planned on creating script and lua based stuff only. So there was no big issue with “cross-compile” issues.

Creating new module, you should set up a new “feed” (see <http://wiki.openwrt.org/doc/devel/feeds>). I created a new `feeds.conf` file and added my local git repository. Updating using `./scripts/feeds update myfeed` to pull the updated feed and installing the module from your feed to your build environment using `./scripts/feeds install custompackage`. After that `make menuconfig` and add the newly added module to your build setup. Build your module only using `make package/custompackage/compile V=99`.

I started with a new configuration file for UCI in “/etc/config/users”. The question was after updating in the LuCI interface (or the command line) how does the change get applied? Editing the configuration using UCI and commiting does nothing at first. You will need a service (/etc/init.d script) which will convert the UCI data you are intereseted in and create a configuration or (or whatever your service needs) and start your service then. Using LuCI there is another configuration (/etc/config/ucitrack) which has a mapping between UCI configurations and services. Once LuCI changes the UCI configuration it also restarts the coresponding service. Since I only wanted to convert my users to a /etc/ppp/chap-secrets file, my “service” was only a start section in an init.d script which simply converted the users and did not start any service at all.

For deployment, the OpenWRT build system created “ipkg” files which can be transferred to the system easily and be applied. In the install and remove script you will need to use UCI’s command line tool in order to add and remove your service from the “ucitrack” configuration.

If you want to see the source of all this, check out <https://bitbucket.org/ctron/th4wrt> which contains the background “service” and the LuCI interface.
