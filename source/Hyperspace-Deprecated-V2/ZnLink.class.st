Class {
	#name : #ZnLink,
	#superclass : #Object,
	#category : #'Hyperspace-Deprecated-V2'
}

{ #category : #accessing }
ZnLink class >> fromString: aString [

	self deprecated: 'Use WebLink'
		transformWith: 'ZnLink fromString: `@string' -> 'WebLink fromString: `@string'.
	^ WebLink fromString: aString
]

{ #category : #testing }
ZnLink class >> isDeprecated [

	^ true
]

{ #category : #accessing }
ZnLink class >> to: aUrl [

	self deprecated: 'Use WebLink' transformWith: 'ZnLink to: `@url' -> 'WebLink to: `@url'.
	^ WebLink to: aUrl
]
