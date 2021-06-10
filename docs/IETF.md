# IETF related abstractions

## ZnETag

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

`ZnETag` instances represent the HTTP header and can be set as the entity tag
in `ZnResponse` sending the message `setEntityTag:` and can be accessed sending
`entityTag`.

`ZnResponse` instances also provide a method to cope with the possible absence
of an ETag Header: `withEntityTagDo:ifAbsent:`

ETags can also be used in `ZnRequest` as parameters of `setIfMatchTo:` and
`setIfNoneMatchTo:` to configure the `If-Match` and `If-None-Match` headers on
a request.

`ZnETag` instances can be created by:

- providing the ETag value
- parsing it from its string representation

  ```smalltalk
  ZnETag with: '12345'.
  ZnETag fromString: '"12345"'
  ```

## ZnLink

A `ZnLink` instance represents a Link Header. The Link entity-header field
provides a means for serializing one or more links in HTTP headers.

It is semantically equivalent to the `<LINK>` element in HTML, as well as the
`atom:link` feed-level element in Atom.

**References:** [RFC 5988](https://tools.ietf.org/html/rfc5988#page-6)

`ZnLink` instances are always attached to some URL, so to create a new link you
must send the message `to:`, for example:

```smalltalk
ZnLink to: 'https://www.google.com' asUrl
```

Optionally links allow configuring the relation type using the `rel:` message.

`ZnResponse` instances allow adding one or more links via `addLink:` receiving
a `ZnLink` instance or access the link collection by sending `links`.

## Language Tags and Ranges

Language Tags are represented by instances of `LanguageTag`. A language tag is
used to label the language used by some information content.

These tags can also be used to specify the user's preferences when selecting
information content or to label additional attributes of content and associated
resources.

Sometimes language tags are used to indicate additional language attributes of
the content.

Language tags can be created by providing a subtags list or by parsing its
string representation:

```smalltalk
LanguageTag from: #('en' 'Latn' 'US').
LanguageTag fromString: 'en-us'.
'en-us' asLanguageTag.
```

Its instances can respond the language code (`languageCode`) and provide
methods to access its script and region in case they are defined:

```smalltalk
tag withScriptDo: [:script | ].
tag withRegionDo: [:region| ].
```

This implementation does not do anything special with the other optional
subtags that can be defined; nor supports extended languages and regions in UN
M.49 codes.

Language ranges are represented by instances of `LanguageRange`. A language
range has the same syntax as a language-tag, or is the single character `"*"`.

A language range matches a language tag if it exactly equals the tag, or if it
exactly equals a prefix of the tag such that the first character following the
prefix is `"-"`.

The special range `"*"` matches any tag.  A protocol that uses
language ranges may specify additional rules about the semantics of
`"*"`; for instance, `HTTP/1.1` specifies that the range `"*"` matches only
languages not matched by any other range within an `"Accept-Language:"` header.

Language ranges can be created by sending the message `any`, providing a list
of subtags, or parsing its string representation:

```smalltalk
LanguageRange any.
LanguageRange from: #('en').
LanguageRange fromString: '*'.
LanguageRange fromString: 'es-AR'.
```

`LanguageRange` instances are capable of matching corresponding language tags.
For example:

```smalltalk
(LanguangeRage fromString: 'es') matches: 'es-AR' asLanguageTag "==> true"
```

**References:**

- [RFC 5646](https://www.rfc-editor.org/rfc/rfc5646.html)
- [RFC 4647](https://www.rfc-editor.org/info/rfc4647)
- [RFC 3066](https://datatracker.ietf.org/doc/html/rfc3066)
- [BCP 47](https://www.rfc-editor.org/info/bcp47)
