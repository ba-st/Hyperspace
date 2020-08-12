Extension { #name : #TestAsserter }

{ #category : #'*Hyperspace-SUnit-Model' }
TestAsserter >> assertUrl: aStringOrUrl equals: anotherStringOrUrl [

	self assert: aStringOrUrl asZnUrl equals: anotherStringOrUrl asZnUrl
]
