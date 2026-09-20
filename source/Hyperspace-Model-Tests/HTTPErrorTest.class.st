"
A HTTPErrorTest is a test class for testing the behavior of HTTPError
"
Class {
	#name : 'HTTPErrorTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-Exceptions',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Exceptions'
}

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalData [

	| error |

	error := HTTPClientError conflict.

	self
		deny: error hasAdditionalData;
		should: [ error additionalDataAt: 'balance' ] raise: KeyNotFound;
		assert: ( error additionalDataAt: 'balance' ifAbsent: [ 0 ] ) equals: 0.

	error additionalDataAt: 'balance' put: 30.

	self
		assert: error hasAdditionalData;
		assert: ( error additionalDataAt: 'balance' ) equals: 30;
		assert: ( error additionalDataAt: 'balance' ifAbsent: [ 0 ] ) equals: 30
]

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalDataCannotUseAnEmptyKey [

	self
		should: [ HTTPClientError conflict additionalDataAt: '' put: 30 ]
		raise: AssertionFailed
		withMessageText: 'The additional data key must not be empty.'
]

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalDataDoesNotAffectHandling [

	| error |

	error := HTTPClientError notFound additionalDataAt: 'resource' put: '/pets/1';
		         yourself.

	self should: [ error signal ] raise: HTTPClientError notFound
]

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalDataEnumeration [

	| error readData |

	error := HTTPClientError conflict.
	readData := OrderedCollection new.

	error additionalDataKeysAndValuesDo: [ :key :value |
		readData add: key -> value ].
	self assert: readData isEmpty.

	error
		additionalDataAt: 'balance' put: 30;
		additionalDataAt: 'currency' put: 'ARS'.

	error additionalDataKeysAndValuesDo: [ :key :value |
		readData add: key -> value ].

	self assert: readData asArray
		equals: { ( 'balance' -> 30 ). ( 'currency' -> 'ARS' ) }
]

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalDataKeysAreNormalized [

	| error |

	error := HTTPClientError conflict additionalDataAt: #balance put: 30;
		         yourself.

	self
		assert: ( error additionalDataAt: 'balance' ) equals: 30;
		assert: ( error additionalDataAt: #balance ) equals: 30.

	error additionalDataKeysAndValuesDo: [ :key :value |
		self
			assert: key equals: 'balance';
			assert: key isString;
			deny: key isSymbol ]
]

{ #category : 'tests' }
HTTPErrorTest >> testAdditionalDataSurvivesSignalling [

	self
		should: [
			HTTPClientError conflict
				messageText: 'Insufficient funds';
				additionalDataAt: 'balance' put: 30;
				signal
			]
		raise: HTTPClientError conflict
		withExceptionDo: [ :signal |
			self
				assert: signal messageText equals: 'Insufficient funds';
				assert: ( signal additionalDataAt: 'balance' ) equals: 30
			]
]

{ #category : 'tests' }
HTTPErrorTest >> testHandlingExceptionSelectorSets [

	self
		should: [ HTTPClientError notFound signal ]
		raise: HTTPClientError notFound , HTTPServerError;
		should: [ HTTPServerError serviceUnavailable signal ]
		raise: HTTPClientError notFound , HTTPServerError.

	self
		should: [
			[ HTTPServerError serviceUnavailable signal ]
				on: HTTPClientError notFound , HTTPServerError internalServerError
				do: [ :signal | self fail ] ]
		raise: HTTPServerError serviceUnavailable
]

{ #category : 'tests' }
HTTPErrorTest >> testHandlingHTTPClientError [

	self should: [ HTTPClientError notFound signal ] raise: HTTPError
]

{ #category : 'tests' }
HTTPErrorTest >> testHandlingHTTPServerError [

	self should: [ HTTPServerError internalServerError signal ] raise: HTTPError
]
