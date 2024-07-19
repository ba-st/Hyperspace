Class {
	#name : 'ZnEventToLogRecordAdapterTest',
	#superclass : 'TestCase',
	#instVars : [
		'loggingAsserter',
		'zincEventToLogRecordAdapter'
	],
	#category : 'Hyperspace-Model-Tests-Zinc',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Zinc'
}

{ #category : 'private' }
ZnEventToLogRecordAdapterTest >> addTimestampRegexTo: aLogEntryCollection [

  ^ aLogEntryCollection collect: [ :regexExpression |
        '\d{4}-\d{2}-\d{2}T\d{2}\:\d{2}\:\d{2}(\.\d+)?(\+|-)(\d+\:\d+) <1s>' expandMacrosWith:
          regexExpression
      ]
]

{ #category : 'private' }
ZnEventToLogRecordAdapterTest >> runMemoryLoggerDuring: aBlock assertingLogRecordsMatchRegexes: expectedLogEntries [

  | expectedLogEntriesWithTimestamp |

  expectedLogEntriesWithTimestamp := self addTimestampRegexTo: expectedLogEntries.

  loggingAsserter
    runMemoryLoggerDuring: aBlock;
    assertLogRecordsMatchUsing: expectedLogEntriesWithTimestamp
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> setUp [

	super setUp.
	loggingAsserter := LoggingAsserter on: self.
	zincEventToLogRecordAdapter := ZnEventToLogRecordAdapter new
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> tearDown [

	zincEventToLogRecordAdapter stopListeners.
	loggingAsserter stopLoggers.

	super tearDown
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> testLogsOfIncomingGetRequest [

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
         '\[DEBUG\] Incoming HTTP request received \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Read a\s{0,1}ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
         '\[DEBUG\] Incoming HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Handled a\s{0,1}ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}'
         '\[DEBUG\] Server closed connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}' )
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> testLogsOfIncomingPostRequest [

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
			   '\[DEBUG\] Incoming HTTP request received \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Read a\s{0,1}ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Incoming HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Handled a\s{0,1}ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}'
			   '\[DEBUG\] Server closed connection \{"remoteAddress"\:"127.0.0.1","processId"\:(\d+),"eventId"\:(\d+)\}' )
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> testLogsOfOutgoingGetRequest [

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
			#( '\[DEBUG\] Outgoing HTTP request sent \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Written a\s{0,1}ZnRequest\(GET /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Outgoing HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? GET / 200 (\d+)B (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"GET","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}' )
]

{ #category : 'running' }
ZnEventToLogRecordAdapterTest >> testLogsOfOutgoingPostRequest [

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
			#( '\[DEBUG\] Outgoing HTTP request sent \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? Request Written a\s{0,1}ZnRequest\(POST /\) (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+)\}'
			   '\[DEBUG\] Outgoing HTTP request responded \{"summary"\:"\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2} ((\d+) (\d+))? POST / 200 (\d+)B (\d+)ms","durationInMilliseconds"\:(\d+),"request"\:\{"method"\:"POST","uri"\:"http\://localhost\:(\d+)/"\},"processId"\:(\d+),"eventId"\:(\d+),"response"\:\{"code"\:200,"totalSize"\:(\d+)\}\}' )
]

{ #category : 'enumerating' }
ZnEventToLogRecordAdapterTest >> withServerDo: block [

	ZnServer withOSAssignedPortDo: block
]
