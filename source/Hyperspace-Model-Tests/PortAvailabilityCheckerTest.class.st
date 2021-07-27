Class {
	#name : #PortAvailabilityCheckerTest,
	#superclass : #TestCase,
	#instVars : [
		'checker'
	],
	#category : #'Hyperspace-Model-Tests-Resilience'
}

{ #category : #'private - support' }
PortAvailabilityCheckerTest >> openSocketOn: aPortNumber during: aBlock [

	| socket |

	socket := ZnNetworkingUtils serverSocketOn: aPortNumber.
	aBlock ensure: [ socket destroy ]
]

{ #category : #initialization }
PortAvailabilityCheckerTest >> setUp [

	super setUp.
	checker := PortAvailabilityChecker new
]

{ #category : #'tests - TCP' }
PortAvailabilityCheckerTest >> testIfIsAvailableForTCPIfNot [

	| wasEvaluated |

	wasEvaluated := false.
	checker if: self freeListeningTCPPort
		isAvailableForTCP: [ wasEvaluated := true ]
		ifNot: [ self fail ].
	self assert: wasEvaluated
]

{ #category : #'tests - TCP' }
PortAvailabilityCheckerTest >> testIfIsAvailableForTCPIfNotWhenNotAvailable [

	| port |

	port := self freeListeningTCPPort.
	self openSocketOn: port during: [ 
		checker if: port
			isAvailableForTCP: [ self fail ]
			ifNot: [ :reason | 
			self assert: reason equals: ( 'Port <1p> is not available' expandMacrosWith: port ) ]
		]
]

{ #category : #'tests - TCP' }
PortAvailabilityCheckerTest >> testIsAvailableForTCP [

	self assert: ( checker isAvailableForTCP: self freeListeningTCPPort )
]

{ #category : #'tests - TCP' }
PortAvailabilityCheckerTest >> testIsNotAvailableForTCP [

	| port |

	port := self freeListeningTCPPort.
	self openSocketOn: port during: [ self deny: ( checker isAvailableForTCP: port ) ]
]
