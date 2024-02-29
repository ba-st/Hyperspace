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
ZnEventToLogRecordControllerTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatchRegexes: expectedLogEntries [

	loggingAsserter
		runMemoryLoggerDuring: aBlock;
		assertLogRecordsMatchRegexes: expectedLogEntries
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
		assertingLogRecordsMatchRegexes:
			#( '\[DEBUG\] Server accepted connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Incoming HTTP request received \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Read a ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Incoming HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Handled a ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}'
			   '\[DEBUG\] Server closed connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}' )
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
	assertingLogRecordsMatchRegexes:
			#( '\[DEBUG\] Server accepted connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Incoming HTTP request received \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Read a ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Incoming HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Handled a ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}'
			   '\[DEBUG\] Server closed connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}' )
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
		assertingLogRecordsMatchRegexes:
			#( '\[DEBUG\] Outgoing HTTP request sent \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Written a ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Outgoing HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) GET / 200 (\d+)B (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}' )
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
		assertingLogRecordsMatchRegexes:
			#( '\[DEBUG\] Outgoing HTTP request sent \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) Request Written a ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Outgoing HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} (\d+) (\d+) POST / 200 (\d+)B (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}' )
]

{ #category : #enumerating }
ZnEventToLogRecordControllerTest >> withServerDo: block [
	ZnServer withOSAssignedPortDo: block
]
