Class {
	#name : #ZnEventToLogRecordController,
	#superclass : #Object,
	#instVars : [
		'logOutgoingRequests',
		'logIncomingRequests',
		'subscriptions'
	],
	#category : #'Hyperspace-Model'
}

{ #category : #'private - dumping' }
ZnEventToLogRecordController >> asStructuredRequest: aZnRequest [

	| json |

	json := NeoJSONObject new.
	json
		at: #method put: aZnRequest method;
		at: #uri put: aZnRequest uri asString.
	^json
]

{ #category : #'private - dumping' }
ZnEventToLogRecordController >> asStructuredResponse: aZnResponse [

	| json |

	json := NeoJSONObject new.
	json
		at: #code put: aZnResponse code;
		at: #totalSize put: aZnResponse contentLength.
	^json
]

{ #category : #'private - dumping' }
ZnEventToLogRecordController >> dumpConnectionEvent: aZnServerConnectionClosedEvent on: data [

	 data
		  at: #remoteAddress
		  put: ( ZnNetworkingUtils ipAddressToString: aZnServerConnectionClosedEvent address );
		  at: #processId put: aZnServerConnectionClosedEvent processId;
		  at: #eventId put: aZnServerConnectionClosedEvent id
]

{ #category : #'private - dumping' }
ZnEventToLogRecordController >> dumpRequestAndResponseOf: event on: json [

	| response |

	self dumpRequestOf: event on: json.
	response := event response.
	(response hasEntity
		and: [response entity hasContentType and: [response entity contentType isBinary not]])
			then: [json at: #response put: (self asStructuredResponse: response)].
	^json
]

{ #category : #'private - dumping' }
ZnEventToLogRecordController >> dumpRequestOf: event on: json [

	json
		at: #summary put: event printString;
		at: #durationInMilliseconds put: event duration;
		at: #request put: (self asStructuredRequest: event request); 
		at: #processId put: event processId; 
		at: #eventId put: event id. 
	^json
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> initialize [

	super initialize.

	logOutgoingRequests := false.
	logIncomingRequests := false.
	subscriptions := OrderedCollection new
]

{ #category : #'private - configuring' }
ZnEventToLogRecordController >> logIncomingRequests: aBoolean [

	logIncomingRequests := aBoolean
]

{ #category : #'private - configuring' }
ZnEventToLogRecordController >> logOutgoingRequests: aBoolean [

	logOutgoingRequests := aBoolean
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> startUp [

	logOutgoingRequests then: [ self startUpOutgoingRequestListeners ].

	logIncomingRequests then: [ self startUpIncomingRequestListeners ]
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> startUpIncomingRequestListeners [

	self subscribeToEventsOf: ZnServerConnectionClosedEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Server closed connection'
			with: [ :data | self dumpConnectionEvent: event on: data ]
		].
	self subscribeToEventsOf: ZnConnectionAcceptedEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Server accepted connection'
			with: [ :data | self dumpConnectionEvent: event on: data ]
		].
	self subscribeToEventsOf: ZnRequestReadEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Incoming HTTP request received'
			with: [ :data | self dumpRequestOf: event on: data ]
		].
	self subscribeToEventsOf: ZnRequestResponseHandledEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Incoming HTTP request responded'
			with: [ :data | self dumpRequestAndResponseOf: event on: data ]
		]
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> startUpOutgoingRequestListeners [

	self subscribeToEventsOf: ZnRequestWrittenEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Outgoing HTTP request sent'
			with: [ :data | self dumpRequestOf: event on: data ]
		].
	self subscribeToEventsOf: ZnClientTransactionEvent andDo: [ :event |
		LogRecord emitStructuredDebuggingInfo: 'Outgoing HTTP request responded'
			with: [ :data | self dumpRequestAndResponseOf: event on: data ]
		]
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> stop [

	subscriptions do: [:subscription | ZnLogEvent announcer removeSubscription: subscription]
]

{ #category : #'system startup' }
ZnEventToLogRecordController >> subscribeToEventsOf: anEventType andDo: aBlock [

	subscriptions add: (ZnLogEvent announcer when: anEventType do: aBlock)
]
