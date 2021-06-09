# Errors

## HTTPClientError

This is an exception expecting to be raised when someone makes an incorrect HTTP request.

It allows to handle any kind of HTTP client errors by doing something like:

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
accept headers sent in the request.

 I will carry over information about the acceptable media types.

 To signal it:

 ```smalltalk
 HTTPNotAcceptable signal: 'Error message' accepting: allowedMediaTypesCollection
  ```

## HTTPServerError

This is an exception expecting to be raised when the server encounters an
unexpected error.

It allows to handle any kind of HTTP server errors by doing something like:

```smalltalk
[ ... ] on: HTTPServerError do: [:signal | ]
```

or specific error codes:

```smalltalk
[ ... ] on: HTTPServerError serviceUnavailable do: [:signal | ].
[ ... ] on: HTTPServerError internalServerError do: [:signal | ]
```
