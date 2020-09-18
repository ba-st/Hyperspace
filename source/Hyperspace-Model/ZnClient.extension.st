Extension { #name : #ZnClient }

{ #category : #'*Hyperspace-Model' }
ZnClient >> logLevel [

	^ logLevel
]

{ #category : #'*Hyperspace-Model' }
ZnClient >> resetRequest [

	request := ZnRequest empty.
	response := nil
]

{ #category : #'*Hyperspace-Model' }
ZnClient >> setAccept: object [

	request setAccept: object
]

{ #category : #'*Hyperspace-Model' }
ZnClient >> setIfMatchTo: etag [

	request setIfMatchTo: etag
]

{ #category : #'*Hyperspace-Model' }
ZnClient >> setIfNoneMatchTo: etag [

	request setIfNoneMatchTo: etag
]

{ #category : #'*Hyperspace-Model' }
ZnClient >> setLogLevelAtLeastTo: integer [

	self logLevel: (integer max: logLevel)
]
