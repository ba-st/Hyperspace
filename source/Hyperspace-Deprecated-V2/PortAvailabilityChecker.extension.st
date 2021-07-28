Extension { #name : #PortAvailabilityChecker }

{ #category : #'*Hyperspace-Deprecated-V2' }
PortAvailabilityChecker >> checkIfAvailableDo: ifAvailableBlock ifNot: ifNotBlock [

	self deprecated: 'Use ifTcpPort:isAvailableDo:ifNot:'
		transformWith: '`@receiver checkIfAvailableDo: `@ifAvailableBlock ifNot: `@ifNotBlock'
			->
			'`@receiver if: (self halt: ''Put the port number here'') isAvailableForTCP: `@ifAvailableBlock ifNot: `@ifNotBlock'.

	^ self if: self halt isAvailableForTCP: ifAvailableBlock ifNot: ifNotBlock
]

{ #category : #'*Hyperspace-Deprecated-V2' }
PortAvailabilityChecker class >> on: aPortNumber [

	self deprecated: 'Use #if:isAvailableForTCP::ifNot:'
		transformWith:
			'(PortAvailabilityChecker on: `@port) checkIfAvailableDo: `@ifAvailableBlock ifNot: `@ifNotBlock'
			->
			'PortAvailabilityChecker new if: `@port isAvailableForTCP: `@ifAvailableBlock ifNot: `@ifNotBlock'.

	^ self new
]
