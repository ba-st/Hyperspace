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
HTTPForbiddenTest >> testAdditionalData [

  | error readData |

  self deny: ( HTTPForbidden code: 403 ) hasAdditionalData.

  error := HTTPForbidden messageText: 'Missing permissions' with: 'Bearer realm="api"'.
  error
    errorCode: 'insufficient_scope';
    requiredPermissions: #( 'admin' 'delete:data' ).
  readData := OrderedCollection new.
  error additionalDataKeysAndValuesDo: [ :key :value | readData add: key -> value ].

  self
    assert: error hasAdditionalData;
    assert: readData asArray
    equals: {( 'errorCode' -> 'insufficient_scope' ).
      ( 'requiredPermissions' -> #( 'admin' 'delete:data' ) )}
]

{ #category : 'tests' }
HTTPForbiddenTest >> testAdditionalDataOverridingTheOwnState [

  | error readData |

  error := HTTPForbidden messageText: 'Missing permissions' with: 'Bearer realm="api"'.
  error
    errorCode: 'insufficient_scope';
    additionalDataAt: 'errorCode' put: 'custom_code'.
  readData := OrderedCollection new.
  error additionalDataKeysAndValuesDo: [ :key :value | readData add: key -> value ].

  self
    assert: readData asArray equals: {( 'errorCode' -> 'custom_code' )};
    assert: error errorCode equals: 'insufficient_scope'
]

{ #category : 'tests' }
HTTPForbiddenTest >> testSignaling [

  self
    should: [ HTTPForbidden signal: 'Missing permissions' with: 'Basic realm="site"' ]
    raise: HTTPForbidden
    withExceptionDo: [ :signal |
        self
          assert: signal code equals: 403;
          assert: signal messageText equals: 'Missing permissions';
          assert: signal printString equals: 'HTTPForbidden[403]: Missing permissions';
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
          becauseScopeIsInsufficientFor: #( 'admin' 'delete:data' )
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
            self assert: permissions equals: #( 'admin' 'delete:data' ) ]
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
