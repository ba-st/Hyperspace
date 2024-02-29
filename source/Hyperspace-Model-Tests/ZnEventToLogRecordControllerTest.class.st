Class {
	#name : #ZnEventToLogRecordControllerTest,
	#superclass : #TestCase,
	#instVars : [
		'loggingAsserter',
		'zincEventToLogRecordAdapter'
	],
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #private }
ZnEventToLogRecordControllerTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatch: expectedLogEntries [

	loggingAsserter
		runMemoryLoggerDuring: aBlock;
		assertLogRecordsMatch: expectedLogEntries
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> setUp [

	super setUp.
	loggingAsserter := LoggingAsserter on: self.
	zincEventToLogRecordAdapter := ZnEventToLogRecordAdapter new
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> tearDown [

	zincEventToLogRecordAdapter stopListeners.
	loggingAsserter stopLoggers.

	super tearDown
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> testLogsOfIncomingGetRequest [

	zincEventToLogRecordAdapter
		logIncomingRequests: true;
		startUpListeners.

	self
		runMemoryLoggerDuring: [
			self withServerDo: [ :server |
				| client |

				server onRequestRespond: [ :request |
					( ZnResponse ok: ( ZnEntity textCRLF: 'OK' ) )
						setConnectionClose;
						yourself
					].
				client := ZnClient new.
				client url: server localUrl.
				client get
				]
			]
		assertingLogRecordsMatch: #( 
				'[DEBUG] Server accepted connection {"remoteAddress":"127.0.0.1","processId":598770,"eventId":63}'
				'[DEBUG] Incoming HTTP request received {"summary":"2024-02-09 18:11:48 066 148126 Request Read a ZnRequest(GET /) 0ms","durationInMilliseconds":0,"request":{"method":"GET","uri":"/"},"processId":148126,"eventId":66}'
				'[DEBUG] Incoming HTTP request responded {"summary":"2024-02-09 18:11:48 067 148126 Request Handled a ZnRequest(GET /) 2ms","durationInMilliseconds":2,"request":{"method":"GET","uri":"/"},"processId":148126,"eventId":67,"response":{"code":200,"totalSize":4}}'
			   '[DEBUG] Server closed connection {"remoteAddress":"127.0.0.1","processId":148126,"eventId":70}' )
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> testLogsOfIncomingPostRequest [

	zincEventToLogRecordAdapter
		logIncomingRequests: true;
		startUpListeners.

	self
		runMemoryLoggerDuring: [
			self withServerDo: [ :server |
				| client |

				server onRequestRespond: [ :request |
					( ZnResponse ok: ( ZnEntity textCRLF: 'Hi you too!' ) )
						setConnectionClose;
						yourself
					].
				client := ZnClient new.
				client post: server localUrl contents: 'Hi there!'
				]
			]
		assertingLogRecordsMatch: #( 
				'[DEBUG] Server accepted connection {"remoteAddress":"127.0.0.1","processId":598770,"eventId":63}'
				'[DEBUG] Incoming HTTP request received {"summary":"2024-02-09 18:11:48 066 148126 Request Read a ZnRequest(GET /) 0ms","durationInMilliseconds":0,"request":{"method":"GET","uri":"/"},"processId":148126,"eventId":66}'
				'[DEBUG] Incoming HTTP request responded {"summary":"2024-02-09 18:11:48 067 148126 Request Handled a ZnRequest(GET /) 2ms","durationInMilliseconds":2,"request":{"method":"GET","uri":"/"},"processId":148126,"eventId":67,"response":{"code":200,"totalSize":4}}'
			   '[DEBUG] Server closed connection {"remoteAddress":"127.0.0.1","processId":148126,"eventId":70}' )
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> testLogsOfOutgoingGetRequest [

	zincEventToLogRecordAdapter
		logOutgoingRequests: true;
		startUpListeners.

	self
		runMemoryLoggerDuring: [
			self withServerDo: [ :server |
				| client |

				server onRequestRespond: [ :request |
					( ZnResponse ok: ( ZnEntity textCRLF: 'OK' ) )
						setConnectionClose;
						yourself
					].
				client := ZnClient new.
				client url: server localUrl.
				client get
				]
			]
		assertingLogRecordsMatch:
			#( '[DEBUG] Outgoing HTTP request sent {"summary":"2024-02-09 18:14:30 095 726586 Request Written a ZnRequest(GET /) 0ms","durationInMilliseconds":0,"request":{"method":"GET","uri":"http://localhost:35059/"},"processId":726586,"eventId":95}'
			   '[DEBUG] Outgoing HTTP request responded {"summary":"2024-02-09 18:14:30 102 726586 GET / 200 4B 2ms","durationInMilliseconds":2,"request":{"method":"GET","uri":"http://localhost:35059/"},"processId":726586,"eventId":102,"response":{"code":200,"totalSize":4}}' )
]

{ #category : #running }
ZnEventToLogRecordControllerTest >> testLogsOfOutgoingPostRequest [

	zincEventToLogRecordAdapter
		logOutgoingRequests: true;
		startUpListeners.

	self
		runMemoryLoggerDuring: [
			self withServerDo: [ :server |
				| client |

				server onRequestRespond: [ :request |
					( ZnResponse ok: ( ZnEntity textCRLF: 'Hi you too!' ) )
						setConnectionClose;
						yourself
					].
				client := ZnClient new.
				client post: server localUrl contents: 'Hi there!'
				]
			]
		assertingLogRecordsMatch:
			#( '[DEBUG] Outgoing HTTP request sent {"summary":"2024-02-09 18:14:30 095 726586 Request Written a ZnRequest(GET /) 0ms","durationInMilliseconds":0,"request":{"method":"GET","uri":"http://localhost:35059/"},"processId":726586,"eventId":95}'
			   '[DEBUG] Outgoing HTTP request responded {"summary":"2024-02-09 18:14:30 102 726586 GET / 200 4B 2ms","durationInMilliseconds":2,"request":{"method":"GET","uri":"http://localhost:35059/"},"processId":726586,"eventId":102,"response":{"code":200,"totalSize":4}}' )
]

{ #category : #enumerating }
ZnEventToLogRecordControllerTest >> withServerDo: block [
	ZnServer withOSAssignedPortDo: block
]
