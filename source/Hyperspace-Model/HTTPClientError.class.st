"
I represent an HTTP Client Error [ 4xx ]
"
Class {
	#name : #HTTPClientError,
	#superclass : #HTTPError,
	#category : #'Hyperspace-Model-Exceptions'
}

{ #category : #'instance creation' }
HTTPClientError class >> badRequest [

	"The server cannot or will not process the request due to something that is perceived to be a client error
	(e.g., malformed request syntax, invalid request message framing, or deceptive request routing)."

	^ self code: 400
]

{ #category : #'instance creation' }
HTTPClientError class >> conflict [

	"The request could not be completed due to a conflict with the current state of the target resource. 
	This code is used in situations where the user might be able to resolve the conflict and resubmit the request.
	The server SHOULD generate a payload that includes enough information for a user to recognize the source of the conflict."

	^ self code: 409
]

{ #category : #'instance creation' }
HTTPClientError class >> notFound [

	"The origin server did not find a current representation for the target resource or is not willing to disclose that one exists.
	A 404 status code does not indicate whether this lack of representation is temporary or permanent.
	A 404 response is cacheable by default, unless otherwise indicated by the method definition or explicit cache controls."

	^ self code: 404
]

{ #category : #'instance creation' }
HTTPClientError class >> preconditionFailed [

	"One or more conditions given in the request header fields evaluated to false when tested on the server.
	This response code allows the client to place preconditions on the current resource state (its current representations 
	and metadata) and, thus, prevent the request method from being applied if the target resource is in an unexpected state."

	^ self code: 412
]

{ #category : #'instance creation' }
HTTPClientError class >> preconditionRequired [

	"The origin server requires the request to be conditional.
	Its typical use is to avoid the lost update problem, where a client GETs a resource's state, modifies it, and PUTs
	it back to the server, when meanwhile a third party has modified the state on the server, leading to a conflict. 
	By requiring requests to be conditional, the server can assure that clients are working with the correct copies."

	^ self code: 428
]

{ #category : #'instance creation' }
HTTPClientError class >> tooManyRequests [

	"The user has sent too many requests in a given amount of time (rate limiting).
	The response representations SHOULD include details explaining the condition, 
	and MAY include a Retry-After header indicating how long to wait before making a new request."

	^ self code: 429
]

{ #category : #'instance creation' }
HTTPClientError class >> unprocessableEntity [

	"The server understands the content type of the request entity (hence a 415 Unsupported Media Type status code is inappropriate), 
	and the syntax of the request entity is correct (thus a 400 Bad Request status code is inappropriate) but was unable to process the contained instructions.
	For example, this error condition may occur if an XML request body contains well-formed (syntactically correct), but semantically erroneous, XML instructions."

	^ self code: 422
]

{ #category : #'instance creation' }
HTTPClientError class >> unsupportedMediaType [

	"The origin server is refusing to service the request because the payload is in a format not supported by this method on the target resource.
	The format problem might be due to the request's indicated Content-Type or Content-Encoding, or as a result of inspecting the data directly."

	^ self code: 415
]
