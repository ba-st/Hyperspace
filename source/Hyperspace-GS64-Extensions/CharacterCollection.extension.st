Extension { #name : #CharacterCollection }

{ #category : #'*Hyperspace-GS64-Extensions' }
CharacterCollection >> asAbsoluteUrl [

	^ self asUrl asAbsoluteUrl
]

{ #category : #'*Hyperspace-GS64-Extensions' }
CharacterCollection >> asEntityTag [

	^ EntityTag fromString: self
]

{ #category : #'*Hyperspace-GS64-Extensions' }
CharacterCollection >> asLanguageTag [

	^ LanguageTag fromString: self
]

{ #category : #'*Hyperspace-GS64-Extensions' }
CharacterCollection >> asMediaType [

	^ self asZnMimeType
]

{ #category : #'*Hyperspace-GS64-Extensions' }
CharacterCollection >> asWebLink [

	^ WebLink fromString: self
]
