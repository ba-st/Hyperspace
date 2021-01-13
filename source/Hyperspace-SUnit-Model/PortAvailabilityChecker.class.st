Class {
	#name : #PortAvailabilityChecker,
	#superclass : #Object,
	#instVars : [
		'portNumber'
	],
	#category : #'Hyperspace-SUnit-Model'
}

{ #category : #'instance creation' }
PortAvailabilityChecker class >> on: aPortNumber [

	AssertionChecker
		enforce: [ aPortNumber > 1024 ]
		because:
			'Privileged port must be avoided. Please choose a port number greater than 1024. See https://www.w3.org/Daemon/User/Installation/PrivilegedPorts.html'
		raising: InstanceCreationFailed.

	^ self new initializeOn: aPortNumber
]

{ #category : #checking }
PortAvailabilityChecker >> checkIfAvailableDo: ifAvailableBlock ifNot: ifNotBlock [

	[ 
	| socketPortNumber socket |

	"If port is not available, Pharo gives you a random one"
	socket := ZnNetworkingUtils serverSocketOn: portNumber.
	socketPortNumber := [ socket localPort ] ensure: [ socket destroy ].

	socketPortNumber == portNumber ifTrue: ifAvailableBlock
		ifFalse: [ ifNotBlock cull: self reason ]
	] on: Error
		do: [ :signal | ifNotBlock cull: self reason ]
]

{ #category : #initialization }
PortAvailabilityChecker >> initializeOn: aPortNumber [ 
	
	portNumber := aPortNumber 
]

{ #category : #accessing }
PortAvailabilityChecker >> reason [

	^ 'Port <1p> is not available' expandMacrosWith: portNumber
]
