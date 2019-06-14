Extension { #name : #UUID }

{ #category : #'*Hyperspace-Model' }
UUID >> neoJsonOn: neoJSONWriter [

	neoJSONWriter writeString: self printString
]
