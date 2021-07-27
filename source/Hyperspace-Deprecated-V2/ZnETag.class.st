Class {
	#name : #ZnETag,
	#superclass : #Object,
	#category : #'Hyperspace-Deprecated-V2'
}

{ #category : #'instance creation' }
ZnETag class >> fromString: aString [

	self deprecated: 'Use EntityTag'
		transformWith: 'ZnETag fromString: `@string' -> 'EntityTag fromString: `@string'.
	^ EntityTag fromString: aString
]

{ #category : #testing }
ZnETag class >> isDeprecated [

	^ true
]

{ #category : #'instance creation' }
ZnETag class >> weakWith: anETagValue [

	self deprecated: 'Use EntityTag'
		transformWith: 'ZnETag weakWith: `@string' -> 'EntityTag weakWith: `@string'.
	^ EntityTag weakWith: anETagValue
]

{ #category : #'instance creation' }
ZnETag class >> with: anETagValue [

	self deprecated: 'Use EntityTag'
		transformWith: 'ZnETag with: `@string' -> 'EntityTag with: `@string'.
	^ EntityTag with: anETagValue
]
