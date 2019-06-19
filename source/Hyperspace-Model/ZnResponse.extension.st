Extension { #name : #ZnResponse }

{ #category : #'*Hyperspace-Model' }
ZnResponse >> addLink: aLink [

	self headers at: 'Link' add: aLink
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> entityTag [

	^ (self headers at: 'ETag') asETag
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> links [

	| links |

	links := self headers at: 'Link' ifAbsent: [ ^ #() ].
	^ links isCollection
		ifTrue: [ links ]
		ifFalse: [ Array with: links ]
]

{ #category : #'*Hyperspace-Model' }
ZnResponse >> setEntityTag: aStringORETag [

	self headers at: 'ETag' put: aStringORETag asETag asString
]
