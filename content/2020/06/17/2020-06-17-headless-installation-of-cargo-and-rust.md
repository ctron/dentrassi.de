---
id: 4420
title: 'Headless installation of Cargo and Rust'
date: '2020-06-17T15:56:22+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4420'
permalink: /2020/06/17/headless-installation-of-cargo-and-rust/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";b:0;s:11:"_thumb_type";s:10:"attachment";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";N;s:11:"_thumb_type";s:10:"attachment";}'
taxonomies:
  categories:
    - 'Technical Stuff'
  tags:
    - Rust
---

When you want to containerize your Rust application, you might be using a prepared Rust image. But maybe you are a bit more paranoid when it comes to trusting base layers and you want to create your own Rust base image. Or maybe you are just curios and want to try it yourself.

<!-- more -->

Getting `cargo`, the Rust build tool, into the image is probably one of the first tasks in your `Dockerfile`. And it is rather easy on an interactive command line:

```bash
curl https://sh.rustup.rs -sSf | sh
```

## Automated container build

However, running inside a container build, you will be greeted by the nice little helper script, asking you for some input:

```
Current installation options:


   default host triple: x86_64-unknown-linux-gnu
     default toolchain: stable
               profile: default
  modify PATH variable: yes

1) Proceed with installation (default)
2) Customize installation
3) Cancel installation
>
```

In a terminal window this is no problem. But in an automated build, you want the script to proceed without the need for manual input.

## The solution

The solution is rather simple. If you take a look at the script, then you will figure out that it actually allows you to pass an argument `-y`, assuming defaults without the need to input any more details.

And you can still keep the “one liner” for installing:

```bash
curl https://sh.rustup.rs -sSf | sh -s -- -y
```

The `-s` will instruct the shell to process the script from “standard input”, rather than reading the script from a file. In the original command it already did that, but implicitly, because there was no other argument to the shell.

The double dash (`--`) indicates to the shell that everything which comes after, it not an argument to the shell, but to the shell script instead.

And finally `-y` is passed to the script, which is the cargo installer.

## Thanks

I hope this comes in handy to you. It took me a bit to figure it out. Of course, not only in the context of containers, but for any headless/silent installation of Rust.
