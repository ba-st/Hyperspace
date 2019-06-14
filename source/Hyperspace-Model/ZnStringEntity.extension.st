Extension { #name : #ZnStringEntity }

{ #category : #'*Hyperspace-Model' }
ZnStringEntity class >> json: string [

	^ (self type: ZnMimeType applicationJson)
		string: string;
		yourself
]
