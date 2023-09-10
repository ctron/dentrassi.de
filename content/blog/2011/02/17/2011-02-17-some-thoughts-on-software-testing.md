---
id: 85
title: 'Some thoughts on software testing'
date: '2011-02-17T12:17:35+01:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=85'
permalink: /2011/02/17/some-thoughts-on-software-testing/
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
---

If you are working as a software developer in a project based development environment you will, hopefully, encounter the day the customer wants to see the result that was promised to him. The worst thing that can happen is that after months of development you finally end up in a scenario of <q>it is not working</q> or <q>it is not what we need</q>. Sure there are numerous reasons of why this happened and what types development process you could have used. But often quality management and software development definitions are written once and never lived as described. developers consider it a burden that is unnecessary and is blocking them in their daily task of creating new functionality.

<!-- more -->

While one can argue about the pros and cons of formal quality management and rules of software development processes it ends up in the psychology of the team if and how good the testing has been performed. Some simply tricks ease the whole process and improve the result without adding lots of rules and frustration:

# Reduce deployment times

If it takes 30 minutes from one change in the source code to the living result on the test system it will take ages to find and solve issues. Of course a coordinated build system is an important part of development. But quickly patching an issue is as well. If you need three steps to solve the issue and need half an hour to create a new version you have wasted 1½ hours instead of maybe five minutes if your development environment is quick enough. Not all issues can be resolved on the local development machine, so deployment has to be quick on the path up to the integration and testing system.

# Early set up of a test system

Two days to the test. Everybody is confident that testing will go well. Everything was tested… on machines of developers. Installing the system on the testing machines turns out to be a huge problem and the day your customer arrives you have a badly set up system, developers worked over night and weekend to find the remaining hard coded path of <q>/home/user/local/development</q> which are not working in the test system.

Adding different operating systems of developers, additionally installed software packaged and more system resources the development system is always different to the test system. In addition you normally don’t deploy your software in the development system but simply start it from the IDE.

So as soon as you have your first few functions, set up a test system and deploy you software as it would be done during the real testing. You will be surprised how many bug/issues you will find in advance.

# Test with the customer

If you have your test system that early you can also invite your customer to test with you. While not all customers are interested in that, some are and you should take the chance to do so. The first thing you will think is something like <q>this costs us more time than it is worth</q>. But in the end you have tested most functionally long before your final test and end up with a test system that is already known by your customer before the tests start. Unexpected but correct reactions of your system are already common knowledge and need no explanation. And of course you will get feedback much earlier and can integrate that into your development process ending up with a product that is much closer to your customer than introducing him to a brand new system on day 1 of the test.

Also let your developers test with the customer. Hiding developers in the basement and letting management perform the testing is not always a good choice of job assignment. There may be good reasons to let management do the final and formal testing. But during the beginning direct contact with the technical counterparts of your customer and your developers will give your own people a much better understanding of what the customer needs and you will loose much less information in the process. Many developers will also see this as benefit of seeing where their solution will later be put to use. Of course some prefer the basement ;-)

# Add obstacles between test and development systems

While a short path between development and test system is important it might turn out to be good idea to add some temporary obstacles to that path. Otherwise you might end up with two development systems instead of one development system and one test system.

Cutting of the network access or relocating the machines to a different part of the building are some ways to do that. This will pull people together in one room for testing and bind their focus in the subject. And it will also show that when the system is productive in the future the way to reach it might be a lot more problematic than just connecting to a local server. New ideas and ways of how to test and debug will automatically turn up and can later be used in the productive system.

# Who is testing

At least one person <q>non developer</q> should be responsible for testing. This does not mean that no developer should test but people tend to test the same way all over again. Just using the system another way might turn up lots of interesting issues. You will encounter situations you only can get out of using a developer, which will not be possible in the productive system. So the earlier you let people test that do not know the source code and can influence system internals the earlier you will get a system that can be managed by administrators of your customer alone (if this is what you wish). In the end the customer will click in a different way and will find issues with his approach on the system.

Also if you focus on special &lt;q&gt;test users&lt;/q&gt; reduce the problem of having all developers think &lt;q&gt;the other one&lt;/q&gt; tested that cool new feature which went out untested.

# Test cases

I am a little biased about automated test cases. In the end you will have a manual test. Most systems I know cannot be completely tested using an automated test system. Developing a specialized solution in one project is totally different to a product that developed once and sold many times. Writing test cases can be quite difficult and time consuming. if you have to re-write them for every new project it might turn out easier to just perform then <q>manually</q>.

On the other hand automated test cases definitely will improve quality. But the are no guarantee for successful test with your customer. You will never reach a point where you have your system covered 100% by your automated tests. See it reaching light speed. You never can and getting closer will cost you more and more energy. Also automated test cases are just source code that might contains bugs ore may simply be wrong.

# Finally

There is lots more to say about testing. Important is to test early, often, quick and separated and as realistic as you can.
