"
I'm an exception expecting to be raised when there's an error processing an HTTP request.
"
Class {
	#name : #HTTPError,
	#superclass : #Error,
	#instVars : [
		'code'
	],
	#category : #'Hyperspace-Model-Exceptions'
}

{ #category : #'instance creation' }
HTTPError class >> code: aCode [

	| instance |

	instance := self new code: aCode.
	ZnConstants httpStatusCodes at: aCode ifPresent: [ :message | instance messageText: message ].
	^ instance
]

{ #category : #'exception selector' }
HTTPError >> , exceptionSelector [

	^ ExceptionSelectorSet new , self , exceptionSelector
]

{ #category : #accessing }
HTTPError >> code [

	^ code
]

{ #category : #accessing }
HTTPError >> code: anErrorCode [

	code := anErrorCode
]

{ #category : #'exception selector' }
HTTPError >> handles: aSignal [

	^ ( self class handles: aSignal ) and: [ aSignal code = self code ]
]

{ #category : #printing }
HTTPError >> printOn: stream [

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
