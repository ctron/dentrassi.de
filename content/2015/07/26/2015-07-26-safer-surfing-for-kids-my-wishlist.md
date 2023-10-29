---
id: 638
title: 'Safer surfing for kids – My wishlist'
date: '2015-07-26T19:15:30+02:00'
author: 'Jens Reimann'
layout: post
guid: 'http://dentrassi.de/?p=638'
permalink: /2015/07/26/safer-surfing-for-kids-my-wishlist/
spacious_page_layout:
    - default_layout
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - 'Technical Stuff'
---

At some point my son will start surfing … the web. Now as with all other things, I’d like to protect him, but I also know, there is nothing like a 100% security, neither in real life, nor in the internet. The main task for me, as a parent, it so prepare him. I’d like a bit of technical help though. Here is my list of wishes.

<!-- more -->

I know that this is a troublesome topic, and several approaches have already been tried. Some people in Germany came up with ideas limiting child unfriendly content to times after 10pm (like for TV channels), or prohibit entrance to those sites (like shops in the “real world”). And while is do understand the idea of actually restricting access I personally think that it is more the parents task to explain the situation, rather than to blame others when something went wrong. But on the other side, I also do think that children should be prevented from stumbling in to something by accident, which is not suited for them.

The main thing most people calling for limits on content on this topic do wrong is that they compare the internet with the real world. The fact is, that between a website and the browser on the other side, nothing is sure. If you do want to buy alcohol and you do look “too young”, you will get asked for your id/passport. Easy. But which browser session looks “too young”, which “id” is actually shown? The internet just does not work that way.

## So what can be done?

Simple filtering and limiting all and everything is a crappy solution. And, looking at Great Britain, for example easily tells you what can go wrong. First everybody who feared that this could be used for censoring content was put up as an idiot, and then websites got blocked which had nothing to do with “unsuitable” content.

So what do I want? That is easy, I want to put up limits. Me, as a parent. So if I decide “no naked breasts” I make this decision, and I don’t want Facebook to make that decision for me, or my son. So people providing content to need to categorize it, flag it with tags which might indicate offensive content. Impossible? This is done every day for video games, books and movies. And even there you can see the “full control” idea failing, which some people have. Sure, some movies are not sold to children because of age restrictions, but parents easily can circumvent that. So again, parents are making these decisions, so let them!

And, these categorizations have to be on a “best effort” basis, and non binding, if you do want to get content providers into this. If you make the providers of content in the web responsible for not flagging content, everybody will step back and fight the system, because everybody working with web services and content knows that the web really is a web. Content is integrated from difference sources, and somebody might just write the word “fuck” in a comment for a USB hub he bought on Amazon, still Amazon should not be made reliable for not flagging its store, or this page, as “unsuitable for children” or “hate speech”, this will simply not work.

Second, allow me to set up my browser, or the browser of my son, to reject content with specific flags. This can also be done in “incognito mode”, no harm done. When content comes back, categories (provided vs blocked) are evaluated and the page is shown or not.

## How to get there

So this would basically be enough. But now, who has an interest to actually limit their audience. Because this is what a web site owner actually does. First you have the effort of categorizing your website, and next your audience is getting smaller because of just that.

So making this as easy as possible from a technical perspective is a must. As is the fact that content providers must not be made liable for glitches in their categorizations. It is about the core content of the web site, not details. In a social media website there might turn up naked people, but as long as this is not a website about naked people, it is a glitch in the system.

Give web site owners who categorize their content a benefit over others. Now who can do this? Easy, search engines! If you want more traffic than others, categorize your content!

Which adds another benefit: Search engine results can be marked if they are suitable for your browser setup or not. If the browser does send its category permissions to the web site it is visiting, the web site \_can\_ evaluate this (still the browser has to enforce this), but also the search engine can visually mark content as “not suitable”. Again, filtering this out, is not a good idea. You will never find this content. If something goes wrong, you will never have a talk with your child about why this was flagged wrong, or why this may be an exception to the rules you put up! Your child will learn nothing other than: this is a bad and broken system!

## How to make this easy?

Every page you request will receive your setup in an HTTP header: `Rejected-Content-Categories: violence, alcohol`, That should be easy, as long as there is a list of well-known categories.

Every response will deliver as similar HTTP response header: `Content-Categories: violence, nudity`

Again, very easy. The omission of this header just shows that the categorization process is not being performed. Which brings as back to were we are now. So it is not worse.

For the main HTTP request this is being evaluated, for sub-requests (like JavaScript, CSS) this is not. So the header has not to be sent there. But doesn’t that open a loophole where you could load content using Ajax requests and inject this … again, this is a “best-effort” idea, which tries to prevent your child from “stumbling” into this content. If your child wan’t so see naked people, it will probably find a way to do so. Talk with it first! This helps more than any technical barrier!

So in order to not put this header into every reply, it could be sufficient to add this content to a “categories.txt” file in the root of your domain, or into a DNS record if your domain. This would allow to manually categorize your content if your web site software does not support this. This will be evaluated in the order http header, then categories.txt, then DNS record.

Impossible? This is currently done by SPF for detecting spam or you have the “robots.txt” for your content.

## So what would be have?

- The browser tells the other side (the website) what it rejects by sending the HTTP header `Rejected-Content-Categories`. The web site may use this to mark content, reject the request or issue a warning.
- Web sites which want to take part of this either reply with an HTTP header `Content-Categories`, or place this into their “categories.txt”, or add it as a TXT record to their DNS zone.
- The browser prevents displaying content which is considered “rejected” on its own.
This would by a set of small changes, drastically improving the situation.


## What needs to be done?

- Create and standardize a list of categories, not too big and easy to understand
- Browsers (including mobile browsers!) would need to be changed to adapt this behavior, could also be done as a plug-in
- Web site owners would need to categorize their content
- Search engines would need to actually evaluate the content and make people aware of this

## The sad part

Of course nobody will do this “on their own”. For a critical mass, you would need one mainstream browser, a big search engine, and a few sites which step in.

So if you feel like doing this, let me know, I will help!

## Update

One thing I did not mention was that it is on purpose not to use age restrictions. Again, the internet does not work that way. While in Bavaria the topic of “alcohol” might be considered trivial, in the US it might be a topic which is allowed for people 21+. So you simply cannot group restrictions by age. It might be possible to create a default set of rejection categories based on countries and age, but this is something which could be used as a default setting in the browser.
