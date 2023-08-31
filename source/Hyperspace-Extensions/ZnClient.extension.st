Extension { #name : #ZnClient }

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> logLevel [

	^ logLevel
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> query [
	"Execute an HTTP QUERY the request set up and return the response #contents."

	^ ZnRequest supportQUERYDuring: [
		  self
			  method: #QUERY;
			  execute
		  ]
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> resetRequest [

	request := ZnRequest empty.
	response := nil
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> setAccept: object [

	request setAccept: object
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> setIfMatchTo: etag [

	request setIfMatchTo: etag
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> setIfNoneMatchTo: etag [

	request setIfNoneMatchTo: etag
]

{ #category : #'*Hyperspace-Extensions' }
ZnClient >> setLogLevelAtLeastTo: integer [

	self logLevel: (integer max: logLevel)
]
