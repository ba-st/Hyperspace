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
