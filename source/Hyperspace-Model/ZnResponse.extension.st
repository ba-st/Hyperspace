Extension { #name : #ZnResponse }

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addCachingDirective: aDirective [

	self headers at: 'Cache-Control' add: aDirective
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addContentLanguage: aLanguageTag [

	self headers at: 'Content-Language' add: aLanguageTag
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addLink: aLink [

	self headers at: 'Link' add: aLink
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addToVary: headerName [

	self headers at: 'Vary' add: headerName
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> cachingDirectives [

	| directives |

	directives := self headers at: 'Cache-Control' ifAbsent: [ ^ #() ].
	^ directives isArray
		ifTrue: [ directives ]
		ifFalse: [ Array with: directives ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> contentLanguageTags [

	| headerValue |

	headerValue := self headers at: 'Content-Language' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asLanguageTag ]
		ifFalse: [ Array with: headerValue asLanguageTag ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> entityTag [

	^ (self headers at: 'ETag') asETag
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> hasLocation [

	^ self headers includesKey: 'Location'
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> links [

	| headerValue |

	headerValue := self headers at: 'Link' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asWebLink ]
		ifFalse: [ Array with: headerValue asWebLink ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> setEntityTag: aStringORETag [

	self headers at: 'ETag' put: aStringORETag asETag asString
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> varyHeaderNames [

	| headerValue |

	headerValue := self headers at: 'Vary' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue ]
		ifFalse: [ Array with: headerValue ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> withEntityTagDo: foundBlock ifAbsent: absentBlock [

	self headers at: 'ETag' ifPresent: [ :headerValue | ^ foundBlock cull: headerValue asETag ].
	^ absentBlock value
]
