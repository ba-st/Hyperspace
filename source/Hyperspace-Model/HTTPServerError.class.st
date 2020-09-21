Class {
	#name : #HTTPServerError,
	#superclass : #Error,
	#instVars : [
		'code'
	],
	#category : #'Hyperspace-Model-Exceptions'
}

{ #category : #signalling }
HTTPServerError class >> signalInternalServerError: aMessageText [ 

	^self new 
		code: 500;
		signal: aMessageText
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
