"
I represent an HTTPClientError.

The HTTP 403 Forbidden client error response status code indicates that the server understood the
request but refused to process it. This status is similar to 401, except that for 403 Forbidden
responses, authenticating or re-authenticating makes no difference. The request failure is tied
to application logic, such as insufficient permissions to a resource or action.

Clients that receive a 403 response should expect that repeating the request without modification
will fail with the same error.
"
Class {
	#name : 'HTTPForbidden',
	#superclass : 'HTTPClientError',
	#instVars : [
		'challenge',
		'errorCode',
		'requiredPermissions'
	],
	#category : 'Hyperspace-Model-Exceptions',
	#package : 'Hyperspace-Model',
	#tag : 'Exceptions'
}

{ #category : 'instance creation' }
HTTPForbidden class >> messageText: aMessageText with: aChallenge [

  ^ ( self code: 403 )
      messageText: aMessageText;
      challenge: aChallenge;
      yourself
]

{ #category : 'signalling' }
HTTPForbidden class >> signal [

  ^ ( self code: 403 ) signal
]

{ #category : 'signalling' }
HTTPForbidden class >> signal: messageText becauseScopeIsInsufficientFor: permissions with: challenge [
  "The request requires higher privileges than provided by the
   access token.  The resource server SHOULD respond with the HTTP
   403 (Forbidden) status code and MAY include the `scope`
   attribute with the scope necessary to access the protected
   resource."

  ^ ( self messageText: messageText with: challenge )
      errorCode: 'insufficient_scope';
      requiredPermissions: permissions;
      signal
]

{ #category : 'signalling' }
HTTPForbidden class >> signal: messageText becauseScopeIsInsufficientWith: challenge [

  ^ self signal: messageText becauseScopeIsInsufficientFor: #(  ) with: challenge
]

{ #category : 'signalling' }
HTTPForbidden class >> signal: messageText with: challenge [

  ^ ( self messageText: messageText with: challenge ) signal
]

{ #category : 'accessing' }
HTTPForbidden >> challenge [

  ^ challenge
]

{ #category : 'accessing' }
HTTPForbidden >> challenge: aChallenge [

  challenge := aChallenge
]

{ #category : 'accessing' }
HTTPForbidden >> errorCode [

  ^ errorCode
]

{ #category : 'accessing' }
HTTPForbidden >> errorCode: anErrorCode [

  errorCode := anErrorCode
]

{ #category : 'initialization' }
HTTPForbidden >> initialize [

  super initialize.
  self
    messageText: 'Forbidden';
    challenge: '';
    requiredPermissions: #(  )
]

{ #category : 'accessing' }
HTTPForbidden >> requiredPermissions: scopeCollection [

  requiredPermissions := scopeCollection
]

{ #category : 'enumerating' }
HTTPForbidden >> withRequiredPermissionsDo: aBlock [

  requiredPermissions ifNotEmpty: aBlock
]
