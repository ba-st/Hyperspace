Extension { #name : #ZnSingleThreadedServer }

{ #category : #'*Hyperspace-Model' }
ZnSingleThreadedServer >> logLevel [

	^ logLevel
]

{ #category : #'*Hyperspace-Model' }
ZnSingleThreadedServer >> setLogLevelAtLeastTo: integer [

	self logLevel: (integer max: logLevel)
]
