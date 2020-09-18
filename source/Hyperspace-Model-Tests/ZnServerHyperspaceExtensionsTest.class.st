Class {
	#name : #ZnServerHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnServerHyperspaceExtensionsTest >> testSetLogLevelAtLeastTo [

	| server |

	server := ZnSingleThreadedServer on: 666.
	server loggingOff.
	self assert: server logLevel equals: 0.

	server setLogLevelAtLeastTo: 2.
	self assert: server logLevel equals: 2.

	server setLogLevelAtLeastTo: 1.
	self assert: server logLevel equals: 2
]
