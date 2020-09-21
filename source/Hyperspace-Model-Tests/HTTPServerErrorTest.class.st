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
