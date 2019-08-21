# Zinc Extensions

## ZnETag

The ETag HTTP response header is an identifier for a specific version of a resource. It allows caches to be more efficient, and saves bandwidth, as a web server does not need to send a full response if the content has not changed. On the other side, if the content has changed, etags are useful to help prevent simultaneous updates of a resource from overwriting each other ("mid-air collisions").

If the resource at a given URL changes, a new Etag value must be generated. Etags are therefore similar to fingerprints and might also be used for tracking purposes by some servers. A comparison of them allows to quickly determine whether two representations of a resource are the same, but they might also be set to persist indefinitely by a tracking server.

`ZnETag` instances represents the HTTP header and can be set as the entity tag in `ZnResponse` sending the message `setEntityTag:` and can be accesed sending `entityTag`.

`ZnResponse` instances also provide a method to cope with the possible absence of an ETag Header: `withEntityTagDo:ifAbsent:`

ETags can also be used in `ZnRequest` as parameters of `setIfMatchTo:` and `setIfNoneMatchTo:` to configure the `If-Match` and `If-None-Match` headers on a request.

`ZnETag` instances can be created by:
- providing the ETag value
- parsing it from its string representation
```smalltalk
ZnETag with: '12345'
ZnETag fromString: '"12345"'
```

## ZnLink

I represent a Link Header.
The Link entity-header field provides a means for serialising one or more links in HTTP headers.  
It is semantically equivalent to the `<LINK>` element in HTML, as well as the `atom:link` feed-level element in Atom.

References: [RFC 5988](https://tools.ietf.org/html/rfc5988#page-6)

`ZnLink` instances are always attached to some URL, so to create a new link you must send the message `to:`, for example:

```smalltalk
ZnLink to: 'https://www.google.com' asUrl
```

Optionally links allow to configure the relation type using the `rel:` message.

`ZnResponse` instances allow to add one or more links via `addLink:` receiving a `ZnLink` instance or access the link collection by sending `links`.

## ZnMimeType Extensions

- `accepts:` returns a boolean indicating if the receiving accepts the media type provided as parameter, for example:
  - `'application/json' asMediaType accepts: '*/*' asMediaType` yields true
  - `'application/json' asMediaType accepts: 'text/*' asMediaType` yields false
- `quality` returns a float with the corresponding quality value or 1.0 (the default) if the parameter is missing.
- `version:` is just a shortcut to set a `version` parameter.

## ZnUrl Extensions

- `queryAt:putUrl:` allows to set a query parameter containing an URL that will be url-encoded
- `start:limit:` allows to set two query parameters `start` and `limit` usually used in pagination schemes.
