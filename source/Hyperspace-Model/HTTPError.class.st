"
I'm an exception expecting to be raised when there's an error processing an HTTP request.

Besides the status code and the message text, I can carry additional data: key/value pairs
whoever signals me can attach, and whoever renders the response can read back, without
needing a subclass of mine for each case.
"
Class {
	#name : 'HTTPError',
	#superclass : 'Error',
	#instVars : [
		'code',
		'additionalData'
	],
	#category : 'Hyperspace-Model-Exceptions',
	#package : 'Hyperspace-Model',
	#tag : 'Exceptions'
}

{ #category : 'instance creation' }
HTTPError class >> code: aCode [

	| instance |

	instance := self new code: aCode.
	ZnConstants httpStatusCodes at: aCode ifPresent: [ :message | instance messageText: message ].
	^ instance
]

{ #category : 'exception selector' }
HTTPError >> , exceptionSelector [

	^ ExceptionSelectorSet new , self , exceptionSelector
]

{ #category : 'private' }
HTTPError >> additionalData [

	additionalData ifNil: [ additionalData := OrderedDictionary new ].
	^ additionalData
]

{ #category : 'additional data' }
HTTPError >> additionalDataAt: aKey [

	^ self additionalDataAt: aKey ifAbsent: [ KeyNotFound signalFor: aKey ]
]

{ #category : 'additional data' }
HTTPError >> additionalDataAt: aKey ifAbsent: aBlock [

	additionalData ifNil: [ ^ aBlock value ].
	^ additionalData at: aKey asString ifAbsent: aBlock
]

{ #category : 'additional data' }
HTTPError >> additionalDataAt: aKey put: aValue [

	"Keys are normalized to strings, so they can be used as member names
	when rendering the error, and symbols are accepted as well."

	| key |

	key := aKey asString.
	AssertionChecker enforce: [ key notEmpty ]
		because: 'The additional data key must not be empty.'.
	^ self additionalData at: key put: aValue
]

{ #category : 'additional data' }
HTTPError >> additionalDataKeysAndValuesDo: aBlock [

	additionalData ifNotNil: [ :data | data keysAndValuesDo: aBlock ]
]

{ #category : 'accessing' }
HTTPError >> code [

	^ code
]

{ #category : 'accessing' }
HTTPError >> code: anErrorCode [

	code := anErrorCode
]

{ #category : 'exception selector' }
HTTPError >> handles: aSignal [

	^ ( self class handles: aSignal ) and: [ aSignal code = self code ]
]

{ #category : 'testing' }
HTTPError >> hasAdditionalData [

	^ additionalData notNil and: [ additionalData notEmpty ]
]

{ #category : 'printing' }
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
