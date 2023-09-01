Extension { #name : #ZnEntity }

{ #category : #'*Hyperspace-Extensions' }
ZnEntity class >> with: anObject ofType: aMimeType [

	| entity |

	entity := (self concreteSubclassForType: aMimeType binary: aMimeType isBinary) type: aMimeType.
	aMimeType isBinary
		ifTrue: [ entity bytes: anObject ]
		ifFalse: [ entity string: anObject ].
	^ entity
]
