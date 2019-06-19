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
				assert: signal messageText equals: 'Bad Request'
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
				assert: signal messageText equals: 'Conflict'
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
				assert: signal messageText equals: 'Not Found'
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
				assert: signal messageText equals: 'Precondition Failed'
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
				assert: signal messageText equals: 'Precondition Required'
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
					'The target resource is no longer available at the origin server.'
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
				assert: signal messageText equals: 'Cannot be processed'
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
				assert: signal messageText equals: 'Unsupported Media Type'
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
