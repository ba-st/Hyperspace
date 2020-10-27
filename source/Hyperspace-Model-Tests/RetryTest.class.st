"
A RetryTest is a test class for testing the behavior of Retry
"
Class {
	#name : #RetryTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Resilience'
}

{ #category : #private }
RetryTest >> expectedError [

	^ HTTPClientError badRequest
]

{ #category : #private }
RetryTest >> shouldRaiseExpectedError: aBlock [

	self should: aBlock raise: self expectedError withMessageText: 'Too bad'
]

{ #category : #private }
RetryTest >> signalExpectedError [

	^ self expectedError signal: 'Too bad'
]

{ #category : #'tests - configuring retry count' }
RetryTest >> testCannotUseNegativeRetries [

	self should: [ Retry value: [  ] configuredBy: [ :retry | retry upTo: -1 ] ]
		raise: AssertionFailed
		withMessageText: 'The maximum number of retries must be strictly positive.'
]

{ #category : #'tests - configuring retry count' }
RetryTest >> testCannotUseZeroRetries [

	self should: [ Retry value: [  ] configuredBy: [ :retry | retry upTo: 0 ] ]
		raise: AssertionFailed
		withMessageText: 'The maximum number of retries must be strictly positive.'
]

{ #category : #'tests - configuring retry count' }
RetryTest >> testConfiguringRetryCountWhenRetriesNotNeeded [

	| count |

	count := 0.

	Retry value: [ count := count + 1 ] configuredBy: [ :retry | retry upTo: 1 ].

	self assert: count equals: 1
]

{ #category : #'tests - configuring wait time' }
RetryTest >> testEvery [

	| count runtime |

	count := 0.

	runtime := Time millisecondsToRun: [ 
		           self shouldRaiseExpectedError: [ 
			           Retry
				           value: [ 
					           count := count + 1.
					           self signalExpectedError
					           ]
				           configuredBy: [ :retry | 
					           retry
						           onException;
						           every: 100 milliSeconds
					           ]
			           ]
		           ].

	self
		assert: count equals: 3;
		assert: runtime milliSeconds > 200 milliSeconds
]

{ #category : #'tests - configuring wait time' }
RetryTest >> testExponentialBackoff [

	| count runtime |

	count := 0.

	runtime := Time millisecondsToRun: [ 
		           self shouldRaiseExpectedError: [ 
			           Retry
				           value: [ 
					           count := count + 1.
					           self signalExpectedError
					           ]
				           configuredBy: [ :retry | 
					           retry
						           onException;
						           backoffExponentiallyWithTimeSlot: 50 milliSeconds using: [ :integer | integer ]
					           ]
			           ]
		           ].

	self
		assert: count equals: 3;
		assert: runtime milliSeconds > ( 50 + 100 ) milliSeconds
]

{ #category : #'tests - configuring wait time' }
RetryTest >> testExponentialBackoffWithDefaultRandomGenerator [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self signalExpectedError
				]
			configuredBy: [ :retry | 
				retry
					onException;
					backoffExponentiallyWithTimeSlot: 50 milliSeconds
				]
		].

	self assert: count equals: 3
]

{ #category : #tests }
RetryTest >> testHooksOnRetries [

	| count exceptionsDrivingRetries resultsDrivingRetries |

	count := 0.
	exceptionsDrivingRetries := OrderedCollection new.
	resultsDrivingRetries := OrderedCollection new.

	Retry
		value: [ 
			count := count + 1.
			count even then: [ 
				self expectedError
					tag: count;
					signal
				].
			count
			]
		configuredBy: [ :retry | 
			retry
				when: [ :result | result < 4 ] evaluating: [ :attemptNumber :result | 
					self assert: attemptNumber equals: result.
					resultsDrivingRetries add: result
					];
				on: self expectedError evaluating: [ :attemptNumber :exception | 
					self assert: attemptNumber equals: exception tag.
					exceptionsDrivingRetries add: exception
					];
				upTo: 10
			].

	self
		assert: count equals: 5;
		assertCollection: ( exceptionsDrivingRetries collect: #tag ) hasSameElements: #( 2 4 );
		assertCollection: resultsDrivingRetries hasSameElements: #( 1 3 )
]

{ #category : #'tests - configuring condition' }
RetryTest >> testHooksOnRetriesDueToCondition [

	| count resultsDrivingRetries |

	count := 0.
	resultsDrivingRetries := OrderedCollection new.

	Retry
		value: [ :attemptNumber | 
			count := attemptNumber.
			count
			]
		configuredBy: [ :retry | 
			retry
				when: [ :result | result < 4 ] evaluating: [ :attemptNumber :result | 
					self assert: attemptNumber equals: result.
					resultsDrivingRetries add: result
					];
				upTo: 10
			].

	self
		assert: count equals: 4;
		assertCollection: resultsDrivingRetries hasSameElements: #( 1 2 3 )
]

{ #category : #'tests - configuring errors' }
RetryTest >> testHooksOnRetriesDueToExpectedErrorRaised [

	| count exceptionsDrivingRetries |

	count := 0.
	exceptionsDrivingRetries := OrderedCollection new.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self expectedError
					tag: count;
					signal: 'Too bad'
				]
			configuredBy: [ :retry | 
				retry
					on: self expectedError evaluating: [ :attemptNumber :exception | 
						self assert: attemptNumber equals: exception tag.
						exceptionsDrivingRetries add: exception
						];
					upTo: 1
				]
		].

	self
		assert: count equals: 2;
		withTheOnlyOneIn: exceptionsDrivingRetries do: [ :exception | 
			self
				assert: exception tag equals: 1;
				assert: ( self expectedError handles: exception )
			]
]

{ #category : #'tests - configuring errors' }
RetryTest >> testIgnoreWhenExpectedErrorIsRaised [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self signalExpectedError
				]
			configuredBy: [ :retry | 
				retry
					on: Error;
					ignore: self unexpectedError;
					upTo: 1
				]
		].

	self assert: count equals: 2
]

{ #category : #'tests - configuring errors' }
RetryTest >> testIgnoreWhenUnexpectedErrorIsRaised [

	| count |

	count := 0.

	self
		should: [ 
			Retry
				value: [ 
					count := count + 1.
					self unexpectedError signal
					]
				configuredBy: [ :retry | 
					retry
						on: Error;
						ignore: self unexpectedError;
						upTo: 1
					]
			]
		raise: self unexpectedError.

	self assert: count equals: 1
]

{ #category : #tests }
RetryTest >> testMaximumNumberOfAttemptsIsSurpassed [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry value: [ 
			count := count + 1.
			self signalExpectedError
			]
		].

	self assert: count equals: Retry defaultMaximumNumberOfAttempts
]

{ #category : #tests }
RetryTest >> testNoNeedToRetry [

	| count |

	count := 0.

	Retry value: [ count := count + 1 ].

	self assert: count equals: 1
]

{ #category : #'tests - configuring errors' }
RetryTest >> testOnWhenExpectedErrorIsRaised [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self signalExpectedError
				]
			configuredBy: [ :retry | 
				retry
					on: self expectedError;
					upTo: 1
				]
		].

	self assert: count equals: 2
]

{ #category : #'tests - configuring errors' }
RetryTest >> testOnWhenExpectedErrorIsRaisedAndSeveralErrorsHandled [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self signalExpectedError
				]
			configuredBy: [ :retry | 
				retry
					on: AssertionFailed , self expectedError;
					upTo: 1
				]
		].

	self assert: count equals: 2.

	self
		should: [ 
			Retry
				value: [ 
					count := count + 1.
					AssertionFailed signal
					]
				configuredBy: [ :retry | 
					retry
						on: AssertionFailed , self expectedError;
						upTo: 1
					]
			]
		raise: AssertionFailed.

	self assert: count equals: 4
]

{ #category : #'tests - configuring errors' }
RetryTest >> testOnWhenUnexpectedErrorIsRaised [

	| count |

	count := 0.

	self
		should: [ 
			Retry
				value: [ 
					count := count + 1.
					self unexpectedError signal
					]
				configuredBy: [ :retry | 
					retry
						on: self expectedError;
						upTo: 1
					]
			]
		raise: self unexpectedError.

	self assert: count equals: 1
]

{ #category : #tests }
RetryTest >> testRetryOnce [

	| count |

	count := 0.

	Retry value: [ 
		count := count + 1.
		count = 1 then: [ Exception signal ]
		].

	self assert: count equals: 2
]

{ #category : #tests }
RetryTest >> testReturnValue [

	| count result |

	count := 0.

	result := Retry value: [ 
		          count := count + 1.
		          count = 1 then: [ Exception signal ].
		          count
		          ].

	self assert: result equals: 2
]

{ #category : #tests }
RetryTest >> testReturnValueWhenNotRetrying [

	| count result |

	count := 0.

	result := Retry value: [ 
		          count := count + 1.
		          count
		          ].

	self assert: result equals: 1
]

{ #category : #'tests - configuring retry count' }
RetryTest >> testUpTo [

	| count |

	count := 0.

	self shouldRaiseExpectedError: [ 
		Retry
			value: [ 
				count := count + 1.
				self signalExpectedError
				]
			configuredBy: [ :retry | 
				retry
					onException;
					upTo: 1
				]
		].

	self assert: count equals: 2
]

{ #category : #'tests - configuring wait time' }
RetryTest >> testUpToTimesEvery [

	| count runtime |

	count := 0.

	runtime := Time millisecondsToRun: [ 
		           self shouldRaiseExpectedError: [ 
			           Retry
				           value: [ 
					           count := count + 1.
					           self signalExpectedError
					           ]
				           configuredBy: [ :retry | 
					           retry
						           onException;
						           upTo: 3 timesEvery: 100 milliSeconds
					           ]
			           ]
		           ].

	self
		assert: count equals: 4;
		assert: runtime milliSeconds > 300 milliSeconds
]

{ #category : #'tests - configuring condition' }
RetryTest >> testWhen [

	| count |

	count := 0.

	Retry
		value: [ 
			count := count + 1.
			count
			]
		configuredBy: [ :retry | 
			retry
				when: [ :result | result < 4 ];
				upTo: 10
			].

	self assert: count equals: 4
]

{ #category : #'tests - configuring condition' }
RetryTest >> testWhenConditionNotUsed [

	| count |

	count := 0.

	Retry
		value: [ 
			count := count + 1.
			4
			]
		configuredBy: [ :retry | 
			retry
				when: [ :result | result < 4 ];
				upTo: 10
			].

	self assert: count equals: 1
]

{ #category : #private }
RetryTest >> unexpectedError [

	^ HTTPServerError
]
