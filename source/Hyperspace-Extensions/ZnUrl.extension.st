Extension { #name : #ZnUrl }

{ #category : #'*Hyperspace-Extensions' }
ZnUrl >> asAbsoluteUrl [

	AssertionChecker
		enforce: [ self isAbsolute ]
		because: [ '<1p> is a relative URL' expandMacrosWith: self ]
		raising: InstanceCreationFailed.

	^ self
]

{ #category : #'*Hyperspace-Extensions' }
ZnUrl >> asHostedAt: aBaseUrl [

	^ self copy
		scheme: aBaseUrl scheme;
		host: aBaseUrl host;
		port: aBaseUrl port;
		yourself
]

{ #category : #'*Hyperspace-Extensions' }
ZnUrl >> asWebLink [

	^ WebLink to: self
]

{ #category : #'*Hyperspace-Extensions' }
ZnUrl >> queryAt: aKey putUrl: anUnencodedUrl [

	| encodedUrl |

	encodedUrl := anUnencodedUrl urlEncoded.
	^ self queryAt: aKey put: encodedUrl
]

{ #category : #'*Hyperspace-Extensions' }
ZnUrl >> start: startIndex limit: limitCount [

	self
		queryAt: 'start' put: startIndex;
		queryAt: 'limit' put: limitCount
]
