Extension { #name : #ZnMimeType }

{ #category : #'*Hyperspace-Model' }
ZnMimeType >> accepts: aMimeType [

	^ (aMimeType main = '*' or: [ aMimeType main = self main ])
		and: [ aMimeType sub = '*'
				or: [ self sub = aMimeType sub or: [ (self sub splitOn: $+) includes: aMimeType sub ] ] ]
]

{ #category : #'*Hyperspace-Model' }
ZnMimeType >> asMediaType [

	^ self
]

{ #category : #'*Hyperspace-Model' }
ZnMimeType >> quality [

	^ Float readFrom: (self parameterAt: 'q' ifAbsent: [ ^1.0 ])
]

{ #category : #'*Hyperspace-Model' }
ZnMimeType >> version: aVersionString [

	self parameters at: 'version' put: aVersionString
]
