"
A HTTPForbiddenTest is a test class for testing the behavior of HTTPForbidden
"
Class {
	#name : 'HTTPForbiddenTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-Exceptions',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Exceptions'
}

{ #category : 'tests' }
HTTPForbiddenTest >> testSignaling [

  self
    should: [ HTTPForbidden signal: 'Forbidden' with: 'Basic realm="site"' ]
    raise: HTTPForbidden
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 403;
          assert: signal messageText equals: 'Forbidden';
          assert: signal printString equals: 'HTTPForbidden[403]: Forbidden';
          assert: signal challenge equals: 'Basic realm="site"'
      ]
]

{ #category : 'tests' }
HTTPForbiddenTest >> testSignalingInsufficientScope [

  self
    should: [
        HTTPForbidden
          signal: 'Missing permissions on the access token'
          becauseScopeIsInsufficientWith: 'Bearer realm="api"'
      ]
    raise: HTTPForbidden
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 403;
          assert: signal messageText equals: 'Missing permissions on the access token';
          assert: signal printString
          equals: 'HTTPForbidden[403]: Missing permissions on the access token';
          assert: signal challenge equals: 'Bearer realm="api"';
          assert: signal errorCode equals: 'insufficient_scope'.
        signal withRequiredPermissionsDo: [ :scopes | self fail ]
      ]
]

{ #category : 'tests' }
HTTPForbiddenTest >> testSignalingInsufficientScopeWithDetails [

  self
    should: [
        HTTPForbidden
          signal: 'Deleting users requires the "admin" role.'
          becauseScopeIsInsufficientFor: #( 'admin' 'read:data' )
          with: 'Bearer realm="api"'
      ]
    raise: HTTPForbidden
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 403;
          assert: signal messageText equals: 'Deleting users requires the "admin" role.';
          assert: signal printString
          equals: 'HTTPForbidden[403]: Deleting users requires the "admin" role.';
          assert: signal challenge equals: 'Bearer realm="api"';
          assert: signal errorCode equals: 'insufficient_scope'.
        signal withRequiredPermissionsDo: [ :permissions |
            self assert: permissions equals: #( 'admin' 'read:data' ) ]
      ]
]

{ #category : 'tests' }
HTTPForbiddenTest >> testSignalingWithDefaultMessage [

  self should: [ HTTPForbidden signal ] raise: HTTPForbidden withExceptionDo: [ :signal |
      self
        assert: signal code equals: 403;
        assert: signal messageText equals: 'Forbidden';
        assert: signal printString equals: 'HTTPForbidden[403]: Forbidden'
    ]
]
