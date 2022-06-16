Extension { #name : #ZnUrl }

{ #category : #'*Hyperspace-Model' }
ZnUrl >> asAbsoluteUrl [

	AssertionChecker
		enforce: [ self isAbsolute ]
		because: [ '<1p> is a relative URL' expandMacrosWith: self ]
		raising: InstanceCreationFailed.

	^ self
]

{ #category : #'*Hyperspace-Model' }
ZnUrl >> asHostedAt: aBaseUrl [

	^ self copy
		scheme: aBaseUrl scheme;
		host: aBaseUrl host;
		port: aBaseUrl port;
		yourself
]

{ #category : #'*Hyperspace-Model' }
ZnUrl >> asWebLink [

	^ WebLink to: self
]

{ #category : #'*Hyperspace-Model' }
ZnUrl >> queryAt: aKey putUrl: anUnencodedUrl [

	| encodedUrl |

	encodedUrl := anUnencodedUrl urlEncoded.
	^ self queryAt: aKey put: encodedUrl
]

{ #category : #'*Hyperspace-Model' }
ZnUrl >> start: startIndex limit: limitCount [

	self
		queryAt: 'start' put: startIndex;
		queryAt: 'limit' put: limitCount
]
