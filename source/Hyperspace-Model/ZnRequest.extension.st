Extension { #name : #ZnRequest }

{ #category : #'*Hyperspace-Model' }
ZnRequest >> acceptLanguage [

	^ self headers at: 'Accept-Language'
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> hasLanguageProrityList [

	^ self headers includesKey: 'Accept-Language'
]

{ #category : #'*Hyperspace-Model' }
ZnRequest class >> query: urlObject [

	^ self supportQUERYDuring: [ self method: #QUERY url: urlObject ]
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> readFrom: stream [

	^ self class supportQUERYDuring: [ super readFrom: stream ]
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> setAcceptLanguage: acceptLanguageDirectives [

	self headers at: 'Accept-Language' put: acceptLanguageDirectives asString
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> setIfMatchTo: etag [

	self headers at: 'If-Match' put: etag asString
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> setIfNoneMatchTo: etag [

	self headers at: 'If-None-Match' put: etag asString
]

{ #category : #'*Hyperspace-Model' }
ZnRequest class >> supportQUERYDuring: aBlock [

	^ aBlock
		  on: ZnUnknownHttpMethod
		  do: [ :signal | signal resume: signal method ]
]
