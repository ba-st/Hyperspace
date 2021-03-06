Extension { #name : #ZnUrl }

{ #category : #'*Hyperspace-Model' }
ZnUrl >> asHostedAt: aBaseUrl [

	^ self copy
		scheme: aBaseUrl scheme;
		host: aBaseUrl host;
		port: aBaseUrl port;
		yourself
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
