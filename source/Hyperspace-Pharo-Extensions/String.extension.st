Extension { #name : #String }

{ #category : #'*Hyperspace-Pharo-Extensions' }
String >> asAbsoluteUrl [

	^ self asUrl asAbsoluteUrl
]

{ #category : #'*Hyperspace-Pharo-Extensions' }
String >> asEntityTag [

	^ EntityTag fromString: self
]

{ #category : #'*Hyperspace-Pharo-Extensions' }
String >> asLanguageTag [

	^ LanguageTag fromString: self
]

{ #category : #'*Hyperspace-Pharo-Extensions' }
String >> asMediaType [

	^ self asZnMimeType
]

{ #category : #'*Hyperspace-Pharo-Extensions' }
String >> asWebLink [

	^ WebLink fromString: self
]
