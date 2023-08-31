"
I'm here to help to identify if some port is free or not, so we can start a server listening on it.
Whenever possible, it is best to let the OS provide us a free port. But if you need to constraint the port selection, I'm useful in detecting available ports.
"
Class {
	#name : #PortAvailabilityChecker,
	#superclass : #Object,
	#instVars : [
		'portNumberA'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Hyperspace-Model-Resilience'
}

{ #category : #'instance creation' }
PortAvailabilityChecker class >> new [

	uniqueInstance ifNil: [ uniqueInstance := super new ].
	^ uniqueInstance
]

{ #category : #conditional }
PortAvailabilityChecker >> if: portNumber isAvailableForTCP: aFoundBlock ifNot: aNotFoundBlock [

	^ ( self isAvailableForTCP: portNumber ) 
		ifTrue: aFoundBlock
		ifFalse: [ aNotFoundBlock cull: ( 'Port <1p> is not available' expandMacrosWith: portNumber ) ]
]

{ #category : #testing }
PortAvailabilityChecker >> isAvailableForTCP: portNumber [

	^ [ 
	  | socket |

	  socket := ZnNetworkingUtils default socketClass newTCP.
	  ZnNetworkingUtils default setServerSocketOptions: socket.
	  socket listenOn: portNumber.
	  [ 
	  socket isValid and: [ 
		  "If port is not available, Pharo gives you a random one" 
		  portNumber == socket localPort ]
	  ] ensure: [ socket destroy ]
	  ] on: NetworkError
		  do: [ :error | error return: false ]
]
