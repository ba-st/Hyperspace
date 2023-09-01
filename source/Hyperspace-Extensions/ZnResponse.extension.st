Extension { #name : #ZnResponse }

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> addCachingDirective: aDirective [

	self headers at: 'Cache-Control' add: aDirective
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> addContentLanguage: aLanguageTag [

	self headers at: 'Content-Language' add: aLanguageTag
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> addLink: aLink [

	self headers at: 'Link' add: aLink
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> addToVary: headerName [

	self headers at: 'Vary' add: headerName
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> cachingDirectives [

	| directives |

	directives := self headers at: 'Cache-Control' ifAbsent: [ ^ #() ].
	^ directives isArray
		ifTrue: [ directives ]
		ifFalse: [ Array with: directives ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> contentLanguageTags [

	| headerValue |

	headerValue := self headers at: 'Content-Language' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asLanguageTag ]
		ifFalse: [ Array with: headerValue asLanguageTag ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> entityTag [

	^ (self headers at: 'ETag') asEntityTag
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> hasLocation [

	^ self headers includesKey: 'Location'
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> links [

	| headerValue |

	headerValue := self headers at: 'Link' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asWebLink ]
		ifFalse: [ Array with: headerValue asWebLink ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> setEntityTag: aStringOrEntityTag [

	self headers at: 'ETag' put: aStringOrEntityTag asEntityTag asString
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> varyHeaderNames [

	| headerValue |

	headerValue := self headers at: 'Vary' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue ]
		ifFalse: [ Array with: headerValue ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnResponse >> withEntityTagDo: foundBlock ifAbsent: absentBlock [

	self headers at: 'ETag' ifPresent: [ :headerValue | ^ foundBlock cull: headerValue asEntityTag ].
	^ absentBlock value
]
