Class {
	#name : #PortAvailabilityCheckerTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-SUnit-Model-Tests'
}

{ #category : #'tests - support' }
PortAvailabilityCheckerTest >> openSocketOn: aPortNumber during: aBlock [

	| socket |

	socket := ZnNetworkingUtils serverSocketOn: aPortNumber.
	aBlock ensure: [ socket destroy ]
]

{ #category : #tests }
PortAvailabilityCheckerTest >> testIsAvailable [

	| checker wasEvaluated |

	wasEvaluated := false.
	checker := PortAvailabilityChecker on: self freeListeningTCPPort.
	checker checkIfAvailableDo: [ wasEvaluated := true ] ifNot: [ self fail ].
	self assert: wasEvaluated
]

{ #category : #tests }
PortAvailabilityCheckerTest >> testIsNotAvailable [

	| port |

	port := self freeListeningTCPPort.
	self openSocketOn: port during: [ 
		| checker |
		checker := PortAvailabilityChecker on: port.
		checker checkIfAvailableDo: [ self fail ]
			ifNot: [ :reason | 
			self assert: reason equals: ( 'Port <1p> is not available' expandMacrosWith: port ) ]
		]
]

{ #category : #tests }
PortAvailabilityCheckerTest >> testPriviledgePortCantBeUsed [

	self
		should: [ PortAvailabilityChecker on: 80 ]
		raise: InstanceCreationFailed
		withMessageText:
			'Privileged port must be avoided. Please choose a port number greater than 1024. See https://www.w3.org/Daemon/User/Installation/PrivilegedPorts.html'
]
