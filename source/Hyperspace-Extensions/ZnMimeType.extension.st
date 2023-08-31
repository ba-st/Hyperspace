Extension { #name : #ZnMimeType }

{ #category : #'*Hyperspace-Extensions' }
ZnMimeType >> accepts: aMimeType [

	^ (aMimeType main = '*' or: [ aMimeType main = self main ])
		and: [ aMimeType sub = '*'
				or: [ self sub = aMimeType sub or: [ (self sub splitOn: $+) includes: aMimeType sub ] ] ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnMimeType >> asMediaType [

	^ self
]

{ #category : #'*Hyperspace-Extensions' }
ZnMimeType >> quality [

	^ Float readFrom: (self parameterAt: 'q' ifAbsent: [ ^1.0 ])
]

{ #category : #'*Hyperspace-Extensions' }
ZnMimeType >> version: aVersionString [

	self parameters at: 'version' put: aVersionString
]
