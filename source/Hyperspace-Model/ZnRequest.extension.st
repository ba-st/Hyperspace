Extension { #name : #ZnRequest }

{ #category : #'*Hyperspace-Model' }
ZnRequest >> setIfMatchTo: etag [

	self headers at: #'If-Match' put: etag asString
]

{ #category : #'*Hyperspace-Model' }
ZnRequest >> setIfNoneMatchTo: etag [

	self headers at: #'If-None-Match' put: etag asString
]
