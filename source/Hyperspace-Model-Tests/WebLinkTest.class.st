"
I'm a test case for WebLink
"
Class {
	#name : #WebLinkTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-IETF'
}

{ #category : #private }
WebLinkTest >> checkCollectionLinkRelationsOn: link [

	self
		assert: link toItem relationType equals: 'item';
		assert: link toCollection relationType equals: 'collection'
]

{ #category : #private }
WebLinkTest >> checkLegalLinkRelationsOn: link [

	self
		assert: link toLicense relationType equals: 'license';
		assert: link toTermsOfService relationType equals: 'terms-of-service';
		assert: link toCopyright relationType equals: 'copyright'
]

{ #category : #private }
WebLinkTest >> checkNavigationLinkRelationsOn: link [

	self
		assert: link toNext relationType equals: 'next';
		assert: link toPrevious relationType equals: 'prev';
		assert: link toFirst relationType equals: 'first';
		assert: link toLast relationType equals: 'last';
		assert: link toParent relationType equals: 'up'
]

{ #category : #private }
WebLinkTest >> checkVersionNavigationLinkRelationsOn: link [

	"Version Navigation Link Relations. See RFC 5829"

	self
		assert: link toLatestVersion relationType equals: 'latest-version';
		assert: link toPredecessorVersion relationType equals: 'predecessor-version';
		assert: link toSuccessorVersion relationType equals: 'successor-version';
		assert: link toVersionHistory relationType equals: 'version-history';
		assert: link toWorkingCopy relationType equals: 'working-copy';
		assert: link toWorkingCopyOrigin relationType equals: 'working-copy-of'
]

{ #category : #private }
WebLinkTest >> googleUrl [

	^ 'https://google.com' asUrl
]

{ #category : #tests }
WebLinkTest >> testAccessing [

	| link |

	link := self googleUrl asWebLink
		        relationType: 'search';
		        title: 'Google Search';
		        addLanguageHint: 'en';
		        mediaTypeHint: 'text/html';
		        mediaQueryHint: 'screen';
		        yourself.

	self
		assertUrl: link url equals: self googleUrl;
		assert: link relationType equals: 'search';
		assert: link title equals: 'Google Search';
		withTheOnlyOneIn: link languageHints
		do: [ :language | self assert: language equals: 'en' asLanguageTag ];
		assert: link mediaTypeHint equals: 'text/html' asMediaType;
		assert: link mediaQueryHint equals: 'screen';
		assert: link printString
		equals:
			'<https://google.com/>;rel=search;title=Google Search;hreflang=en;type=text/html;media=screen'
]

{ #category : #tests }
WebLinkTest >> testAsByteArray [

	self
		assert: self googleUrl asWebLink asByteArray equals: '<https://google.com/>' asByteArray;
		assert: ( self googleUrl asWebLink relationType: 'search' ) asByteArray
		equals: '<https://google.com/>;rel=search' asByteArray
]

{ #category : #tests }
WebLinkTest >> testComparing [

	| googleLink other |

	googleLink := self googleUrl asWebLink.
	other := self googleUrl asWebLink.

	self
		assert: googleLink equals: other;
		assert: googleLink hash equals: other hash.

	other relationType: 'next'.

	self deny: googleLink equals: other
]

{ #category : #tests }
WebLinkTest >> testComplexMediaTypeHint [

	| link mediaType |

	mediaType := 'application/vnd.stargate.pet+json' asMediaType.
	mediaType version: '2.0.0'.

	link := self googleUrl asWebLink
		        mediaTypeHint: mediaType;
		        yourself.

	self assert: link printString
		equals: '<https://google.com/>;type="application/vnd.stargate.pet+json;version=2.0.0"'
]

{ #category : #tests }
WebLinkTest >> testCopying [

	| googleLink copy |

	googleLink := self googleUrl asWebLink.
	copy := googleLink copy.

	self
		deny: googleLink hasParameters;
		deny: copy hasParameters.

	copy relationType: 'next'.
	self
		deny: googleLink hasParameters;
		assert: copy hasParameters
]

{ #category : #tests }
WebLinkTest >> testFromString [

	| link parsedLink |

	link := self googleUrl asWebLink
		        relationType: 'search';
		        parameterAt: 'lang' put: 'en-US';
		        yourself.

	parsedLink := WebLink fromString: link printString.

	self assert: link equals: parsedLink
]

{ #category : #tests }
WebLinkTest >> testLanguageHints [

	| link |

	link := self googleUrl asWebLink addLanguageHint: 'en-US'.
	self assert: link printString equals: '<https://google.com/>;hreflang=en-US'.

	link addLanguageHint: 'es-AR'.
	self assert: link printString equals: '<https://google.com/>;hreflang=en-US;hreflang=es-AR'
]

{ #category : #tests }
WebLinkTest >> testMediaQueryHint [

	| link |

	link := self googleUrl asWebLink mediaQueryHint: 'screen'.
	self assert: link printString equals: '<https://google.com/>;media=screen'.

	link mediaQueryHint: 'screen, print'.
	self assert: link printString equals: '<https://google.com/>;media="screen, print"'
]

{ #category : #tests }
WebLinkTest >> testMediaTypeHint [

	| link |

	link := self googleUrl asWebLink
		        mediaTypeHint: 'application/json' asMediaType;
		        yourself.
	self assert: link printString equals: '<https://google.com/>;type=application/json'
]

{ #category : #tests }
WebLinkTest >> testParameters [

	| link |

	link := self googleUrl asWebLink.
	self should: [ link parameterAt: 'foo' ] raise: KeyNotFound.
	self assert: ( link parameterAt: 'foo' ifAbsent: [ #none ] ) equals: #none.
	link parameterAt: 'foo' put: '1'.
	self assert: ( link parameterAt: 'foo' ) equals: '1'.
	self assert: ( link parameterAt: 'foo' ifAbsent: [ #none ] ) equals: '1'.
	link removeParameter: 'foo'.
	link removeParameter: 'bar'.
	self should: [ link parameterAt: 'foo' ] raise: KeyNotFound.
	self assert: ( link parameterAt: 'foo' ifAbsent: [ #none ] ) equals: #none
]

{ #category : #tests }
WebLinkTest >> testParsingComplexLink [

	| link |

	link := WebLink to: 'https://example.com' asUrl.
	link
		toExternalSite;
		addLanguageHint: 'en-US';
		addLanguageHint: 'es-AR';
		addLanguageHint: 'es-ES';
		title: 'Examples';
		mediaTypeHint: ( 'application/json' asMediaType version: '1.1.5' );
		mediaQueryHint: 'screen, print'.

	self assert: link printString asWebLink equals: link
]

{ #category : #tests }
WebLinkTest >> testParsingErrors [

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
WebLinkTest >> testPrinting [

	self
		assert: self googleUrl asWebLink printString equals: '<https://google.com/>';
		assert: ( self googleUrl asWebLink relationType: 'search' ) printString
		equals: '<https://google.com/>;rel=search'
]

{ #category : #tests }
WebLinkTest >> testWellKnownRelationTypes [

	| link |

	link := self googleUrl asWebLink.

	self
		assert: link toMyself relationType equals: 'self';
		assert: link toSearch relationType equals: 'search';
		assert: link toProfile relationType equals: 'profile';
		assert: link toHelp relationType equals: 'help';
		assert: link toEdit relationType equals: 'edit';
		assert: link toIcon relationType equals: 'icon';
		assert: link toPayment relationType equals: 'payment';
		assert: link toExternalSite relationType equals: 'external';
		checkNavigationLinkRelationsOn: link;
		checkLegalLinkRelationsOn: link;
		checkCollectionLinkRelationsOn: link;
		checkVersionNavigationLinkRelationsOn: link
]
