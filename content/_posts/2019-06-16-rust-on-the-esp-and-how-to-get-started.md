---
id: 4259
title: 'Rust on the ESP and how to get started'
date: '2019-06-16T16:18:55+02:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4259'
permalink: /2019/06/16/rust-on-the-esp-and-how-to-get-started/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4266";s:11:"_thumb_type";s:5:"thumb";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";s:4:"4266";s:11:"_thumb_type";s:5:"thumb";}'
image: /wp-content/uploads/rust-logo-512x512.png
categories:
    - 'Technical Stuff'
tags:
    - container
    - embedded
    - IoT
    - rust
---

I have been working with ESPs, for playing around in the space of IoT, for a while now. Mostly using the ESP8266 and Espressif, through platform.io. In recent times, I have also started to really like Rust as programming language. And I really believe that all Rust has to offer, would be great match for embedded development. So when I had a bit of time, I wanted to give it a try. And here is what came out of it *…*

Up until now I only used the ESP and Rust on a very high level. So I was hoping to get some kind of an “out-of-the-box” solution. Well, we are not there yet. But my only intention was to play around a bit with the technology. And so I started to search what others had done in this area already.

## LLVM &amp; Rust

Rust, or more precisely, the default rust compiler is based on LLVM. It compiles rust code by parsing it and handing it over to the LLVM toolchain at some point. So as soon as LLVM can create code for the Xtensa target (the CPU of the ESP), that first step of being able to compile code for the ESP should be achieved.

