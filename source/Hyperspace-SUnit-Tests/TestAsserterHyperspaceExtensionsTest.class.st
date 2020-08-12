Class {
	#name : #TestAsserterHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-SUnit-Tests'
}

{ #category : #tests }
TestAsserterHyperspaceExtensionsTest >> testAssertUrlEquals [

	self
		assertUrl: 'https://google.com' equals: 'https://google.com';
		assertUrl: 'https://google.com' asUrl equals: 'https://google.com';
		assertUrl: 'https://google.com' equals: 'https://google.com' asUrl;
		assertUrl: 'https://google.com' asUrl equals: 'https://google.com' asUrl
]
