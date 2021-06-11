Class {
	#name : #ZnRequestHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #private }
ZnRequestHyperspaceExtensionsTest >> googleUrl [

	^ 'https://google.com' asUrl
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testAcceptLanguage [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setAcceptLanguage: 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5';
		yourself.

	self assert: request acceptLanguage equals: 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5'.

	self should: [ ( ZnRequest get: self googleUrl ) acceptLanguage ] raise: KeyNotFound
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testHasLanguageProrityList [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setAcceptLanguage: 'fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5';
		yourself.

	self
		assert: request hasLanguageProrityList;
		deny: ( ZnRequest get: self googleUrl ) hasLanguageProrityList
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testIfMatch [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setIfMatchTo: ( ZnETag with: '12345' );
		yourself.

	self assert: ( request headers at: #'If-Match' ) equals: '"12345"'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testIfNoneMatch [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setIfNoneMatchTo: ( ZnETag with: '12345' );
		yourself.
		
	self assert: (request headers at: #'If-None-Match') equals: '"12345"'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testSetAcceptLanguageWithAny [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setAcceptLanguage: '*';
		yourself.

	self assert: request acceptLanguage equals: '*'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testSetAcceptLanguageWithLanguageTag [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setAcceptLanguage: ( LanguageTag fromString: 'fr-CH' );
		yourself.

	self assert: request acceptLanguage equals: 'fr-CH'
]
