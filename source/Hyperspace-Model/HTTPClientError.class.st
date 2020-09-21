"
I'm an exception expecting to be raised when someone makes an incorrect HTTP request.
"
Class {
	#name : #HTTPClientError,
	#superclass : #Error,
	#instVars : [
		'code'
	],
	#category : #'Hyperspace-Model-Exceptions'
}

{ #category : #'instance creation' }
HTTPClientError class >> badRequest [

	^self code: 400
]

{ #category : #'instance creation' }
HTTPClientError class >> code: aCode [

	| instance |

	instance := self new code: aCode.
	ZnConstants httpStatusCodes at: aCode ifPresent: [ :message | instance messageText: message ].
	^ instance
]

{ #category : #'instance creation' }
HTTPClientError class >> conflict [

	^self code: 409
]

{ #category : #'instance creation' }
HTTPClientError class >> notFound [

	^self code: 404
]

{ #category : #'instance creation' }
HTTPClientError class >> preconditionFailed [

	^self code: 412
]

{ #category : #'instance creation' }
HTTPClientError class >> preconditionRequired [

	^self code: 428
]

{ #category : #'instance creation' }
HTTPClientError class >> unprocessableEntity [

	^ self code: 422
]

{ #category : #'instance creation' }
HTTPClientError class >> unsupportedMediaType [

	^self code: 415
]

{ #category : #accessing }
HTTPClientError >> code [

	^ code
]

{ #category : #accessing }
HTTPClientError >> code: anErrorCode [

	code := anErrorCode
]

{ #category : #'error handling' }
HTTPClientError >> handles: aSignal [

	^ ( self class handles: aSignal ) and: [ aSignal code = self code ]
]

{ #category : #printing }
HTTPClientError >> printOn: stream [

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
