"
A HTTPClientErrorTest is a test class for testing the behavior of HTTPClientError
"
Class {
	#name : #HTTPClientErrorTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Exceptions'
}

{ #category : #tests }
HTTPClientErrorTest >> testBadRequest [

	self
		should: [ HTTPClientError badRequest signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 400;
				assert: signal messageText equals: 'Bad Request';
				assert: signal printString equals: 'HTTPClientError[400]: Bad Request'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testConflict [

	self
		should: [ HTTPClientError conflict signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 409;
				assert: signal messageText equals: 'Conflict';
				assert: signal printString equals: 'HTTPClientError[409]: Conflict'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testConvenienceHandler [

	self
		should: [ HTTPClientError notFound signal ]
		raise: HTTPClientError notFound
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not Found'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testConvenienceHandlerUsingAnotherSignal [

	self
		should: [ [ HTTPClientError notFound signal ]
				on: HTTPClientError conflict
				do: [ :signal | self fail ]
			]
		raise: HTTPClientError notFound
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not Found'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testConvenienceHandlerWithOnExceptDo [

	self
		should: [ [ HTTPClientError notFound signal ]
				on: Error
				except: HTTPClientError notFound
				do: [ :signal | self fail ]
			]
		raise: HTTPClientError notFound
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not Found'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testNotFound [

	self
		should: [ HTTPClientError notFound signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Not Found';
				assert: signal printString equals: 'HTTPClientError[404]: Not Found'
			].

	self
		should: [ HTTPClientError notFound signal: 'Object not found' ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 404;
				assert: signal messageText equals: 'Object not found'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testPreconditionFailed [

	self
		should: [ HTTPClientError preconditionFailed signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 412;
				assert: signal messageText equals: 'Precondition Failed';
				assert: signal printString equals: 'HTTPClientError[412]: Precondition Failed'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testPreconditionRequired [

	self
		should: [ HTTPClientError preconditionRequired signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 428;
				assert: signal messageText equals: 'Precondition Required';
				assert: signal printString equals: 'HTTPClientError[428]: Precondition Required'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testSignalingCustomCode [

	self
		should: [ ( HTTPClientError code: 410 )
				signal:
					'The target resource is no longer available at the origin server.'
			]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 410;
				assert: signal messageText
					equals:
					'The target resource is no longer available at the origin server.';
				assert: signal printString equals: 'HTTPClientError[410]: The target resource is no longer available at the origin server.'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testTooManyRequests [

	self
		should: [ HTTPClientError tooManyRequests signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 429;
				assert: signal messageText equals: 'Too Many Requests';
				assert: signal printString equals: 'HTTPClientError[429]: Too Many Requests'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testUnprocessableEntity [

	self
		should: [ HTTPClientError unprocessableEntity signal: 'Cannot be processed' ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 422;
				assert: signal messageText equals: 'Cannot be processed';
				assert: signal printString equals: 'HTTPClientError[422]: Cannot be processed'
			]
]

{ #category : #tests }
HTTPClientErrorTest >> testUnsupportedMediaType [

	self
		should: [ HTTPClientError unsupportedMediaType signal ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 415;
				assert: signal messageText equals: 'Unsupported Media Type';
				assert: signal printString equals: 'HTTPClientError[415]: Unsupported Media Type'
			].

	self
		should: [ HTTPClientError unsupportedMediaType signal: 'application/json is not supported' ]
		raise: HTTPClientError
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 415;
				assert: signal messageText equals: 'application/json is not supported'
			]
]
