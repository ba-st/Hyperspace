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
		setIfMatchTo: ( EntityTag with: '12345' );
		yourself.

	self assert: ( request headers at: #'If-Match' ) equals: '"12345"'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testIfNoneMatch [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setIfNoneMatchTo: ( EntityTag with: '12345' );
		yourself.
		
	self assert: (request headers at: #'If-None-Match') equals: '"12345"'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testQuery [

	| request output |

	request := ZnRequest query: self googleUrl / 'search'.

	self assert: request method equals: 'QUERY'.
	output := String streamContents: [ :s | request writeOn: s ].

	self
		assert: (output includesSubstring: 'QUERY /search HTTP/1.1');
		assert: (output includesSubstring: 'Host: google.com')
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testReadQueryRequest [

	| request |

	request := ZnRequest readFrom:
		           'QUERY /search HTTP/1.1<r><l>Host: google.com' expandMacros readStream.

	self
		assert: request method equals: #QUERY;
		assertUrl: request url equals: 'search';
		assertUrl: request host equals: 'http://google.com'
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
