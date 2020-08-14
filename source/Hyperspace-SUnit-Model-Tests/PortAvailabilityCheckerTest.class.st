Class {
	#name : #PortAvailabilityCheckerTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-SUnit-Model-Tests'
}

{ #category : #'tests - support' }
PortAvailabilityCheckerTest >> openSocketOn: aPortNumber during: aBlock [

	| socket |

	[ socket := ZnNetworkingUtils serverSocketOn: 9999.
	aBlock value
	]
		ensure: [ socket close ]
]

{ #category : #tests }
PortAvailabilityCheckerTest >> testIsAvailable [

	| check |

	check := PortAvailabilityChecker on: 9999.
	check checkIfAvailableDo: [  ] ifNot: [ self fail ]
]

{ #category : #tests }
PortAvailabilityCheckerTest >> testIsNotAvailable [

	self
		openSocketOn: 9999
		during: [ | check |

			check := PortAvailabilityChecker on: 9999.
			check
				checkIfAvailableDo: [ self fail ]
				ifNot: [ :reason | self assert: reason equals: 'Port 9999 is not available' ]
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
