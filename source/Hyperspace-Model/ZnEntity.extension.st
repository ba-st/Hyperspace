Extension { #name : #ZnEntity }

{ #category : #'*Hyperspace-Model' }
ZnEntity class >> json: json [

	^ self stringEntityClass json: json
]

{ #category : #'*Hyperspace-Model' }
ZnEntity class >> with: anObject ofType: aMimeType [

	| entity |

	entity := (self concreteSubclassForType: aMimeType binary: aMimeType isBinary) type: aMimeType.
	aMimeType isBinary
		ifTrue: [ entity bytes: anObject ]
		ifFalse: [ entity string: anObject ].
	^ entity
]
