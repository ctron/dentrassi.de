---
id: 727
title: 'Testing Diaspora – Part 3'
date: '2015-12-31T17:26:21+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=727'
permalink: /2015/12/31/testing-diaspora-part-3/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:734;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - 'Technical Stuff'
  tags:
    - diaspora
extra:
    article_image:
        src: /wp-content/uploads/diaspora.png
        alt: diaspora logo
---

This is the third time I am testing [Diaspora](https://diasporafoundation.org/). I never wrote about the other attempts, but between Christmas and New Year a had a bit of time writing this together.

Motivated by [the article at Heise about diaspora](http://www.heise.de/newsticker/meldung/32C3-Gegen-Gated-Communities-Facebook-muss-seine-Mauern-einreissen-3057076.html), I decided it is time to give diaspora another try. I did try the first version after the crowdfunding campaign and one or two years later.

<!-- more -->

For this test is registered at “despora.de” right here: <https://despora.de/u/ctron>

The first thing I have to say is that it still is a problem to start right away. There are a lot of pods (diaspora servers) running, where you can easily create a new account right away. But then … I did register an account at joindiaspora.org a few years back. Just to find out now that this pod runs on a pretty old version of diaspora and does not accept any new registrations. It looks kind of dead to me. Now I have my account on a pod, I can download my account data. But I cannot migrate my account to a new pod. I have to start from scratch and lost all my social activity. Not that I did much with that account ;-)

So in the end you somehow want to be in control over your pod. And having a diaspora ID which contains your own domain name is just another reason for that. But setting up diaspora is a nightmare. Looking at the different ways, you do need a full virtual server or pay at least $15 each month for running your own cloud instance at some cloud provider when using the Bitnami variant of diaspora. Bitnami again has changed diaspora in some ways, so that diaspora themself ask you to look into the Bitnami wiki first. A few other cloud based approaches ask you to fork and edit the diaspora git repository for a start.

I wouldn’t mind paying a few bucks for hosting my own pod, but paying for a full blowing virtual server and setting up things like redis for one or two accounts on this hud is just oversized.

Joining a pre-existing pod on the other hand, seems like a bad idea, unless you really know who is running the pod. In the end you trust your social account and data to somebody you either don’t know and are not sure that they will keep the pod (and thus your social identity) running as long as you like it.

Of course the same is true for Facebook, Google+ and all the others. But diaspora wants to make a change. So setting up a pod or getting an account that you really control must get simpler!

As it looks to me, right now the diaspora software itself targets installations for a bigger number of users. So each pod should by capable of running as many accounts as possible (although diaspora itself is decentralized). And it really is good that there is a protocol between pods which can be implemented in a different way. So there are implementations of the diaspora protocol which are not based on the diaspora source code itself.

But back to the problem of running a pod that you control. Either there is a “light version” of a pod, which supports a few users instead of a thousand, then sharing a virtual server would be much easier. A docker container, an OpenShift instance, some micro instance on Google Cloud or AWS. That would be much cheaper.

At the same time this would allow one to run diaspora in a Raspberry Pi like device at home. If you are only hosting one or two accounts, your local DSL line is pretty much sufficient for running your own pod.

As sad as it is, I guess this means seeing you all for part #4 in a few years. If you have some spare time, I think contributing to diaspora is a great idea, because the idea behind diaspora is great. But right now, it simply is not my cup of tea.
