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
