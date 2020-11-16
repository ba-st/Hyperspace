"
I represent an HTTP Server Error [ 5xx ]

### 500 Internal Server Error

The server encountered an unexpected condition that prevented it from fulfilling the request.

### 503 Service Unavailable

The server is currently unable to handle the request due to a temporary overload or scheduled maintenance, which will likely be alleviated after some delay.
The server MAY send a Retry-After header field1 to suggest an appropriate amount of time for the client to wait before retrying the request.
"
Class {
	#name : #HTTPServerError,
	#superclass : #Error,
	#instVars : [
		'code'
	],
	#category : #'Hyperspace-Model-Exceptions'
}

{ #category : #'instance creation' }
HTTPServerError class >> code: aCode [

	| instance |

	instance := self new code: aCode.
	ZnConstants httpStatusCodes at: aCode ifPresent: [ :message | instance messageText: message ].
	^ instance
]

{ #category : #'instance creation' }
HTTPServerError class >> internalServerError [

	^ self code: 500
]

{ #category : #'instance creation' }
HTTPServerError class >> serviceUnavailable [

	^ self code: 503
]

{ #category : #signalling }
HTTPServerError class >> signalInternalServerError: aMessageText [

	^ self internalServerError signal: aMessageText
]

{ #category : #accessing }
HTTPServerError >> code [

	^ code
]

{ #category : #accessing }
HTTPServerError >> code: anErrorCode [

	code := anErrorCode
]

{ #category : #printing }
HTTPServerError >> printOn: stream [

	stream
		nextPutAll: self class name asString;
		nextPutAll: '[';
		nextPutAll: self code asString;
		nextPutAll: ']'.
	self messageText
		ifNotNil: [ :message | 
			stream
				nextPutAll: ':';
				space;
				nextPutAll: message
			]
]
