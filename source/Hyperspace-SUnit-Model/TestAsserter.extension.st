Extension { #name : #TestAsserter }

{ #category : #'*Hyperspace-SUnit-Model' }
TestAsserter >> assertUrl: aStringOrUrl equals: anotherStringOrUrl [

	self assert: aStringOrUrl asUrl equals: anotherStringOrUrl asUrl
]

{ #category : #'*Hyperspace-SUnit-Model' }
TestAsserter >> freeListeningTCPPort [

	| socket |

	socket := ZnNetworkingUtils serverSocketOn: 0.
	^ [ 
	  self assert: socket isValid.
	  socket localPort
	  ] ensure: [ socket destroy ]
]
