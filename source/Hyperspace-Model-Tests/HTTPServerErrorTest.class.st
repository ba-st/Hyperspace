"
A HTTPServerErrorTest is a test class for testing the behavior of HTTPServerError
"
Class {
	#name : #HTTPServerErrorTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Exceptions'
}

{ #category : #tests }
HTTPServerErrorTest >> testInternalServerError [

	self
		should: [ HTTPServerError signalInternalServerError: 'Oops!' ]
		raise: HTTPServerError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 500;
				assert: signal messageText equals: 'Oops!';
				assert: signal printString equals: 'HTTPServerError[500]: Oops!'
			]
]

{ #category : #tests }
HTTPServerErrorTest >> testInternalServerErrorDefaultMessageText [

	self
		should: [ HTTPServerError internalServerError signal ]
		raise: HTTPServerError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 500;
				assert: signal messageText equals: 'Internal Server Error';
				assert: signal printString equals: 'HTTPServerError[500]: Internal Server Error'
			]
]

{ #category : #tests }
HTTPServerErrorTest >> testServiceUnavailable [

	self
		should: [ HTTPServerError serviceUnavailable signal: 'Oops!' ]
		raise: HTTPServerError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 503;
				assert: signal messageText equals: 'Oops!';
				assert: signal printString equals: 'HTTPServerError[503]: Oops!'
			]
]

{ #category : #tests }
HTTPServerErrorTest >> testServiceUnavailableDefaultMessageText [

	self
		should: [ HTTPServerError serviceUnavailable signal]
		raise: HTTPServerError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 503;
				assert: signal messageText equals: 'Service Unavailable';
				assert: signal printString equals: 'HTTPServerError[503]: Service Unavailable'
			]
]
