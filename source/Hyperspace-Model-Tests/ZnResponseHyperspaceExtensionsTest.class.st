Class {
	#name : #ZnResponseHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> amazonUrl [

	^ 'https://amazon.com' asZnUrl
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> googleUrl [

	^ 'https://google.com' asZnUrl
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testAddSeveralLinks [

	| response |

	response := ZnResponse noContent
		addLink: ( ZnLink to: self googleUrl );
		addLink: ( ZnLink to: self amazonUrl );
		yourself.

	self
		assert: response links
		equals:
			{ ZnLink to: self googleUrl .
			  ZnLink to: self amazonUrl }
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

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testEntityTag [

	| response entityTag |

	entityTag := ZnETag with: '1234'.

	response := ZnResponse noContent
		setEntityTag: entityTag;
		yourself.

	self assert: response entityTag equals: entityTag.

	self should: [ ZnResponse noContent entityTag ] raise: KeyNotFound
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testLink [

	| response |

	response := ZnResponse noContent
		addLink: ( ZnLink to: self googleUrl );
		yourself.
		
	self assert: response links equals: { ZnLink to: self googleUrl }
]

{ #category : #tests }
ZnResponseHyperspaceExtensionsTest >> testWithEntityTagDo [

	| response entityTag wasFound |

	entityTag := ZnETag with: '1234'.
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
