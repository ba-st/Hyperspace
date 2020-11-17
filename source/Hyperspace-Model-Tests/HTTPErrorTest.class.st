"
A HTTPErrorTest is a test class for testing the behavior of HTTPError
"
Class {
	#name : #HTTPErrorTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Exceptions'
}

{ #category : #tests }
HTTPErrorTest >> testHandlingHTTPClientError [

	self should: [ HTTPClientError notFound signal ] raise: HTTPError
]

{ #category : #tests }
HTTPErrorTest >> testHandlingHTTPServerError [

	self should: [ HTTPServerError internalServerError signal ] raise: HTTPError
]
