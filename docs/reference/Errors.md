# Errors

## HTTPClientError

This is an exception expecting to be raised when someone makes an incorrect HTTP
request.

It allows handling any kind of HTTP client errors by doing something like:

```smalltalk
[ ... ] on: HTTPClientError do: [:signal | ]
```

or specific error codes:

```smalltalk
[ ... ] on: HTTPClientError notFound do: [:signal | ]
```

To signal it you must create an instance of the specific error you want to raise:

- `HTTPClientError badRequest`
- `HTTPClientError conflict`
- `HTTPClientError notFound`
- `HTTPClientError preconditionFailed`
- `HTTPClientError preconditionRequired`
- `HTTPClientError unprocessableEntity`
- `HTTPClientError unsupportedMediaType`

and then send the `signal:` message.

## HTTPNotAcceptable

I represent an HTTP client error: `406 Not Acceptable`

The resource identified by the request is only capable of generating response
entities that have content characteristics not acceptable according to the
`Accept` headers sent in the request.

 I will carry over information about the acceptable media types.

 To signal it:

 ```smalltalk
 HTTPNotAcceptable signal: 'Error message' accepting: allowedMediaTypesCollection
  ```

## HTTPServerError

This is an exception expecting to be raised when the server encounters an
unexpected error.

It allows handling any kind of HTTP server errors by doing something like:

```smalltalk
[ ... ] on: HTTPServerError do: [:signal | ]
```

or specific error codes:

```smalltalk
[ ... ] on: HTTPServerError serviceUnavailable do: [:signal | ].
[ ... ] on: HTTPServerError internalServerError do: [:signal | ]
```

## Additional data

Any `HTTPError` can carry additional data: key/value pairs attached when
signalling the error, and read back by whoever handles it or renders the
response. It is the way to give an error more context — the offending
field, a balance, a retry hint — without creating a subclass for each
case.

```smalltalk
HTTPClientError conflict
    messageText: 'Insufficient funds';
    additionalDataAt: 'balance' put: 30;
    additionalDataAt: 'currency' put: 'ARS';
    signal
```

and on the handling side:

```smalltalk
[ ... ]
    on: HTTPClientError conflict
    do: [ :signal | signal additionalDataAt: 'balance' ifAbsent: [ 0 ] ]
```

The protocol is:

| Message | Answers |
| --- | --- |
| `additionalDataAt:put:` | Attaches a value under a key |
| `additionalDataAt:` | The value, signalling `KeyNotFound` when absent |
| `additionalDataAt:ifAbsent:` | The value, or the block's value |
| `additionalDataKeysAndValuesDo:` | Evaluates a block per pair, in order |
| `hasAdditionalData` | Whether there is anything to read |

Keys are normalized to strings, so `'balance'` and `#balance` name the
same entry, and they can be used directly as member names when rendering
the error, for example as the extension members of an
[RFC 9457](https://www.rfc-editor.org/rfc/rfc9457)
`application/problem+json` document. Values are stored as they are
given; Hyperspace does not know how they will be rendered.

Attaching data never affects which handler runs: exception selection
keeps looking only at the status code.

### The specialized errors

The errors modelling a specific status answer the state they already
hold through the same protocol, so a renderer needs to know only one:

| Error | Keys |
| --- | --- |
| `HTTPForbidden` | `errorCode`, `requiredPermissions` |
| `HTTPUnauthorized` | `errorCode` |
| `HTTPNotAcceptable` | `allowedMediaTypes`, `allowedLanguageTags` |

They are answered only when there is something to answer, and attaching
a value under one of those keys overrides it, leaving the accessor
untouched. The `challenge` of `HTTPForbidden` and `HTTPUnauthorized` is
not part of the data, since it belongs in the `WWW-Authenticate` header
rather than in a response body.
