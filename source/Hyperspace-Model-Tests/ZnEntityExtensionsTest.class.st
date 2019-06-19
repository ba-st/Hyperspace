"
I'm a test case for Hyperspace's ZnEntity extensions
"
Class {
	#name : #ZnEntityExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Extensions'
}

{ #category : #tests }
ZnEntityExtensionsTest >> applicationJson [

	^ 'application/json' asMediaType
]

{ #category : #tests }
ZnEntityExtensionsTest >> testJsonExtension [

	| entity |

	entity := ZnEntity json: '{}'.
	self
		assert: entity contents equals: '{}';
		assert: entity contentType equals: self applicationJson
]

{ #category : #tests }
ZnEntityExtensionsTest >> testWithOfTypeExtension [

	| entity |

	entity := ZnEntity with: 'Hello!' ofType: self applicationJson.
	self
		assert: ( entity isA: ZnStringEntity );
		assert: entity contents equals: 'Hello!';
		assert: entity contentType equals: self applicationJson.

	entity := ZnEntity with: 'Hello!' ofType: 'text/plain' asMediaType.
	self
		assert: ( entity isA: ZnStringEntity );
		assert: entity contents equals: 'Hello!';
		assert: entity contentType equals: 'text/plain' asMediaType.

	entity := ZnEntity with: 'Hello!' ofType: 'application/octet-stream' asMediaType.
	self
		assert: ( entity isA: ZnByteArrayEntity );
		assert: entity contents equals: 'Hello!';
		assert: entity contentType equals: 'application/octet-stream' asMediaType
]