The good news: work for this is already underway. There is a [fork of LLVM for Xtensa](https://github.com/espressif/llvm-xtensa), which seems to be provided by the people behind the Espressif framework. Having support for LLVM will enable all other kinds of integrations, Rust for the ESP is just one of them. The bad news: this is more or less “compile your own”. And have you ever compiled a compiler, which is needed to compile a compiler? ;-)

So the next step, after compiling LLVM (on a x64 target, with the ability to cross compile to Xtensa) is to compile Rust itself. Actually, that wasn’t too bad. It takes a while, but the process of compiling Rust with a provided version of LLVM is more or less straight forward. Assuming that you use a version of Rust, patched for providing the Xtensa target architectures, which is already available on GitHub at [MabezDev/rust-xtensa](https://github.com/MabezDev/rust-xtensa) (be sure to use the `xtensa-target` branch).

## Cross compiling with Rust

After this, you are basically set up for getting started. However, it still is a bit complicated, as you do need to cross compile with Rust for the ESP. You are running Rust on your host machine (x64) and want to build for the Xtensa target architecture. This requires also to compile the core Rust crate for that architecture. This is where `xargo`comes into play.

[Xargo](https://github.com/japaric/xargo) helps you build your project (like `cargo`), but it also supports building the “sysroot”, which is required by each rust application. I know that on the Xargo GitHub repository you will find a note, which says that it is in “maintenance mode”. But for one, the tool just works and does what it should do. And second, I also do understand the original author of the tool, setting the right expectations. It also seems that there is work underway in Rust to [make this tool obsolete](https://github.com/rust-lang/rfcs/pull/1133). Maybe it already is done and I just need to check ;-)

## ESP Hardware Abstraction Layer

So we have a compiler now, and the core foundation to run Rust on the Xtensa architecture. But of course, we do want to interact with the ESP functionalities. At least, let an LED blink or print something out on the serial console.

And this is where it gets complicated. When running on an embedded system, you don’t have a “kernel”, you don’t have “drivers” and you don’t have something like a “libc”, which does all the work for you, and that e.g. Rust can be based upon. The right thing to do would be to start writing everything in Rust, from scratch. Having a full “std” crate on Rust, would basically allow you to re-use all the “rust native” crates that are available on [crates.io](https://crates.io). At least as long as they fit into your embedded system of course :-)

But we don’t (yet) have a “standard crate”, we only have the bare minimum “core” crate to work with. Now, there is a simple way around this. And yes, it feels a little bit like cheating.

The Espressif [IoT Development Framework](https://github.com/espressif/esp-idf) framework (IDF) already provides all kinds of drivers and components to work with the hardware of the ESP. So, why not re-use that? A good reason to not re-use that is, that it is not written in Rust, and has all the problems of classic C code. But on the other side, it is available right now :-)

## Wiring up ESP-IDF

In a nutshell, the IDF is a framework, which provides all the required bits and pieces to create applications on top of the ESP. It is written in C, and provides you with a modular build system (welcome back `make menuconfig`) that allows you to select which components and features you would like to compile in.

The basic idea is to build a normal “ESP-IDF” based project. And then you use Rust to build your application, pulling in everything except the C based “main” method from that project. That way, when your application starts up, you have the ESP HAL from the IDF, but your Rust application code.

The final step is to allow your Rust code to call into the C code of the ESP-IDF. You can use a tool called `bindgen` from Rust, in order to achieve this. Bindgen creates Rust bindings for C libraries, and this is exactly what we are looking for.

There is a basic example at [lexxvir/esp32-hello](https://github.com/lexxvir/esp32-hello), but it took me a while to tweak it and get it working. It also only uses the UART, which also pulls in the GPIO, but it shows the basic concept of the idea.

## Making Rust for ESP “out-of-the-box”

Figuring out all of this, and getting it actually working, took me the better part of a Saturday. It was fun digging a little bit into all of this, but it would be great if there was this “out-of-the-box” solution that I was looking for. Honestly I forgot probably half of the pitfalls when writing up this blog post. And didn’t tell you about the hours and hours of compiling and re-compiling.

So I did write it all up in a [Dockerfile](https://github.com/ctron/rust-esp-container/blob/master/Dockerfile) (full repository: [ctron/rust-esp-container](https://github.com/ctron/rust-esp-container)). And crated an automated build for that on [quay.io](https://quay.io/repository/ctron/rust-esp). Why not Docker Hub? Because it couldn’t handle the build. The builds ran much longer, and always timed out before they were even close to complete. And this container isn’t a small one. Even after cleaning up intermediate layers, it still is around 5GiB.

Now it is possible to just use `docker`, mapping a local folder into that container, and let the pre-compiled Xtensa toolchain do the build. There is a short introduction in the [README](https://github.com/ctron/rust-esp-container/blob/master/README.md), which should help you get started pretty quickly.

## Caveats &amp; What’s next?

Getting started with Rust on the ESP, based on the ESP-IDF HAL is much easier now. However, most of your code will therefore still be C based. Of course that may be OK for you, but using the IDF specific APIs also prevents you from using Rust crates, which expect the Rust standard library. Network access and thus HTTP calls (which was my goal in the beginning) is just one of this. So instead of just using [reqwest](https://crates.io/crates/reqwest), you will need to map in the HTTP layer from IDF, `bindgen` this to rust in order to do HTTP.

So my hope is that there all the temporary changes and forks, used in this setup, get merged into their upstream sources. LLVM and Rust directly supporting Xtensa. So, that the next step, can be to build some standard library support for Rust. And so you would be able to use most of Rust’s ecosystem on an ESP, without too much trouble.

But for me, I am happy to share my experience, and try to provide this container image in order to make things easier for people that want to get started quickly. I will be trying to improve this, after all, my goal of sending HTTP requests from Rust it not yet reached. After all, this helps me to not re-start from scratch, every time I find a few minutes to play around with this. And maybe it helps you as well.

If you find any bugs or have improvements, contributions are always welcome.

## Thanks to … 

I would have never been able to figure all of this out, without the help of:

- <https://quickhack.net/nom/blog/2019-05-14-build-rust-environment-for-esp32.html >
- <https://esp32.com/viewtopic.php?t=9226>
- <https://github.com/MabezDev/rust-xtensa>
- <https://github.com/lexxvir/esp32-hello>