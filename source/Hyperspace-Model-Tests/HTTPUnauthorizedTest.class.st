"
A HTTPUnauthorizedTest is a test class for testing the behavior of HTTPUnauthorized
"
Class {
	#name : 'HTTPUnauthorizedTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-Exceptions',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Exceptions'
}

{ #category : 'tests' }
HTTPUnauthorizedTest >> testAdditionalData [

  | error readData |
  self deny: ( HTTPUnauthorized code: 401 ) hasAdditionalData.

  error := HTTPUnauthorized messageText: 'The access token expired' with: 'Bearer realm="api"'.
  error errorCode: 'invalid_token'.
  readData := OrderedCollection new.
  error additionalDataKeysAndValuesDo: [ :key :value | readData add: key -> value ].

  self
    assert: error hasAdditionalData;
    assert: readData asArray equals: { 'errorCode' -> 'invalid_token' }
]

{ #category : 'tests' }
HTTPUnauthorizedTest >> testSignaling [

  self
    should: [ HTTPUnauthorized signal: 'Unauthorized' with: 'Basic realm="site"' ]
    raise: HTTPUnauthorized
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 401;
          assert: signal messageText equals: 'Unauthorized';
          assert: signal printString equals: 'HTTPUnauthorized[401]: Unauthorized';
          assert: signal challenge equals: 'Basic realm="site"'
      ]
]

{ #category : 'tests' }
HTTPUnauthorizedTest >> testSignalingInvalidToken [

  self
    should: [
        HTTPUnauthorized
          signal: 'The access token expired'
          becauseTokenIsInvalidWith: 'Bearer realm="api"' ]
    raise: HTTPUnauthorized
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 401;
          assert: signal messageText equals: 'The access token expired';
          assert: signal printString equals: 'HTTPUnauthorized[401]: The access token expired';
          assert: signal challenge equals: 'Bearer realm="api"';
          assert: signal errorCode equals: 'invalid_token'
      ]
]
