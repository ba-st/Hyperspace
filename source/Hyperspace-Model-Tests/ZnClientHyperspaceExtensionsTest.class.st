Class {
	#name : #ZnClientHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #private }
ZnClientHyperspaceExtensionsTest >> handleRequest: request [

	self
		assert: request method equals: 'QUERY';
		assertUrl: request url equals: 'hello'.
	^ ZnResponse ok: (ZnEntity text: 'hello')
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testQuery [

	| server port |

	port := self freeListeningTCPPort.
	server := ZnServer on: port.
	server delegate: self.
	server start.

	[
	| client |

	client := ZnClient new.
	client url: ('http://localhost:<1p>/hello' expandMacrosWith: port).
	self
		assert: client query equals: 'hello';
		assert: client response isSuccess
	] ensure: [ server stop ]
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testResetRequest [

	| client |

	client := ZnClient new.
	client url: 'http://example.com'.
	self assertUrl: client request url equals: 'http://example.com'.

	client resetRequest.
	self assert: client request url isNil
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testSetAccept [

	| client |

	client := ZnClient new.

	self assert: client request accept equals: '*/*'.
	client setAccept: ZnMimeType applicationPdf.
	self assert: client request accept equals: ZnMimeType applicationPdf asString
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testSetIfMatchTo [

	| client |

	client := ZnClient new.

	self should: [ client request headers at: #'If-Match' ] raise: KeyNotFound.
	client setIfMatchTo: ( EntityTag with: '12345' ).
	self assert: ( client request headers at: #'If-Match' ) equals: '"12345"'
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testSetIfNoneMatchTo [

	| client |

	client := ZnClient new.

	self should: [ client request headers at: #'If-None-Match' ] raise: KeyNotFound.
	client setIfNoneMatchTo: ( EntityTag with: '12345' ).
	self assert: ( client request headers at: #'If-None-Match' ) equals: '"12345"'
]

{ #category : #tests }
ZnClientHyperspaceExtensionsTest >> testSetLogLevelAtLeastTo [

	| client |

	client := ZnClient new.
	client loggingOff.
	self assert: client logLevel equals: 0.

	client setLogLevelAtLeastTo: 2.
	self assert: client logLevel equals: 2.

	client setLogLevelAtLeastTo: 1.
	self assert: client logLevel equals: 2
]
