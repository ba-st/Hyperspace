"
I'm a test for extensions on ZnUrl
"
Class {
	#name : #ZnUrlTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnUrlTest >> testAsHostedAt [

	self
		assert:
			( 'https://api.example.com:1122/pets?name=fidus' asUrl
				asHostedAt: 'http://alternative.server.org:4874/reference?no=true' asUrl )
			equals: 'https://alternative.server.org:4874/pets?name=fidus' asUrl;
		assert:
			( 'https://api.example.com/pets?name=fidus' asUrl
				asHostedAt: 'http://alternative.server.org:4874/reference?no=true' asUrl )
			equals: 'https://alternative.server.org:4874/pets?name=fidus' asUrl;
		assert:
			( 'https://api.example.com:1122/pets?name=fidus' asUrl
				asHostedAt: 'http://alternative.server.org/reference?no=true' asUrl )
			equals: 'https://alternative.server.org/pets?name=fidus' asUrl;
		assert:
			( 'https://api.example.com/pets?name=fidus' asUrl
				asHostedAt: 'http://alternative.server.org/reference?no=true' asUrl )
			equals: 'https://alternative.server.org/pets?name=fidus' asUrl;
		assert:
			( 'https://api.example.com/pets' asUrl
				asHostedAt: 'http://alternative.server.org/reference?no=true' asUrl )
			equals: 'https://alternative.server.org/pets' asUrl;
		assert:
			( 'https://api.example.com/pets?name=fidus' asUrl asHostedAt: 'http://alternative.server.org' asUrl )
			equals: 'https://alternative.server.org/pets?name=fidus' asUrl
]

{ #category : #tests }
ZnUrlTest >> testQueryAtPutUrl [

	self
		assert:
			( 'https://api.example.com/pets' asUrl
				queryAt: 'relatedTo'
				putUrl: 'https://api.example.com/pets/99' )
		equals: 'https://api.example.com/pets?relatedTo=https%253A%252F%252Fapi.example.com%252Fpets%252F99' asUrl
]

{ #category : #tests }
ZnUrlTest >> testStartLimit [

	self
		assert: ( 'https://api.example.com/pets' asUrl start: 1 limit: 10 )
			equals: 'https://api.example.com/pets?limit=10&start=1' asUrl;
		assert: ( 'https://api.example.com/pets' asUrl start: 1 limit: 10 )
			equals: 'https://api.example.com/pets?start=1&limit=10' asUrl
]
