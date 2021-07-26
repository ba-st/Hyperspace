Extension { #name : #String }

{ #category : #'*Hyperspace-Model' }
String >> asEntityTag [

	^ EntityTag fromString: self
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

	^ WebLink fromString: self
]
