---
title: "An OpenID Connect command line client"
description: |
  Introduction to oidc-cli, an OpenID Connect command line client.
author: Jens Reimann
taxonomies:
  categories:
    - Technical Stuff
    - Open Source
  tags:
    - OIDC
    - Authentication
    - CLI
    - Development
---

[OpenID Connect](https://openid.net/developers/how-connect-works/) isn't the easiest thing to get into. Access tokens,
ID tokens, refresh tokens. The different authentication flows. But all you want is a simple HTTP request from the
command line. `oidc-cli` is here to help.

<!-- more -->

## What is OIDC

OpenID Connect (or short OIDC) is a great technology. Based on OAuth2, it provides a simple way to get rid of managing
user credentials, not only for frontend applications. The downside is that, in order to cover all use cases, it is quite complex.

As a user, from a frontend perspective (yes, I mean you and your browser), OIDC is quite comfortable. You come to a
new service, see a "login with X" button, click it, get redirected to X (no, not that X). Then confirm that you want
to log in and share your account information. Get redirected back to the original service. Done. No need to create a
new pair of username and password. No need for confirmation e-mails, or other things like that.

From the perspective of a provider of such a service, that can also be quite comfortable. Instead of implementing all
the username/password, account creation e-mail, recover your password feature, two-factor authentication, all you need
to do is to forward the user to e.g., [Keycloak](https://www.keycloak.org/), and you're done. When the user gets
redirected back to our website, that redirect will carry a code, and that code can be exchanged with the issuer
server (Keycloak) for an access token.

The access token will then be set from the frontend to the backend, and the backend knows who you are. In order to
prevent misuse of that access token, it has a lifespan of a few minutes, and needs to be refreshed. Refreshing the
token can be done with the refresh token, which gives you another short-lived access token.

All good.

## Here comes the catch

Assume you want to do some testing from the command line. Using `curl` or `http`. Pretty simple.
And it's actually pretty simple to pass the token. `http "Authorization:Bearer <token>"` and you're done.

The only question is: where do you get that token from?

Well, you get it from the handshake: frontend redirect to the issuer. The issuer logs you in, then redirects you back to
the frontend. Which then trades the code for a new token. Quite a few steps. And after a few minutes, you might need
to repeat that.

## Solutions

One way could be to use the "client credentials" grant. That's a "machine to machine" type of token, where you can trade
a "client id" and "client secret" for an access token that normally lasts a bit longer (like one hour). Still, you need
to do an initial `curl` call mixed with `jq` to initially get that.

You can also use [Postman](https://www.postman.com/). It has some integrated support for OAuth2 (which OIDC builds
upon). However, the configuration isn't that easy, and it is not a pure command line tool. 

## `oidc-cli`

Here comes [`oidc-cli`](https://github.com/ctron/oidc-cli). `oidc-cli` is a small, lightweight command line tool.

The usage is quite simple. Create a new OIDC login (client), using:

```bash
odic create public <my-client> --issuer <issuer url> --client-id <client-id> 
```

That will spin up an HTTP server and print out a URL on the console which takes your browser to the login screen of the
issuer server. It will as the issuer server to redirect back to the locally spun up HTTP server once it's done. When
it receives that redirect, it will store that token and have it available for command line use:

```bash
oidc token <my-client>
```

That will give you the raw access token. Using `-b` (or `--bearer`) you can also get it formatted in a way that you
can directly use it as a value to the `Authorization` HTTP header. For example, using it in combination with
[HTTPie](https://httpie.io/):

```bash
http localhost/my/api Authorization:$(oidc token -b <my-client>)
```

## But wait, there is more!

`oidc-cli` cannot only work with public, frontend OIDC clients, but also with the "client credentials" grant mentioned
before. You will just need to use `oidc create confidential`, and `--help` should tell you more.

When the token expires, `oidc-cli` will automatically try to refresh that token too.

## What's next

I hope you would give it a try. Let me know how it works, and what you think is missing.

It is a `0.1.x` version, and it there could be a lot more. Then again, it already does prove itself useful every day.
There are a few other flows/grants to support. There could be a lot more options to add (like scopes, nonces,
timeouts, …), and I am happy to expand it when necessary (PRs welcome 😉). Let me know, create
an issue on GitHub!

## Also see

* [oidc-cli](https://github.com/ctron/oidc-cli) on GitHub
* [Installation](https://github.com/ctron/oidc-cli?tab=readme-ov-file#installation)
