# Zinc Extensions

## ZnMimeType

- `accepts:` returns a boolean indicating if the receiving
  accepts the media type provided as parameter, for example:
  - `'application/json' asMediaType accepts: '*/*' asMediaType` yields true
  - `'application/json' asMediaType accepts: 'text/*' asMediaType` yields false
- `quality` returns a float with the corresponding quality value or 1.0
  (the default) if the parameter is missing.
- `version:` is just a shortcut to set a `version` parameter.

## ZnUrl

- `queryAt:putUrl:` allows to set a query parameter containing an URL that
  will be URL-encoded
- `start:limit:` allows to set two query parameters (`start` and `limit`)
  usually used in pagination schemes.
- `asHostedAt:` provides a copy of the URL using as host, scheme, and port
  the ones in the parameter.

  ```smalltalk
  'http://api.example.com:1111/resource' asUrl
    asHostedAt: 'https://alternative.org' asUrl
    "==> 'https://alternative.org/resource'"
  ```

## ZnClient

- `logLevel` provides access to the client current log level
- `setLogLevelAtLeastTo:` sets the client log level at least to the provided level
- `resetRequest` allows resetting the current request, useful when reusing clients
- `setAccept:` configures the `Accept` header in the current request
- `setIfMatchTo:` configures the `If-Match` header in the current request
- `setIfNoneMatchTo:` configures the `If-None-Match` header in the current request

## ZnRequest

- `acceptLanguage` provides access to the `Accept-Language` header
- `setAcceptLanguage:` sets the `Accept-Language` header
- `setIfMatchTo:` configures the `If-Match` header
- `setIfNoneMatchTo:` configures the `If-None-Match` header

## ZnResponse

- `addCachingDirective:` adds a `Cache-Control` directive
- `cachingDirectives` provides access to the `Cache-Control` directives
- `addContentLanguage:` adds a `Content-Language` header
- `contentLanguageTags` provides access to the `Content-Language` tags
- `addLink:` adds a `Link` header
- `links` provides access to the `Link` links
- `setEntityTag:` sets the `ETag` header
- `entityTag` provides access to the `ETag` header
- `withEntityTagDo:ifAbsent:` provides conditional access to the `ETag` header
- `hasLocation` answers if the response includes a `Location` header

## Zn*Server

- `logLevel` provides access to the server current log level
- `setLogLevelAtLeastTo:` sets the server log level at least to the provided
  level

## ZnEntity

- `ZnEntity class>>#json:` provides an easy way to create a JSON entity
- `ZnEntity class>>#with:ofType:` provides a way to create an entity given a
  target media type automatically selecting the better entity representation
  (string or byte-based)
