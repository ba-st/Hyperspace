"
I'm a test case for ZnLink
"
Class {
	#name : #ZnLinkTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-IETF'
}

{ #category : #support }
ZnLinkTest >> googleUrl [

	^ 'https://google.com' asZnUrl
]

{ #category : #tests }
ZnLinkTest >> testAccessing [

	| link |

	link := ( ZnLink to: self googleUrl )
		rel: 'search';
		yourself.

	self
		assertUrl: link url equals: self googleUrl;
		assert: link rel equals: 'search'
]

{ #category : #tests }
ZnLinkTest >> testAsByteArray [

	self
		assert: (ZnLink to: self googleUrl) asByteArray
		equals: '<https://google.com/>' asByteArray.
	self
		assert:
			((ZnLink to: self googleUrl)
				rel: 'search';
				yourself) asByteArray
		equals: '<https://google.com/>;rel=search' asByteArray
]

{ #category : #tests }
ZnLinkTest >> testComparing [

	| googleLink other |

	googleLink := ZnLink to: self googleUrl.
	other := ZnLink to: self googleUrl.

	self
		assert: googleLink equals: other;
		assert: googleLink hash equals: other hash.

	other rel: 'next'.

	self deny: googleLink equals: other
]

{ #category : #tests }
ZnLinkTest >> testCopying [

	| googleLink copy |

	googleLink := ZnLink to: self googleUrl.
	copy := googleLink copy.

	self
		deny: googleLink hasParameters;
		deny: copy hasParameters.

	copy rel: 'next'.
	self
		deny: googleLink hasParameters;
		assert: copy hasParameters
]

{ #category : #tests }
ZnLinkTest >> testFromString [

	| link parsedLink |

	link := ( ZnLink to: self googleUrl )
		rel: 'search';
		parameterAt: 'lang' put: 'en-US';
		yourself.

	parsedLink := ZnLink fromString: link printString.

	self assert: link equals: parsedLink
]

{ #category : #tests }
ZnLinkTest >> testParameters [

	| link |

	link := ZnLink to: self googleUrl.
	self should: [ link parameterAt: 'foo' ] raise: KeyNotFound.
	self assert: (link parameterAt: 'foo' ifAbsent: [ #none ]) equals: #none.
	link parameterAt: 'foo' put: '1'.
	self assert: (link parameterAt: 'foo') equals: '1'.
	self assert: (link parameterAt: 'foo' ifAbsent: [ #none ]) equals: '1'.
	link removeParameter: 'foo'.
	link removeParameter: 'bar'.
	self should: [ link parameterAt: 'foo' ] raise: KeyNotFound.
	self assert: (link parameterAt: 'foo' ifAbsent: [ #none ]) equals: #none
]

{ #category : #tests }
ZnLinkTest >> testParsingErrors [

	self
		should: [ 'https://example.com>' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Missing "<".';
		should: [ '<https://example.com' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Missing ">".';
		should: [ '' asWebLink ] raise: InstanceCreationFailed withMessageText: 'Missing "<".';
		should: [ '<http://foo:8080/foo%%bar>' asWebLink ]
			raise: ZnCharacterEncodingError
			withMessageText: 'hex digit expected';
		should: [ '<https://google.com>;rel' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Invalid parameter format.';
		should: [ '<https://google.com>;=search' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Invalid parameter format.';
		should: [ '<https://google.com>;rel=' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Invalid parameter format.';
		should: [ '<https://google.com>;=' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Invalid parameter format.';
		should: [ '<https://google.com>;rel=search;=' asWebLink ]
			raise: InstanceCreationFailed
			withMessageText: 'Invalid parameter format.'
]

{ #category : #tests }
ZnLinkTest >> testPrinting [

	self assert: ( ZnLink to: self googleUrl ) printString equals: '<https://google.com/>'.

	self
		assert:
			( ( ZnLink to: self googleUrl )
				rel: 'search';
				yourself ) printString
		equals: '<https://google.com/>;rel=search'
]
