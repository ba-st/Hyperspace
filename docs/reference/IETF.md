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

- providing the ETag value, for a strong or a weak entity tag
- parsing it from its string representation

  ```smalltalk
  EntityTag with: '12345'.
  EntityTag weakWith: '12345'.
  EntityTag fromString: '"12345"'.
  EntityTag fromString: 'W/"12345"'.
  '"12345"' asEntityTag
  ```

`fromString:` signals `InstanceCreationFailed` unless the string is a single
entity tag as [RFC 9110](https://www.rfc-editor.org/rfc/rfc9110#section-8.8.3)
defines it: an optional `W/`, then an opaque value in double quotes. The opaque
value can be empty, but can only hold visible ASCII characters other than `"`,
so a list such as `"a", "b"` is refused.

`isWeak` answers whether an entity tag has the weakness indicator. Entity tags
can be compared in the two ways the RFC defines:

- `matchesStrongly:` is true when the opaque values are equal and neither
  entity tag is weak. `If-Match` asks for this one.
- `matchesWeakly:` is true when the opaque values are equal, weak or not.
  `If-None-Match` asks for this one.

`=` and `hash` compare only the opaque value, like `matchesWeakly:`.

```smalltalk
'W/"a"' asEntityTag matchesStrongly: '"a"' asEntityTag. "false"
'W/"a"' asEntityTag matchesWeakly: '"a"' asEntityTag. "true"
```

### Entity Tag Lists

The field value of the `If-Match` and `If-None-Match` headers is a list of
entity tags, or `*`. `EntityTagList` represents it, and can be created by:

- parsing the field value
- parsing the collection of field values Zinc answers for a header that appears
  more than once, which means the same as the comma-separated list of them
- providing the entity tags
- asking for the wildcard

  ```smalltalk
  EntityTagList fromString: 'W/"a", "b"'.
  EntityTagList fromStrings: #( 'W/"a"' '"b"' ).
  EntityTagList withAll: { EntityTag with: 'a' }.
  EntityTagList wildcard.
  ( request headers at: 'If-Match' ) asEntityTagList
  ```

`asEntityTagList` is understood by both strings and collections of strings, so
it works whether the header appeared once or more. Parsing signals
`InstanceCreationFailed` if the list holds no entity tags, if any of them is
invalid, or if `*` appears together with other entity tags.

`matchesStrongly:` and `matchesWeakly:` answer whether any entity tag in the list
matches the one given, and `isWildcard` whether the list is `*`. The wildcard
matches any entity tag, but it can only be compared when the resource has a
current representation. When it has none, the caller decides: `If-Match: *`
fails and `If-None-Match: *` succeeds.

```smalltalk
| entityTags |
entityTags := ( request headers at: 'If-Match' ) asEntityTagList.
entityTags matchesStrongly: currentEntityTag
```

`EntityTagList` instances can also be used in `setIfMatchTo:` and
`setIfNoneMatchTo:`.

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
