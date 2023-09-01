Extension { #name : #ZnSingleThreadedServer }

{ #category : #'*Hyperspace-Extensions' }
ZnSingleThreadedServer >> logLevel [

	^ logLevel
]

{ #category : #'*Hyperspace-Extensions' }
ZnSingleThreadedServer >> setLogLevelAtLeastTo: integer [

	self logLevel: (integer max: logLevel)
]
