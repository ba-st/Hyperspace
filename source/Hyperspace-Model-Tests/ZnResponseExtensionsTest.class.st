Class {
	#name : #ZnResponseExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Extensions'
}

{ #category : #tests }
ZnResponseExtensionsTest >> amazonUrl [

	^ 'https://amazon.com' asZnUrl
]

{ #category : #tests }
ZnResponseExtensionsTest >> googleUrl [

	^ 'https://google.com' asZnUrl
]

{ #category : #tests }
ZnResponseExtensionsTest >> testAddSeveralLinks [

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
ZnResponseExtensionsTest >> testEntityTag [

	| response entityTag |

	entityTag := ZnETag with: '1234'.

	response := ZnResponse noContent
		setEntityTag: entityTag;
		yourself.

	self assert: response entityTag equals: entityTag
]

{ #category : #tests }
ZnResponseExtensionsTest >> testLink [

	| response |

	response := ZnResponse noContent
		addLink: ( ZnLink to: self googleUrl );
		yourself.
		
	self assert: response links equals: { ZnLink to: self googleUrl }
]

{ #category : #tests }
ZnResponseExtensionsTest >> testWithEntityTagDo [

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
ZnResponseExtensionsTest >> testWithEntityTagDoNotFound [

	| response headerWasNotFound |

	response := ZnResponse noContent.

	headerWasNotFound := false.

	response withEntityTagDo: [ self fail ] ifAbsent: [ headerWasNotFound := true ].

	self assert: headerWasNotFound
]
