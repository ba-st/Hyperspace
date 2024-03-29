Class {
	#name : #ZnResponseHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #private }
ZnResponseHyperspaceExtensionsTest >> amazonUrl [

	^ 'https://amazon.com' asUrl
]

{ #category : #private }
ZnResponseHyperspaceExtensionsTest >> encodeAndDecode: response [

	^ ZnResponse
		readFrom: ( ByteArray streamContents: [ :stream | response writeOn: stream ] ) readStream
]

{ #category : #private }
ZnResponseHyperspaceExtensionsTest >> googleUrl [

	^ 'https://google.com' asUrl
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testAddContentLanguageTags [

	| response |

	response := ( ZnResponse ok: ( ZnEntity text: 'Ok' ) )
		addContentLanguage: ( LanguageTag fromString: 'en' );
		addContentLanguage: ( LanguageTag fromString: 'es-ar' );
		yourself.

	self
		assert: response contentLanguageTags
		equals:
			{( LanguageTag fromString: 'en' ).
			( LanguageTag fromString: 'es-AR' )}
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testAddSeveralLinks [

	| response |

	response := ZnResponse noContent
		addLink: ( WebLink to: self googleUrl );
		addLink: ( WebLink to: self amazonUrl );
		yourself.

	self
		assert: response links
		equals:
			{ WebLink to: self googleUrl .
			  WebLink to: self amazonUrl }
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testCachingDirectives [

	| response |

	response := ZnResponse noContent.

	response addCachingDirective: 'public'.
	self assert: response cachingDirectives equals: #('public').

	response addCachingDirective: 'Max-Age=60'.
	self assert: response cachingDirectives equals: #('public' 'Max-Age=60')
]

{ #category : #'tests - encoding' }
ZnResponseHyperspaceExtensionsTest >> testEncodeAndDecodeWithContentLanguageHeaders [

	| response decodedResponse |

	response := ( ZnResponse ok: ( ZnEntity text: 'Ok' ) )
		addContentLanguage: ( LanguageTag fromString: 'en' );
		addContentLanguage: ( LanguageTag fromString: 'es-ar' );
		yourself.

	decodedResponse := self encodeAndDecode: response.

	self assert: decodedResponse contentLanguageTags equals: response contentLanguageTags
]

{ #category : #'tests - encoding' }
ZnResponseHyperspaceExtensionsTest >> testEncodeAndDecodeWithEntityTag [

	| response entityTag decodedResponse |

	entityTag := EntityTag with: '1234'.
	response := ZnResponse noContent
		setEntityTag: entityTag;
		yourself.

	decodedResponse := self encodeAndDecode: response.
	decodedResponse
		withEntityTagDo: [ :foundEntityTag | self assert: foundEntityTag equals: entityTag ]
		ifAbsent: [ self fail ]
]

{ #category : #'tests - encoding' }
ZnResponseHyperspaceExtensionsTest >> testEncodeAndDecodeWithLinkHeaders [

	| response decodedResponse |

	response := ZnResponse noContent
		addLink: ( WebLink to: self amazonUrl );
		yourself.

	decodedResponse := self encodeAndDecode: response.

	self assert: decodedResponse links equals: response links
]

{ #category : #'tests - encoding' }
ZnResponseHyperspaceExtensionsTest >> testEncodeAndDecodeWithVaryHeaders [

	| response decodedResponse |

	response := ZnResponse noContent
		addToVary: 'Accept';
		addToVary: 'Accept-Language';
		yourself.

	decodedResponse := self encodeAndDecode: response.

	self assert: decodedResponse varyHeaderNames equals: response varyHeaderNames
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testEntityTag [

	| response entityTag |

	entityTag := EntityTag with: '1234'.

	response := ZnResponse noContent
		setEntityTag: entityTag;
		yourself.

	self assert: response entityTag equals: entityTag.

	self should: [ ZnResponse noContent entityTag ] raise: KeyNotFound
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testHasLocation [

	self
		deny: ZnResponse noContent hasLocation;
		assert: ( ZnResponse created: 'https://api.example.com/123' ) hasLocation
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testLink [

	| response |

	response := ZnResponse noContent
		addLink: ( WebLink to: self googleUrl );
		yourself.
		
	self assert: response links equals: { WebLink to: self googleUrl }
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testVary [

	| response |

	response := ZnResponse noContent
		addToVary: 'Accept';
		yourself.

	self assert: response varyHeaderNames equals: #('Accept').

	response := ZnResponse noContent
		addToVary: 'Accept';
		addToVary: 'Accept-Language';
		yourself.

	self assert: response varyHeaderNames equals: #('Accept' 'Accept-Language')
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testWithEntityTagDo [

	| response entityTag wasFound |

	entityTag := EntityTag with: '1234'.
	response := ZnResponse noContent
		setEntityTag: entityTag;
		yourself.

	wasFound := false.

	response
		withEntityTagDo: [ :foundEntityTag | 
			wasFound := true.
			self assert: foundEntityTag equals: entityTag
			]
		ifAbsent: [ self fail ].
	self assert: wasFound
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testWithEntityTagDoNotFound [

	| response headerWasNotFound |

	response := ZnResponse noContent.

	headerWasNotFound := false.

	response withEntityTagDo: [ self fail ] ifAbsent: [ headerWasNotFound := true ].

	self assert: headerWasNotFound
]
