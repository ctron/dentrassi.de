---
id: 694
title: 'The ConPanion'
date: '2015-11-29T21:12:19+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=694'
permalink: /2015/11/29/the-conpanion/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Ideas
    - 'Technical Stuff'
---

While preparing for EclipseCon Europe 2015 (a few weeks back I have to say, it was a great conference) I again wanted to a have a small mobile helper. So instead of forgetting (again) about it, this time I briefly wrote it down. So here it is.

Going to a conference I do want to have the schedule in advance, I want a nicely rendered view on my mobile phone, offline(!), making plans which talks to attend while riding public transportation. Clicking together a plan. Now for this to work, the conference itself has to provide some sort of data set to make this happen. I really don’t want to have a specific mobile app for each conference. Also adding all the features I do have in mind would crash all budgets which might be available for a single conference. No, the basic idea is to make one tool and let the conference publish the information itself. So the tool simply picks up this … let’s say, XML file, containing all the information necessary for the mobile helper (ok, use JSON if you like that better).

So the effort for the user is to download the app (once) and the conference simply has to provide (and update) an XML file. This is “Tier 1” or the “Free Tier”.

Now we do have two additional tiers (groups of services) which could be used to bring in money, but in any way they will cost money for hosting.

The first group of extensions is some sort of default, additional services around the conference. Like ad-hoc meetings for example. Type a hashtag and create a new ad-hoc meeting and gather a interested persons to have a chat (an easier version of EclipseCon’s BoFs). This requires some backend service, to money has to be spent and in the other way round it has to be earned. Of course it would also be possible to offer car rentals, hotel reservations etc.

The second group of extensions to the app would be the service to host the content for the conventions. Not all conventions are softare developer conferences (at least I heard that), so maybe the conference does not want to fiddle around with the XML data set itself, but have a beautifully designed web UI which does all the magic.

I did write up the ideas in a PDF file, but don’t expect too much additional information. This is the basic idea.

Read the PDF: [ConPanion.pdf](https://dentrassi.de/wp-content/uploads/ConPanion.pdf)