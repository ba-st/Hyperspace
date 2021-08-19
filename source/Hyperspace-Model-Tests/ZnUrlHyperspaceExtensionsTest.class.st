"
I'm a test for extensions on ZnUrl
"
Class {
	#name : #ZnUrlHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testAsHostedAt [

	self
		assert: ( 'http://api.example.com/resource' asUrl asHostedAt: 'http://alternative.org' asUrl )
			equals: 'http://alternative.org/resource' asUrl;
		assert: ( 'http://api.example.com/resource' asUrl asHostedAt: 'https://alternative.org' asUrl )
			equals: 'https://alternative.org/resource' asUrl;
		assert: ( 'http://api.example.com:1111/resource' asUrl asHostedAt: 'http://alternative.org' asUrl )
			equals: 'http://alternative.org/resource' asUrl;
		assert: ( 'http://api.example.com/resource' asUrl asHostedAt: 'http://alternative.org:2222' asUrl )
			equals: 'http://alternative.org:2222/resource' asUrl;
		assert: ( 'http://api.example.com:1111/resource' asUrl asHostedAt: 'http://alternative.org:2222' asUrl )
			equals: 'http://alternative.org:2222/resource' asUrl;
		assert: ( 'http://api.example.com:1111/resource' asUrl asHostedAt: 'https://alternative.org:2222' asUrl )
			equals: 'https://alternative.org:2222/resource' asUrl
]

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testAsWebLink [

	| url |

	url := 'https://api.example.com/pets' asUrl.
	self assert: url asWebLink equals: ( WebLink to: url )
]

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testHasValidOrigins [

	self assert: 'http://example.com/' asUrl hasValidOrigin.
	self assert: 'http://example.com:80/' asUrl hasValidOrigin.
	self assert: 'http://example.com/path/file' asUrl hasValidOrigin.
	self assert: 'http://example.com:8080/' asUrl hasValidOrigin.
	self assert: 'http://www.example.com/' asUrl hasValidOrigin.
	self assert: 'https://example.com:80/' asUrl hasValidOrigin.
	self assert: 'https://example.com/' asUrl hasValidOrigin.
	self assert: 'http://example.org/' asUrl hasValidOrigin.
	self assert: 'http://ietf.org/' asUrl hasValidOrigin.
	self assert: 'http://127.0.0.1:8081/the/path/' asUrl hasValidOrigin.
	self assert: 'https://johndoe@www.example.com:123/forum/questions?id=1' asUrl hasValidOrigin.
	self assert: 'https://johndoe@www.example.com:123/forum/questions?id=1' asUrl hasValidOrigin.
	self deny: 'mailto:John.doe@example.com' asUrl hasValidOrigin.

]

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testOrigins [

	self assert: 'http://example.com/' asUrl origin equals: 'http://example.com'.
	self assert: 'http://example.com:80/' asUrl origin equals: 'http://example.com'.
	self assert: 'http://example.com/path/file' asUrl origin equals: 'http://example.com'.
	self assert: 'http://example.com:8080/' asUrl origin equals: 'http://example.com:8080'.
	self assert: 'http://www.example.com/' asUrl origin equals: 'http://www.example.com'.
	self assert: 'https://example.com:80/' asUrl origin equals: 'https://example.com'.
	self assert: 'https://example.com/' asUrl origin equals: 'https://example.com'.
	self assert: 'http://example.org/' asUrl origin equals: 'http://example.org'.
	self assert: 'http://ietf.org/' asUrl origin equals: 'http://ietf.org'.
	self assert: 'http://127.0.0.1:8081/the/path/' asUrl origin equals: 'http://127.0.0.1:8081'.
	self assert: 'https://johndoe@www.example.com:123/forum/questions?id=1' asUrl origin equals: 'https://www.example.com:123'.
	self
		should: [ 'mailto:John.doe@example.com' asUrl origin ]
		raise: InstanceCreationFailed
		withMessageText: 'mailto:John.doe@example.com does not comply with a valid origin'
]

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testQueryAtPutUrl [

	self
		assert:
			( 'https://api.example.com/pets' asUrl
				queryAt: 'relatedTo'
				putUrl: 'https://api.example.com/pets/99' )
		equals: 'https://api.example.com/pets?relatedTo=https%253A%252F%252Fapi.example.com%252Fpets%252F99' asUrl
]

{ #category : #tests }
ZnUrlHyperspaceExtensionsTest >> testStartLimit [

	self
		assert: ( 'https://api.example.com/pets' asUrl start: 1 limit: 10 )
			equals: 'https://api.example.com/pets?limit=10&start=1' asUrl;
		assert: ( 'https://api.example.com/pets' asUrl start: 1 limit: 10 )
			equals: 'https://api.example.com/pets?start=1&limit=10' asUrl
]
