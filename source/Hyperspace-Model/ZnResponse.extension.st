Extension { #name : #ZnResponse }

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addCachingDirective: aDirective [

	self headers at: 'Cache-Control' add: aDirective
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addLink: aLink [

	self headers at: 'Link' add: aLink
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
ZnResponse >> entityTag [

	^ (self headers at: 'ETag') asETag
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> links [

	| links |

	links := self headers at: 'Link' ifAbsent: [ ^ #() ].
	^ links isArray
		ifTrue: [ links ]
		ifFalse: [ Array with: links ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> setEntityTag: aStringORETag [

	self headers at: 'ETag' put: aStringORETag asETag asString
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> withEntityTagDo: foundBlock ifAbsent: absentBlock [

	self headers at: 'ETag' ifPresent: [ :headerValue | ^ foundBlock cull: headerValue asETag ].
	^ absentBlock value
]
