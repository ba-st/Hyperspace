"
I represent an HTTPClientError.

The HTTP 401 Unauthorized client error response status code indicates that a request was not
successful because it lacks valid authentication credentials for the requested resource.
This status code is sent with an HTTP WWW-Authenticate response header that contains information
on the authentication scheme the server expects the client to include to make the request successfully.

A 401 Unauthorized is similar to the 403 Forbidden response, except that a 403 is returned when a request
contains valid credentials, but the client does not have permissions to perform a certain action.

Although the HTTP standard specifies `unauthorized`, semantically this response means `unauthenticated`.
That is, the client must authenticate itself to get the requested response.
"
Class {
	#name : 'HTTPUnauthorized',
	#superclass : 'HTTPClientError',
	#instVars : [
		'challenge',
		'errorCode'
	],
	#category : 'Hyperspace-Model-Exceptions',
	#package : 'Hyperspace-Model',
	#tag : 'Exceptions'
}

{ #category : 'instance creation' }
HTTPUnauthorized class >> messageText: aMessageText with: aChallenge [

  ^ ( self code: 401 )
      messageText: aMessageText;
      challenge: aChallenge;
      yourself
]

{ #category : 'signalling' }
HTTPUnauthorized class >> signal: messageText becauseTokenIsInvalidWith: challenge [
  "The access token provided is expired, revoked, malformed, or
  invalid for other reasons.  The resource SHOULD respond with
  the HTTP 401 (Unauthorized) status code.  The client MAY
  request a new access token and retry the protected resource
  request."

  ^ ( self messageText: messageText with: challenge )
      errorCode: 'invalid_token';
      signal
]

{ #category : 'signalling' }
HTTPUnauthorized class >> signal: messageText with: challenge [

  ^ ( self messageText: messageText with: challenge ) signal
]

{ #category : 'accessing' }
HTTPUnauthorized >> challenge [

  ^ challenge
]

{ #category : 'accessing' }
HTTPUnauthorized >> challenge: aChallenge [

  challenge := aChallenge
]

{ #category : 'accessing' }
HTTPUnauthorized >> errorCode [

  ^ errorCode
]

{ #category : 'accessing' }
HTTPUnauthorized >> errorCode: anErrorCode [

  errorCode := anErrorCode
]

{ #category : 'initialization' }
HTTPUnauthorized >> initialize [

  super initialize.
  self challenge: ''
]
