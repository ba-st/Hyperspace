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
          signalBecauseTokenIsInvalid: 'The access token expired'
          with: 'Bearer realm="api"' ]
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
