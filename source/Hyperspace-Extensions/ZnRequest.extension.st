Extension { #name : #ZnRequest }

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> acceptLanguage [

	^ self headers at: 'Accept-Language'
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> hasLanguageProrityList [

	^ self headers includesKey: 'Accept-Language'
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest class >> query: urlObject [

	^ self supportQUERYDuring: [ self method: #QUERY url: urlObject ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> readFrom: stream [

	^ self class supportQUERYDuring: [ super readFrom: stream ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> setAcceptLanguage: acceptLanguageDirectives [

	self headers at: 'Accept-Language' put: acceptLanguageDirectives asString
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> setIfMatchTo: etag [

	self headers at: 'If-Match' put: etag asString
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest >> setIfNoneMatchTo: etag [

	self headers at: 'If-None-Match' put: etag asString
]

{ #category : #'*Hyperspace-Extensions' }
ZnRequest class >> supportQUERYDuring: aBlock [

	^ aBlock
		  on: ZnUnknownHttpMethod
		  do: [ :signal | signal resume: signal method ]
]
