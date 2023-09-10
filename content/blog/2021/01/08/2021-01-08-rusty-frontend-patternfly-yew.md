---
id: 4516
title: 'A Rusty frontend: Patternfly & Yew'
date: '2021-01-08T17:52:54+01:00'
author: 'Jens Reimann'
layout: post
guid: 'https://dentrassi.de/?p=4516'
permalink: /2021/01/08/rusty-frontend-patternfly-yew/
inline_featured_image:
    - '0'
tc-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:4531;s:11:"_thumb_type";s:10:"attachment";}'
layout_key:
    - ''
post_slider_check_key:
    - '0'
fpu-thumb-fld:
    - 'a:2:{s:9:"_thumb_id";i:4531;s:11:"_thumb_type";s:10:"attachment";}'
categories:
    - Development
    - 'Technical Stuff'
tags:
    - frontend
    - rust
---

A while back I started to become a real Rust fanboy, so when I wanted to “scratch an itch” of [our car sharing booking system](https://www.elkato.de/), of course I was using Rust for the backend. When it came to the frontend stuff, I was wondering if there is an alternative to JavaScript and so I found [Yew Stack](https://yew.rs), which is simply awesome and allows for a full-Rust solution.

<!-- more -->

## The setting

So we are part of a car sharing community, and that community uses a web based system to book cars. Plain and simple. Every now and then you run into use cases that the booking system doesn’t cover. If it would have some simply API, that wouldn’t be an issue, but all that is does is serve HTML which, well … let’s just say I am impressed that modern day browsers still render this.

Unfortunately this solution isn’t open source, and beside that it is a MS Access “application” coded in Visual Basic if I am informed correctly. So staying away from that is my top priority.

## Creating an API

Serving an API in Rust is simple. There are a bunch of choices, [actix-web](https://github.com/actix/actix-web) being one of them. The bigger issue was, how to I get access to the data?

If a browser can still interpret the HTML, maybe I can write some code to scrape the booking details from those pages? And yes, a bit of Rust, using the [nom](https://github.com/Geal/nom) parser library, and I was able the creating an asynchronous “stream” of Bookings, backed by paging requests to the original web frontend, scraping booking and paging information out of the web pages:

```rust
let now = Local::now().with_timezone(&Utc);
let bookings: Vec<Booking> = client
    .list_bookings(
        User {
            club: "abc".into(),
            username: "def".into(),
            password: Some("123".into()),
        },
        ListOptions {
            owner: Some("def".into()),
            start_from: Some(now.date() - Duration::days(7)),
            end_to: Some(now.date() + Duration::days(7)),
            ..Default::default()
        },
    )
    .boxed()
    .try_collect()
    .await?;

for booking in &bookings {
    println!("{:?}", booking);
}
```

That was simpler than expected (ok, writing that async-stream iterator with paging was not, but the overall solution up to this point was). But I ended up with a 12 MiB (yes, “megabyte”) service that provided me an API for the booking system. At least the API that I needed to scratch my itch. No gigabytes of Spring Boot application, plain and simple.

## Allergic to JavaScript? Here is a way out!

The truth is, I am not a frontend guy. Yes, I did some PHP in the past, and I can create some Bootstrap blog theme. But all the “new” JavaScript approaches give me the creeps. The number of components and steps involved to render some basic HTML and CSS in the browser as simply insane. True, the pattern of “running” a web frontend application in the browser is nice. Only fetching data through APIs, compared to fetching the full rendered view all the time. But to me, JavaScript is still a pure nightmare, and TypeScript is not the solution.

I knew that Rust and WASM was a thing, so I looked around what was available and found [Yew Stack](https://yew.rs/). The idea of yew is pretty simple: enable people to create a [ReactJS](https://reactjs.org/) style application in pure Rust. It describes itself as:

> **Yew** is a modern [Rust](https://www.rust-lang.org/) framework for creating multi-threaded front-end web apps with [WebAssembly](https://webassembly.org/).
> 
> <cite>The Yew homepage</cite>

Just was I was looking for!

## Concepts of Yew

Getting started with Yew is pretty simple. There are a few concepts you need to learn and embrace, otherwise you might have a hard time. Don’t think of it as a “web page”, more like a “web application”. People using ReactJS might already be familiar with that, but if you are used to “rendering” HTML views, it might take a bit. Basically everything is running in the browser, where you have a tree of [components](https://yew.rs/docs/en/concepts/html/components). Each component has a state, a way to render the state, and a way to update the state by sending messages to a component. Yew takes care of orchestrating this internally. So when the state of your component changes, Yew will ask you to re-render yourself, and generates and applies a diff to the DOM tree of your HTML document. Letting the browser render only changed parts.

It will look something like this:

```rust
impl MyComponent for Container {
    type Properties = MyProps;
    type Messages = MyMsg;

    fn update(&self, msg: MyMsg) -> ShouldRender {
        match msg {
            MyMsg::ChangeMyState() => self.counter += 1
        }
        true
    }
    
    fn view(&self) -> Html {
       html! {
           <div id="container">
               <span>{ self.counter }</span>
               { self.props.children.clone() }
           </div>
       }
    }
}
```

As mentioned, the concept is similar to ReactJS in the web world, or [Flutter](https://flutter.dev/) in the app world. Just that you can use Rust, instead of JavaScript or Dart.

## The frontend stack

One thing that is missing in Yew, is a component library. And for good reason! Yew is built on browser features manipulating the DOM tree. But it does not force you into using a specific web framework, like Bootstrap or [Bulma](https://bulma.io/) (though I have to say, I really like Bulma, and there is a project called [ybc](https://github.com/thedodd/ybc), which provides Yew components for Bulma already).

And while I am already using Bulma for other stuff, it felt a bit too homepagey to me. I was hoping for some more data/controls oriented CSS components. So I was looking into the direction of [Patternfly](https://www.patternfly.org/v4/). And while I might be a bit closer to Patternyfly, I still use other CSS frameworks for other stuff as well. But I also had some hopes that I could re-use the work for the [Rust IoT stuff](https://blog.drogue.io/) I am working on.

So I started to create some [Patternfly components for Rust](https://github.com/ctron/patternfly-yew), backed by Yew stack. And while it definitely was a bit slower than simply re-using the existing Bulma components, I was pretty soon able to create the fronted I needed, and learned a lot about Yew on the way.

<figure>

[![Screenshot of bookings view](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Elkato-extras-e1610120101881.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Elkato-extras-e1610120101881.png)

<figcaption>Screenshot of bookings view</figcaption>

</figure>

## More components

That early example comes from a while back. As always, when you start something, and you like it, you might re-use it yourself. So every now and then, I need some more components, and simply map them:

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-1-1024x881.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-1.png)

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-3-1024x935.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-3.png)

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-4-1024x472.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-4.png)

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart-1024x782.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Patternfly-Yew-Quickstart.png)

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Drogue-IoT-Console-1024x881.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Drogue-IoT-Console.png)

[![](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Drogue-IoT-Console-2-e1610121200551-1024x443.png)](https://dentrassi.de/wp-content/uploads/Screenshot_2021-01-08-Drogue-IoT-Console-2-e1610121200551.png)

## Lessons learned

First of all, writing web frontends in Rust is fun. At least if you are a Rust fanboy. You can leverage your existing knowledge an experience from other Rust projects, and while I definitely has to learn a few new things, it feels much more “home” than doing the same in JavaScript.

### No more JavaScript … mostly

All of the compile time checking that Rust offers, are just as helpful in the web world. Assigning a wrong type to a property, forgot to add a match-clause after adding a new enum literal, all caught by the compiler (like calling a wrong method or passing in wrong arguments). No more [JavaScript madness](https://www.youtube.com/watch?v=et8xNAc2ic8)!

Well … not fully. First of all, you need to package your web application somehow. Which means that you need to also include Patternfly, and also may need to run a SASS compiler. Packaging all that up, `wasm-pack` and thus `npm` and `webpack` might come in handy. Still, this is only used for running parts of the build, but it requires you to have a Node JS installation, or a least a container of that.

Second: every now and then, you need to integrate with some existing JavaScript library or browser API. Patternfly for example places popovers using [popper.js](https://popper.js.org/), and so you somehow need to integrate that into your Rust web application. The bright side of that is, using `wasm-bind` and the Yew component system, you can easily hide all of that behind a nice API. It is pretty similar to interfacing Rust to C using FFI.

On the other side, a bit of JavaScript, hidden behind proper APIs, isn’t too bad if you can use Rust for all the other parts of the backend and frontend. And yes, you can actually re-use the same code from the backend in the frontend as well.

### Yew Stack

Yew is a great framework. But it also can be quite overwhelming when getting started. True, the documentation of Yew could be better, and yes I didn’t contribute as much as I could. Shame on me. However, the Yew community has a few [discord channels](https://discord.gg/VQck8X4) and is willing to help.

### WASM

Initially I wasn’t sure if all browsers, desktop and mobile, would be happy executing WASM, but so far, I didn’t have any issues. Fingers crossed!

## I even could…

One concern that came up when demoing the solution was, that my backend would get access to the login credentials of the booking system. Yes, that system is using HTTP authentication instead of any kind of tokens, so the backend actually has the plain password. It doesn’t store the password, that is persisted in the browser storage on the client device. But the API backend needs to pass on the credentials from the user to the original backend system.

As the frontend can run all kinds of Rust code, even the booking system client library that I wrote, it would be possible to put the client code directly into the frontend. Remember, the backend only executes some HTTP calls to the booking system and scrapes the HTML pages for data. So the browser could download the packaged WASM application from any server, and never would need to call into any intermediate backend.

However, there are two downsides to this approach. First, I would need to let go of my hard-learned async-stream iterator client, as the WASM part cannot use raw TCP sockets in the browser, it needs to use the Request API of the browser to perform HTTP requests. As HTTP client I used [reqwest](https://github.com/seanmonstar/reqwest), which has both an async and sync API and has an implementation for native sockets, but also for the [Request API of the browser](https://github.com/seanmonstar/reqwest/tree/master/src/wasm). Unfortunately, it doesn’t provide an implementation of the async API using the browser backend. The second reason for having a standalone API is, that this would allow others to use this API as well, but not force them to use Rust. Still, adding a sync version of my API in the future, for using in the frontend, wouldn’t be a problem, and only hurt my pride 😁

## Conclusion

If you are a fan of Rust and allergic to JavaScript as well, you might appreciate Yew and maybe the [Patternfly components for Yew](https://github.com/ctron/patternfly-yew). You can take a quick look at [the quickstart application](https://github.com/ctron/patternfly-yew-quickstart), or direct your browser to [the running version](https://ctron.github.io/patternfly-yew-quickstart/) of that.

I was able to not only able parse the ancient HTML 3-ish output of our booking system, but also able to provide a decent API and state of the art web frontend. All using the same programming language, re-using my Rust experience and even data structures and code between frontend and backend. Fixing my original problem with truly small service.

While you already can do quite a lot, the Patternfly Yew components are far from complete. A bunch of components and properties are still missing. As needed I will be adding new features over time, but contributions are always welcome 😉

## See also

- Yew – <https://yew.rs>
- Elkato API – <https://github.com/ctron/elkato-api>
- PatternFly – <https://www.patternfly.org/v4/>
- PatternFly Yew Components – <https://github.com/ctron/patternfly-yew>
- PatternFly Yew Quickstart – <https://github.com/ctron/patternfly-yew-quickstart>
- PatternFly Yew Demo – <https://ctron.github.io/patternfly-yew-quickstart/>
