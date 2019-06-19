Extension { #name : #String }

{ #category : #'*Hyperspace-Model' }
String >> asETag [

	^ ZnETag fromString: self
]

{ #category : #'*Hyperspace-Model' }
String >> asMediaType [

	^ self asZnMimeType
]
