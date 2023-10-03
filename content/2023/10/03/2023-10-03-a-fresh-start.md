---
title: A fresh start
description: |
  An update on the state of the blog, it's migration away from WordPress to Zola, and what my plans for the future are.
author: Jens Reimann
categories:
  - Technical Stuff
---

More than [10 years ago](@/2011/01/26/2011-01-26-hello-world.md), I switch my personal blog from iWeb to WordPress.
iWeb was fun for a small, personal homepage. But it also stopped working, and so I decided to give WordPress a try.
Turns out, it was fun too. It was super easy to write posts, which lead to a good number of posts over the last few
years.

And yet, there's a big gap between this post and the last.

## WordPress, oh WordPress

**The good:** Installing WordPress was simple, … trivial actually. And once it's on a server, creating a new post is
even simpler. I never had any issues upgrading, for more than 10 years. That's an amazing record. So the barrier of
adding more content was actually rather low.

**The bad:** Themes! The defaults ones never really worked for me. Except the one which didn't really support mobile.
Finding a good theme is hard, creating one a monstrous task. The web still feels like a mess, and with WordPress,
creating your own theme doesn't only include HTML, CSS, and JS … but also PHP. In the end, I bought a theme, and I have
no problem paying for that work. But as with the plugins, that also leads to the dilemma developers face.

**The ugly:** Feature bloat! Paying for decent plugins and themes is ok. Someone needs to do the work. But if people
pay money, they expect features. So developers keep adding stuff to their products, because that is what customers
expect. And so you end up with a super-massive theme, and giant plugins. Which sometimes cause trouble, and yet you're
missing another option, forcing you to get yet another plugin.

The worst part of this: all those plugins and themes leave a trail through your actual content. WordPress migrated to a
nice "block" system. Themes contribute new blocks, but only as long as you use those themes. And if you don't re-work
all the old blog posts, it becomes even more of a mess.

## Meanwhile …

… I worked on some projects which used static page generators for creating their homepage or blog. Writing content in
markdown is something I always wanted for WordPress too, but couldn't get there. So the motivation to fiddle around with
content blocks, theme settings, and other problems, just to get out a new blog post … well, I was avoiding my own blog
and posted stuff elsewhere.

Up until I wrote a blog post on Rust and WebAssembly. It was targeted for [opensource.com](https://opensource.com/).
But as you might have noticed, that's no longer an option. Wouldn't it be great to have my own place to publish stuff?
Wait a second, …

## Keep it static simple

Assuming I could start from scratch, what would I want? Write some kind of Markdown, and get stuff published. Sure I
want a supportive editor, but there are plenty of them for Markdown these days. Oh, and git. Storing markdown files in
git is just way easier than storing WordPress content blocks in a SQL database.

There are a bunch of options out there which give you a markdown to static HTML pipeline. [Hugo](https://gohugo.io/)
might come to your mind. However, I had to use it, and everytime I have to use `gotpl` when using Helm, I am close to
getting insane. Then there is Jekyll, which I struggled with a lot when it comes to Ruby. Though
[Jekyll](https://jekyllrb.com/) itself is nice and flexible.

And then, there is [Zola](https://www.getzola.org/). It's kind of a mix between Hugo and Jekyll. And the best of all,
it is written in Rust[^1].

What I did not want to, is to lose the old content. Or the old structure and their links. Luckily, there's a WordPress
plugin, which exports WordPress to Jekyll, and that also worked quite nice with Zola. It took a bit of time to create
a new template, but the whole process also forced me to groom through the old posts and clean up issues that get
introduced by various WordPress plugins and migrations over time.

The only thing that didn't make it to the new setup are comments. That's the downside of a static blog. And while I am
pretty sure I will miss the great feedback I sometimes got for my posts, I am sure I won't miss the (literally) millions
of spam comments which [Akismet](https://akismet.com/) filtered out, and the hundreds I still had to remove manually.

So, I want to say "hi", or "thank you", maybe [find me on Mastodon](https://mastodon.dentrassi.de/@ctron) where I hang
out these days, or [ping me on Matrix](https://matrix.to/#%2F%40ctron%3Adentrassi.de).

## What to expect?

Just writing this blog post was already fun. I am sure there are still some more things that need mopping up. But I
really want to get out a few blog posts around Rust, WebAssembly, and [Yew](https://yew.rs/). Or maybe some other stuff
I stumbled upon. Hope to see you.

[^1] Honestly, it doesn't matter. But I still like it.
