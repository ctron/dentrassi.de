---
title: OIDC Command Line Tool
weight: 600
---

An OpenID Connect (OIDC) command line client. Allowing you to create those "bearer tokens" without too much trouble.

<!-- more -->

For example:

```bash
oidc create confidential my-client --issuer https://example.com/realm --client-id foo --client-secret bar
```

And then:

```bash
http example.com/api "Authorization:$(oidc token my-client --bearer)"
```

# Links

* Code: <https://github.com/ctron/oidc-cli>
* Crate: <https://crates.io/crates/oidc-cli>
