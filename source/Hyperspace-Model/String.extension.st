Extension { #name : #String }

{ #category : #'*Hyperspace-Model' }
String >> asETag [

	^ ZnETag fromString: self
]

{ #category : #'*Hyperspace-Model' }
String >> asLanguageTag [

	^ LanguageTag fromString: self
]

{ #category : #'*Hyperspace-Model' }
String >> asMediaType [

	^ self asZnMimeType
]

{ #category : #'*Hyperspace-Model' }
String >> asWebLink [

	^ ZnLink fromString: self
]
