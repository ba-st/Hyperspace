Class {
	#name : 'HTTPNotAcceptableTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-Exceptions',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Exceptions'
}

{ #category : 'tests' }
HTTPNotAcceptableTest >> testAdditionalData [

	| error readData |

	error := HTTPNotAcceptable
		         messageText: 'Cannot generate a response entity with acceptable characteristics.'
		         accepting: { 'application/json' asMediaType }
		         inAnyOf: #(  ).
	readData := OrderedCollection new.
	error additionalDataKeysAndValuesDo: [ :key :value | readData add: key -> value ].

	self
		assert: error hasAdditionalData;
		assert: readData asArray
		equals: { ( 'allowedMediaTypes' -> ( Array with: 'application/json' asMediaType ) ) }
]

{ #category : 'tests' }
HTTPNotAcceptableTest >> testSignaling [

	self
		should: [ HTTPNotAcceptable
				signal: 'Cannot generate a response entity with acceptable characteristics.'
				accepting:
					{'application/json' asMediaType.
					'plain/text' asMediaType}
			]
		raise: HTTPNotAcceptable
		withExceptionDo: [ :signal | 
			self
				assert: signal code equals: 406;
				assert: signal messageText
					equals: 'Cannot generate a response entity with acceptable characteristics.';
				assertCollection: signal allowedMediaTypes
					hasSameElements:
					{'application/json' asMediaType.
					'plain/text' asMediaType};
				assert: signal allowedLanguageTags isEmpty
			]
]
