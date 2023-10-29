---
title: trunk-ng, the fork of trunk
description: |
  This blog post lays out the reasons why I decided to fork trunk, what the current state is, and what could be the
  future.
author: Jens Reimann
taxonomies:
  categories:
    - Technical Stuff
    - Open Source
  tags:
    - Rust
    - WebAssembly
    - Frontend
---

[`trunk`](https://trunkrs.dev/) is a great piece of software! When I started with Rust on the frontend, the
webpack `wasm-pack` plugin was the best tooling one could get to compile and package a Rust-based web application.
However, that also included a toolchain full of JavaScript tools, the kind of stuff I actually tried to avoid. When
Its development came to a halt, `trunk` showed up, and it was the tool I was hoping for.

Unfortunately, it seems that the development of trunk came to a halt too. Now what?

<!-- more -->

## About trunk

Trunk is a nice, little tool that orchestrates the build of a Rust/WebAssembly based build for the frontend
(aka web browser). Compared to [`webpack`](https://webpack.js.org/), it performs a similar job, but in a much more
focused way. Some might find this limiting, but it makes the whole process much less complicated.

In times of the `wasm-pack` plugin, there were a lot of issues around the `webpack` tooling. `webpack` moved on, the
plugin didn't follow up, and the whole integration was there, but far from ideal.

Trunk changed that situation completely. It was a "rust first" tool, rather than an afterthought. But it was also much
more effort than "just" having a plugin for the existing toolchain of webpack. [Anthony Dodd](https://github.com/thedodd),
the main author of trunk, did an amazing job.

## The build up

So, what's the issue? Like any other software, trunk has a few issues, some missing features, and some things which need
maintenance over time. And people actually raised issues and came up with PRs. But the rate at which they got merged
and feedback was given, wasn't great.

A more important issue was the one that piled up change events in the build trigger queue. As I am a daily user of
trunk, and know some Rust, I thought I'd fix this issue. I contributed to trunk before, it was slow, but worked out.
In this case, however, it took 4 months until I got the feedback: not this way.

Technically the fix would have worked. But I also understand the feedback. So I did re-implement the solution in the
newly suggested way. After another month of no reply, I raised an issue,
[asking about the state of the project](https://github.com/thedodd/trunk/issues/588).

I also decided to create a fork, in order to release this single fix for the team I am working on. As I was hoping this
would only be temporary, I went for the rather boring name `trunk-ng`.

That got the ball rolling. I got into a bit closer contact with the `thedodd` and the PR was merged. Yay!

## A note on open source and the people behind projects

Maybe this is the right moment to write a few words on open source, open source projects, and the expectations towards
them. Some projects may be maintained by companies, even big ones. But some projects are not. People might fix some
of the problems they have with a tool, and share it wither others, in the hope that it's as useful to them.

That doesn't mean, however, that they offer 24/7 support, or free consulting around it. With open source, people are
encouraged to contribute and contribute fixes and improvements themselves. And if everyone does that, it may grow into
something bigger.

In any case, a project might still be backed by a few, or even just one, individual. And each person has a personal
life. Priorities might change, and more important things might cause a shift in focus. Or maybe someone simply loses
interest.

And that's OK! It helps to communicate that fact. But in any case: **IT IS OK!**

## More silence

After this PR was finally merged and understood the situation of the project a bit better, I wanted to help out more
and groomed through the existing, open PRs, in order to get people on board rebasing them and fixing them up to get
them merged too. There were a bunch of simple and small ones, quick wins.

Turns out that the change right after my PR (the cooldown), introduced a behavior that led to some weird behavior of
`trunk`. After a build was completed, all change events so far were discarded. This might lead to some stale state,
where the content of the served frontend no longer reflects the code in the filesystem.

I started to work on a draft PR, to get some more information from people running into a similar issue on Windows, and
at the same time tried to get at least one more PR from some other contributor merged.

I learned from `thedodd` that he will not have much time for `trunk` at the moment (and that's ok, see above!),
but also the suggestion to reach out to the other maintainers only ended in more silence. People also seemed to get
frustrated with the GitHub bot closing issues due to inactivity (never a good idea IMHO).

## The fork

In a case where a project gets stalled by the lack of maintainers, there's a simple solution in the open-source world:
forking the project.

Some might see this as a negative thing. Even aggressive. But I don't think that should be the case. It's just a point
in time where people's interest diverges. Or, like in this case, where one project becomes unresponsive, other people
can pick it up, and keep it alive and useful to others.

As I already had the GitHub infrastructure in place, it was easy to rebase and continue the work.

## What's the current state?

As pushing out new releases is pretty much automated, it's easy to add some more changes and get them out. As I groomed
through open PR before, if cherry-picked some of them into trunk-ng, and released those too. There is a fix in
there for race conditions while copying, or some enhancements and doc fixes.

If you have some more, please let me know, and raise an issue. I will take a look.

There's also a new Nix package which should be available soon.

## And beyond?

Judging from the list of issues and open PRs, there are some topics that people seem interested in. I can't fix all of
them, but maybe, where my interest overlaps, I can try. Or if you reach out to me, and it's a small issue, that seems
important to you, I might be able to take a look. Just like the Nix package, I don't use it, but I am also eager to learn
something new.

There's one more thing I really wanted to tackle at some point, I simply was afraid a larger PR like this might get
stuck. Whenever a build fails, you're not aware of this in the front end. Wouldn't it be great, if the front end would
give you an error indication? Definitely a thing we could learn from webpack.

Ultimately, I truly hope all those changes end up in proper `trunk` and the fork will no longer be necessary.

But until then, let's get moving!

## Links

* GitHub [ctron/trunk](https://github.com/ctron/trunk) (the `trunk-ng` branch)
* Homepage: <https://ctron.github.io/trunk/>
