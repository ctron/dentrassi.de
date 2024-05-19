---
title: "CSAF Walker: Working with CSAF providers in Rust"
description: |
  This is a quick introduction into the CSAF Walker project, which allows retrieving and analyzing CSAF documents
  from CSAF providers.
author: Jens Reimann
taxonomies:
  categories:
    - Open Source
    - Technical Stuff
  tags:
    - csaf
    - supply chain
    - advisories
    - vex
---

[CSAF Walker](https://github.com/ctron/csaf-walker) is a project, written in Rust, which allows retrieving of CSAF
documents from CSAF providers. Either as a library, or as a ready to run command line tool. This blog post gives a
quick introduction to the project.

<!-- more -->

I'll admit, this one is a bit more work related. I am not sure many people will do software supply chain security
in their free time. Although, it might actually be worth it.

## What is it all about?

One aspect of software supply chain security is to inform people about vulnerabilities in code. In a nutshell, a
vulnerability is some kind of bug, which might cause harm to the users of your software. An advisory is a statement
about one or more vulnerabilities in the context of a product or project. This can come from the original
authors/vendor, from other applications incorporating this as a dependency, or even some other people analyzing the
vulnerability.

Assuming you are consuming software in one for or another, you might want to be informed about vulnerabilities in that
software. Meaning, you are interested in advisories.

If vendors or authors simply write a text note, and post it somewhere, collecting and keeping an overview might
become tricky. That's where automation comes in handy.
And [CSAF](https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html) is a specification around automating the
process of authoring and distributing such advisory documents. There's a more complete
[introduction into CSAF](https://www.bsi.bund.de/dok/en_csaf) available from the [BSI](https://www.bsi.bund.de).

## Documents and providers

When working with CSAF, there are two aspects you might want to have covered. Working with documents, which are simply
JSON documents. And working with providers, which is a structure on a remote server, backed by HTTP. A little bit of
JSON metadata and some checks that you need to perform to discover the data.

Parsing those JSON files in Rust is straightforward. There's a crate named [`csaf`](https://crates.io/crates/csaf) for
that already, and it is working great.

However, the second part, discovering and retrieving those documents from providers wasn't covered at the time it was
looking into this. And that's the part where automation really helps.

The idea is simple: instead of having to navigate on a vendor's homepage, searching for the right location to download
files, there is a standard helping you to discover this. Let's take Red Hat as an example. Ideally I'll tell some
application simply to: get all documents from `redhat.com`. CSAF can do this, and CSAF Walker is the implementation for
that in Rust.

## More details

As mentioned earlier, CSAF Walker comes both in the form of a library, and as a command line application. [Installing
the binary](https://github.com/ctron/csaf-walker?tab=readme-ov-file#installation) is simple, but you can also compile
your own copy using `cargo install csaf-cli`.

After that, you can give it a try:

```bash
csaf download redhat.com
```

As easy as that, and give some patience as it really takes some time on the first run, you have a full sync of
Red Hat's CSAF data. Just based on the domain and the CSAF discovery process, it figured it out.

Re-running that command should be way faster. As there's a change detection mechanism built into CSAF, which allows
retrieving changed documents only.

Beside the `download` command, there are a few others. The `download` command simply discovers and downloads those
files, including their signatures. Using the `sync` command it would also perform some validation during the process.
However, in most cases, you want to split those actions. Download first, then validate all.

A detailed validation can be run using the `report` command:

```bash
csaf report -3
```

The resulting report will be rendered as an HTML file named `index.html`. Compared to the `download` command, this
will also validate the signatures and digest, which got downloaded as well.

## But wait, …

What if those commands are too opinionated for you? Maybe your workflow or idea of using the data is different. Or
maybe you want to embed this into your own application.

CSAF Walker is also available as a [library on crates.io](https://crates.io/crates/csaf-walker). The command line
application is also only using that library itself.

A bit of Rust code, and you can get started (see the [full example](https://github.com/ctron/csaf-walker/blob/main/csaf/examples/basic.rs)):

```rust
#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let fetcher = Fetcher::new(FetcherOptions::default()).await?;
    let source = HttpSource::new("redhat.com", fetcher, HttpOptions::default());

    let validator = ValidationVisitor::new(|result| async {
        match result {
            Ok(doc) => println!("Document: {doc:?}"),
            Err(err) => println!("Failed: {err}"),
        }
        Ok::<_, anyhow::Error>(())
    });
    let retriever = RetrievingVisitor::new(source.clone(), validator);

    Walker::new(source).walk(retriever).await?;

    Ok(())
}
```

## …, there is more!

When you check out the [GitHub repository of CSAF Walker](https://github.com/ctron/csaf-walker), you might find some
components regarding SBOMs. While CSAF has automation for discovering of documents, SBOMs don't seem to have
a specification like that as of now. What Red Hat did is to mimic the way CSAF does it, just for SPDX SBOMs. It's not
the full blow auto-discovery by domain. But still, it is something.

And since it works quite similarly, CSAF Walker provides code for that as well and shares some code with the SBOM side
of things. However, while CSAF is a vendor neutral OASIS specification. That SBOM part might only come in handy when
you work with Red Hat's SBOM data. Still, it's there.

## Want to know more?

I hope you got an idea of what CSAF Walker is all about, and what it might be able to do for you. If you want to know
more, I'll encourage you to check out the following links:

* CSAF
  * CSAF 2.0 specification – <https://docs.oasis-open.org/csaf/csaf/v2.0/os/csaf-v2.0-os.html>
  * OASIS CSAF technical committee – <https://www.oasis-open.org/committees/csaf/>
* Tools
  * CSAF Walker GitHub repository - <https://github.com/ctron/csaf-walker>
  * CSAF Rust serde structs (JSON) GitHub repository – <https://github.com/voteblake/csaf-rs>
* Examples
  * Basic example – <https://github.com/ctron/csaf-walker/blob/main/csaf/examples/basic.rs>
  * CASF importer of trustify – <https://github.com/trustification/trustify/tree/main/modules/importer/src/server/csaf>

If you have questions or ideas, [ping me on Matrix](https://mastodon.dentrassi.de/@ctron), raise an issue on GitHub,
or write me an e-mail. Of course, PRs are welcome too 😉
