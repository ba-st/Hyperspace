# IETF related abstractions

## Entity Tags

An entity-tag is an opaque validator for differentiating between multiple
representations of the same resource, regardless of whether those multiple
representations are due to resource state changes over time, content negotiation
resulting in multiple representations being valid at the same time, or both.
An entity-tag consists of an opaque quoted string, possibly prefixed by a
weakness indicator.

The ETag HTTP response header is an identifier for a specific version of a
resource. It allows caches to be more efficient, and saves bandwidth, as a web
server does not need to send a full response if the content has not changed.
On the other side, if the content has changed, etags are useful to help
prevent simultaneous updates of a resource from overwriting each other
("mid-air collisions").

If the resource at a given URL changes, a new Etag value must be generated.
Etags are therefore similar to fingerprints and might also be used for tracking
purposes by some servers. A comparison of them allows to quickly determine
whether two representations of a resource are the same, but they might also be
set to persist indefinitely by a tracking server.

`EntityTag` instances represent the HTTP header and can be set as the entity tag
in `ZnResponse` sending the message `setEntityTag:` and can be accessed sending
`entityTag`.

`ZnResponse` instances also provide a method to cope with the possible absence
of an ETag Header: `withEntityTagDo:ifAbsent:`

Entity tags can also be used in `ZnRequest` as parameters of `setIfMatchTo:` and
`setIfNoneMatchTo:` to configure the `If-Match` and `If-None-Match` headers on
a request.

`EntityTag` instances can be created by:

- providing the ETag value
- parsing it from its string representation

  ```smalltalk
  EntityTag with: '12345'.
  EntityTag fromString: '"12345"'
  ```

## Web Links

A `WebLink` instance represents a Link Header. The Link entity-header field
provides a means for serializing one or more links in HTTP headers.

It is semantically equivalent to the `<LINK>` element in HTML, as well as the
`atom:link` feed-level element in Atom.

**References:** [RFC 5988](https://tools.ietf.org/html/rfc5988#page-6)

`WebLink` instances are always attached to some URL, so to create a new link you
must send the message `to:`, for example:

```smalltalk
WebLink to: 'https://www.google.com' asUrl
```

or send `asWebLink` to a URL:

```smalltalk
'https://www.google.com' asUrl asWebLink
```

Optionally links allow configuring parameters. Well known parameters
are provided as configuration methods:

- `relationType:` corresponding to the `rel` parameter
- `title:` corresponding to the `title` parameter
- `mediaTypeHint:` corresponding to the `type` parameter
- `mediaQueryHint:` corresponding to the `media` parameter
- `addLanguageHint:` corresponding to the `hreflang` parameter whose value can
  be multiple

`ZnResponse` instances allow adding one or more links via `addLink:` receiving
a `WebLink` instance or access the link collection by sending `links`.

**References:**

- [RFC 5646](https://www.rfc-editor.org/rfc/rfc5646.html)
- [RFC 4647](https://www.rfc-editor.org/info/rfc4647)
- [RFC 3066](https://datatracker.ietf.org/doc/html/rfc3066)
- [BCP 47](https://www.rfc-editor.org/info/bcp47)
