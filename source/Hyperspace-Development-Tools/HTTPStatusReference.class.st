Class {
	#name : #HTTPStatusReference,
	#superclass : #SharedPool,
	#classVars : [
		'ReferenceByCode'
	],
	#category : #'Hyperspace-Development-Tools'
}

{ #category : #'class initialization' }
HTTPStatusReference class >> initialize [

	ReferenceByCode := Dictionary new.
	self
		initializeBadRequest;
		initializeConflict;
		initializeForbidden;
		initializeMethodNotAllowed;
		initializeNotAcceptable;
		initializeNotFound;
		initializePreconditionFailed;
		initializePreconditionRequired;
		initializeRequestTimeout;
		initializeTooManyRequests;
		initializeUnauthorized;
		initializeUnprocessableEntity;
		initializeUnsupportedMediaType.

	self
		initializeInternalServerError;
		initializeServiceUnavailable.

	self
		initializeOk;
		initializeAccepted;
		initializeCreated;
		initializeNoContent
]

{ #category : #initialization }
HTTPStatusReference class >> initializeAccepted [

	ReferenceByCode
		at: 202
		put:
			'The request has been accepted for processing, but the processing has not been completed. The request might or might not eventually be acted upon, as it might be disallowed when processing actually takes place.

There is no facility in HTTP for re-sending a status code from an asynchronous operation.

The 202 response is intentionally noncommittal. Its purpose is to allow a server to accept a request for some other process (perhaps a batch-oriented process that is only run once per day) without requiring that the user agent’s connection to the server persist until the process is completed. The representation sent with this response ought to describe the request’s current status and point to (or embed) a status monitor that can provide the user with an estimate of when the request will be fulfilled.

Source: [RFC7231 Section 6.3.3](https://tools.ietf.org/html/rfc7231#section-6.3.3)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeBadRequest [

	ReferenceByCode
		at: 400
		put:
			'The server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax, invalid request message framing, or deceptive request routing).

Source: [RFC7231 Section 6.5.1](https://tools.ietf.org/html/rfc7231#section-6.5.1)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeConflict [

	ReferenceByCode
		at: 409
		put:
			'The request could not be completed due to a conflict with the current state of the target resource. This code is used in situations where the user might be able to resolve the conflict and resubmit the request.

The server SHOULD generate a payload that includes enough information for a user to recognize the source of the conflict.

Conflicts are most likely to occur in response to a **PUT** request. For example, if versioning were being used and the representation being **PUT** included changes to a resource that conflict with those made by an earlier (third-party) request, the origin server might use a 409 response to indicate that it can’t complete the request. In this case, the response representation would likely contain information useful for merging the differences based on the revision history.				

Source: [RFC7231 Section 6.5.8](https://tools.ietf.org/html/rfc7231#section-6.5.8)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeCreated [

	ReferenceByCode
		at: 201
		put: 'The request has been fulfilled and has resulted in one or more new resources being created.

The primary resource created by the request is identified by either a Location header field in the response or, if no Location field is received, by the effective request URI.

The 201 response payload typically describes and links to the resource(s) created. See [Section 7.2 of RFC7231](https://tools.ietf.org/html/rfc7231#section-7.2) for a discussion of the meaning and purpose of validator header fields, such as ETag and Last-Modified, in a 201 response.

Source: [RFC7231 Section 6.3.2](https://tools.ietf.org/html/rfc7231#section-6.3.2)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeForbidden [

	ReferenceByCode at: 403 put: 'The server understood the request but refuses to authorize it.

A server that wishes to make public why the request has been forbidden can describe that reason in the response payload (if any).

If authentication credentials were provided in the request, the server considers them insufficient to grant access. The client SHOULD NOT automatically repeat the request with the same credentials. The client MAY repeat the request with new or different credentials. However, a request might be forbidden for reasons unrelated to the credentials.

An origin server that wishes to “hide” the current existence of a forbidden target resource MAY instead respond with a status code of 404 Not Found.

Source: [RFC7231 Section 6.5.3](https://tools.ietf.org/html/rfc7231#section-6.5.3)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeInternalServerError [

	ReferenceByCode
		at: 500
		put:
			'The server encountered an unexpected condition that prevented it from fulfilling the request.

Source: [RFC7231 Section 6.6.1](https://tools.ietf.org/html/rfc7231#section-6.6.1)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeMethodNotAllowed [

	ReferenceByCode
		at: 405
		put:
			'The method received in the request-line is known by the origin server but not supported by the target resource.

The origin server MUST generate an Allow header field in a 405 response containing a list of the target resource’s currently supported methods.

A 405 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.

Source: [RFC7231 Section 6.5.5](https://tools.ietf.org/html/rfc7231#section-6.5.5)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeNoContent [

	ReferenceByCode
		at: 204
		put:
			'The server has successfully fulfilled the request and that there is no additional content to send in the response payload body.

Metadata in the response header fields refer to the target resource and its selected representation after the requested action was applied.

For example, if a 204 status code is received in response to a **PUT** request and the response contains an **ETag** header field, then the **PUT** was successful and the **ETag** field-value contains the entity-tag for the new representation of that target resource.

The 204 response allows a server to indicate that the action has been successfully applied to the target resource, while implying that the user agent does not need to traverse away from its current “document view” (if any). The server assumes that the user agent will provide some indication of the success to its user, in accord with its own interface, and apply any new or updated metadata in the response to its active representation.

For example, a 204 status code is commonly used with document editing interfaces corresponding to a “save” action, such that the document being saved remains available to the user for editing. It is also frequently used with interfaces that expect automated data transfers to be prevalent, such as within distributed version control systems.

A 204 response is terminated by the first empty line after the header fields because it cannot contain a message body.

A 204 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.

Source: [RFC7231 Section 6.3.5](https://tools.ietf.org/html/rfc7231#section-6.3.5)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeNotAcceptable [

	ReferenceByCode
		at: 406
		put:
			'The target resource does not have a current representation that would be acceptable to the user agent, according to the proactive negotiation header fields received in the request, and the server is unwilling to supply a default representation.

The server SHOULD generate a payload containing a list of available representation characteristics and corresponding resource identifiers from which the user or user agent can choose the one most appropriate. A user agent MAY automatically select the most appropriate choice from that list. However, this specification does not define any standard for such automatic selection, as described in [RFC7231 Section 6.4.1](https://tools.ietf.org/html/rfc7231#section-6.4.1).	

Source: [RFC7231 Section 6.5.6](https://tools.ietf.org/html/rfc7231#section-6.5.6)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeNotFound [

	ReferenceByCode
		at: 404
		put:
			'The origin server did not find a current representation for the target resource or is not willing to disclose that one exists.

A 404 status code does not indicate whether this lack of representation is temporary or permanent; the 410 Gone status code is preferred over 404 if the origin server knows, presumably through some configurable means, that the condition is likely to be permanent.

A 404 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.

Source: [RFC7231 Section 6.5.4](https://tools.ietf.org/html/rfc7231#section-6.5.4)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeOk [

	ReferenceByCode at: 200 put: 'The request has succeeded.

The payload sent in a 200 response depends on the request method. For the methods defined by this specification, the intended meaning of the payload can be summarized as:
- **GET** a representation of the target resource
- **HEAD** the same representation as **GET**, but without the representation data
- **POST** a representation of the status of, or results obtained from, the action;
- **PUT** **DELETE** a representation of the status of the action;
- **OPTIONS** a representation of the communications options;
- **TRACE** a representation of the request message as received by the end server.

Aside from responses to **CONNECT**, a 200 response always has a payload, though an origin server MAY generate a payload body of zero length. If no payload is desired, an origin server ought to send 204 No Content instead. For **CONNECT**, no payload is allowed because the successful result is a tunnel, which begins immediately after the 200 response header section.

A 200 response is cacheable by default; i.e., unless otherwise indicated by the method definition or explicit cache controls.

Source: [RFC7231 Section 6.3.1](https://tools.ietf.org/html/rfc7231#section-6.3.1)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializePreconditionFailed [

	ReferenceByCode at: 412 put: 'One or more conditions given in the request header fields evaluated to false when tested on the server.

This response code allows the client to place preconditions on the current resource state (its current representations and metadata) and, thus, prevent the request method from being applied if the target resource is in an unexpected state.

Source: [RFC7232 Section 4.2](https://tools.ietf.org/html/rfc7232#section-4.2)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializePreconditionRequired [

	ReferenceByCode at: 428 put: 'The origin server requires the request to be conditional.

Its typical use is to avoid the “lost update” problem, where a client GETs a resource’s state, modifies it, and PUTs it back to the server, when meanwhile a third party has modified the state on the server, leading to a conflict. By requiring requests to be conditional, the server can assure that clients are working with the correct copies.

Responses using this status code SHOULD explain how to resubmit the request successfully.

Responses with the 428 status code MUST NOT be stored by a cache.

Source: [RFC6585 Section 3](https://tools.ietf.org/html/rfc6585#section-3)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeRequestTimeout [

	ReferenceByCode
		at: 408
		put:
			'The server did not receive a complete request message within the time that it was prepared to wait.

A server SHOULD send the “close” connection option in the response, since 408 implies that the server has decided to close the connection rather than continue waiting. If the client has an outstanding request in transit, the client MAY repeat that request on a new connection.

Source: [RFC7231 Section 6.5.7](https://tools.ietf.org/html/rfc7231#section-6.5.7)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeServiceUnavailable [

	ReferenceByCode at: 503 put: 'The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.

The server MAY send a Retry-After header field to suggest an appropriate amount of time for the client to wait before retrying the request.

Source: [RFC7231 Section 6.6.4](https://tools.ietf.org/html/rfc7231#section-6.6.4)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeTooManyRequests [

	ReferenceByCode at: 429 put: 'The user has sent too many requests in a given amount of time (“rate limiting”).

The response representations SHOULD include details explaining the condition, and MAY include a **Retry-After** header indicating how long to wait before making a new request.

Note that this specification does not define how the origin server identifies the user, nor how it counts requests. For example, an origin server that is limiting request rates can do so based upon counts of requests on a per-resource basis, across the entire server, or even among a set of servers. Likewise, it might identify the user by its authentication credentials, or a stateful cookie.

Responses with the 429 status code MUST NOT be stored by a cache.

Source: [RFC6585 Section 4](https://tools.ietf.org/html/rfc6585#section-4)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeUnauthorized [

	ReferenceByCode at: 401 put: 'The request has not been applied because it lacks valid authentication credentials for the target resource.

The server generating a 401 response MUST send a **WWW-Authenticate** header field containing at least one challenge applicable to the target resource.

If the request included authentication credentials, then the 401 response indicates that authorization has been refused for those credentials. The user agent MAY repeat the request with a new or replaced Authorization header field. If the 401 response contains the same challenge as the prior response, and the user agent has already attempted authentication at least once, then the user agent SHOULD present the enclosed representation to the user, since it usually contains relevant diagnostic information.

Source: [RFC7235 Section 3.1](https://tools.ietf.org/html/rfc7235#section-3.1)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeUnprocessableEntity [

	ReferenceByCode at: 422 put: 'The server understands the content type of the request entity (hence a 415 Unsupported Media Type status code is inappropriate), and the syntax of the request entity is correct (thus a 400 Bad Request status code is inappropriate) but was unable to process the contained instructions.

For example, this error condition may occur if an XML request body contains well-formed (i.e., syntactically correct), but semantically erroneous, XML instructions.

Source: [RFC4918 Section 11.2](https://tools.ietf.org/html/rfc4918#section-11.2)'
]

{ #category : #initialization }
HTTPStatusReference class >> initializeUnsupportedMediaType [

	ReferenceByCode at: 415 put: 'The origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource.

The format problem might be due to the request’s indicated **Content-Type** or **Content-Encoding**, or as a result of inspecting the data directly.

Source: [RFC7231 Section 6.5.13](https://tools.ietf.org/html/rfc7231#section-6.5.13)'
]

{ #category : #accessing }
HTTPStatusReference class >> referenceFor: errorCode [

	| header referenceText |

	header := '# <1p> <2s>'
		          expandMacrosWith: errorCode
		          with: ( ZnConstants httpStatusCodes at: errorCode ).

	referenceText := ReferenceByCode at: errorCode ifAbsent: [ ^ header ].

	^ '<1s><r><2s>' expandMacrosWith: header with: referenceText
]
