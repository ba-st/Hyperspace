"
I represent a web link.
The Link entity-header field provides a means for serialising one or more links in HTTP headers.  
It is semantically equivalent to the <LINK> element in HTML, as well as the atom:link feed-level element in Atom.

References

	https://tools.ietf.org/html/rfc5988#page-6
"
Class {
	#name : #WebLink,
	#superclass : #Object,
	#instVars : [
		'parameters',
		'url'
	],
	#category : #'Hyperspace-Model-IETF'
}

{ #category : #'private - preconditions' }
WebLink class >> assertLinkValueFormatIsValid: urlCandidate [

	AssertionCheckerBuilder new
		raising: InstanceCreationFailed;
		failFast;
		checking: [ :asserter | 
			asserter
				enforce: [ urlCandidate beginsWith: '<' ] because: 'Missing "<".';
				enforce: [ urlCandidate endsWith: '>' ] because: 'Missing ">".'
			];
		buildAndCheck
]

{ #category : #'instance creation' }
WebLink class >> fromString: aString [

	| stream linkValueCandidate link |

	stream := aString readStream.

	linkValueCandidate := stream upTo: $;.
	self assertLinkValueFormatIsValid: linkValueCandidate.
	link := self to: ( self trimTagsIn: linkValueCandidate ) asUrl.
	self parseParametersOn: stream configuredIn: link.
	^ link
]

{ #category : #'private - parsing' }
WebLink class >> parseParametersOn: stream configuredIn: link [

	[ stream atEnd ] whileFalse: [ 
		| parameterName parameterValue |

		parameterName := stream upTo: $=.
		AssertionChecker refuse: [ stream atEnd ]
			because: 'Invalid parameter format.'
			raising: InstanceCreationFailed.
		stream peek = $"
			then: [ 
				stream next.
				parameterValue := stream upTo: $".
				stream skipTo: $;
				]
			otherwise: [ parameterValue := stream upTo: $; ].
		link parameterAt: parameterName add: parameterValue
		]
]

{ #category : #'instance creation' }
WebLink class >> to: aUrl [

	^ self new initializeTo: aUrl
]

{ #category : #'private - parsing' }
WebLink class >> trimTagsIn: urlCandidate [

	^ urlCandidate copyFrom: 2 to: urlCandidate size - 1
]

{ #category : #comparing }
WebLink >> = anObject [

	^ self equalityChecker
		compare: #url;
		compareWith: [ :myself :other | myself hasTheSameParametersAs: other ];
		checkAgainst: anObject
]

{ #category : #configuring }
WebLink >> addLanguageHint: aLanguageTag [

	"The hreflang parameter, when present, is a hint indicating what the language
	of the result of dereferencing the link should be. Note that this is only a hint;
	for example, it does not override the Content-Language header of a HTTP response
	obtained by actually following the link. Multiple hreflang parameters on a single
	link-value indicate that multiple languages are available from the indicated resource."

	self parameterAt: 'hreflang' add: aLanguageTag asLanguageTag printString
]

{ #category : #converting }
WebLink >> asByteArray [

	^ self printString asByteArray
]

{ #category : #printing }
WebLink >> asString [

	^ self printString
]

{ #category : #converting }
WebLink >> asWebLink [

	^ self
]

{ #category : #private }
WebLink >> assertNotEmpty: aKey [

	AssertionChecker enforce: [ aKey notEmpty ]
		because: 'Invalid parameter format.'
		raising: InstanceCreationFailed
]

{ #category : #testing }
WebLink >> hasParameters [

	^ parameters notNil and: [ parameters notEmpty ]
]

{ #category : #private }
WebLink >> hasTheSameParametersAs: aLink [

	^ self hasParameters = aLink hasParameters
		and: [self parameters size = aLink parameters size
			and: [self parameters associations allSatisfy: [:each |
				aLink parameters includesAssociation: each]]]
]

{ #category : #comparing }
WebLink >> hash [

	^ self hasParameters
		then: [ self equalityHashCombinator combineHashOf: self url with: self parameters ]
		otherwise: [ self url hash ]
]

{ #category : #'initialize - release' }
WebLink >> initializeTo: aUrl [

	url := aUrl
]

{ #category : #'accessing - target parameters' }
WebLink >> languageHints [

	| value |

	value := self parameterAt: 'hreflang' ifAbsent: [ ^ #(  ) ].
	^ value isArray 
		ifTrue: [ value collect: #asLanguageTag ]
		ifFalse: [ Array with: value asLanguageTag ]
]

{ #category : #'accessing - target parameters' }
WebLink >> mediaQueryHint [

	^ self parameterAt: 'media'
]

{ #category : #configuring }
WebLink >> mediaQueryHint: aCssMediaQuery [

	"The media parameter, when present, is used to indicate intended
	destination medium or media for style information. Its value MUST be
   quoted if it contains a semicolon (;) or comma (,), and there
   MUST NOT be more than one media parameter in a link-value."

	self parameterAt: 'media' put: aCssMediaQuery asString
]

{ #category : #'accessing - target parameters' }
WebLink >> mediaTypeHint [

	^ ( self parameterAt: 'type' ) asMediaType
]

{ #category : #configuring }
WebLink >> mediaTypeHint: aMediaType [

	"The type parameter, when present, is a hint indicating what the media type of the
	result of dereferencing the link should be.  Note that this is only a hint; for
	example, it does not override the Content-Type header of a HTTP response obtained
	by actually following the link.
	There MUST NOT be more than one type parameter in a link-value."

	self parameterAt: 'type' put: aMediaType asMediaType printString
]

{ #category : #parameters }
WebLink >> parameterAt: key [

	^ self parameterAt: key ifAbsent: [ KeyNotFound signalFor: key ]
]

{ #category : #parameters }
WebLink >> parameterAt: aKey add: aValue [

	self assertNotEmpty: aKey.
	self parameters at: aKey add: ( self quoteValueWhenNeeded: aValue )
]

{ #category : #parameters }
WebLink >> parameterAt: key ifAbsent: block [

	parameters ifNil: [ ^ block value ].
	^ self parameters at: key ifAbsent: block
]

{ #category : #parameters }
WebLink >> parameterAt: aKey put: aString [

	self assertNotEmpty: aKey.
	self parameters at: aKey put: ( self quoteValueWhenNeeded: aString )
]

{ #category : #parameters }
WebLink >> parameters [

	parameters ifNil: [ parameters := MultiValueOrderedDictionary new ].
	^ parameters
]

{ #category : #copying }
WebLink >> postCopy [

	super postCopy.
	parameters := parameters copy
]

{ #category : #printing }
WebLink >> printOn: stream [

	stream
		nextPut: $<;
		print: url;
		nextPut: $>.
	parameters
		ifNotNil: [ parameters
				keysAndValuesDo: [ :key :value | 
					stream
						nextPut: $;;
						nextPutAll: key;
						nextPut: $=;
						nextPutAll: value ] ]
]

{ #category : #private }
WebLink >> quoteValueWhenNeeded: aString [

	"Values including ; or , needs to be quoted"

	self assertNotEmpty: aString.
	^ ((aString includes: $;) or: [ aString includes: $, ])
		  then: [ '"<1s>"' expandMacrosWith: aString ]
		  otherwise: [ aString ]
]

{ #category : #accessing }
WebLink >> relationType [

	^ self parameterAt: 'rel'
]

{ #category : #configuring }
WebLink >> relationType: aRelation [

	"The relation type of a link is conveyed in the rel parameter's
   value.  The rel parameter MUST NOT appear more than once in a given
   link-value; occurrences after the first MUST be ignored by parsers."

	self parameterAt: 'rel' put: aRelation
]

{ #category : #parameters }
WebLink >> removeParameter: key [

	parameters ifNil: [ ^ self ].
	^ self parameters removeKey: key ifAbsent: [ nil ]
]

{ #category : #'accessing - target parameters' }
WebLink >> title [

	^ self parameterAt: 'title'
]

{ #category : #configuring }
WebLink >> title: aString [

	"The title parameter, when present, is used to label the destination of a
	link such that it can be used as a human-readable identifier (e.g., a menu
	entry) in the language indicated by the Content-Language header (if present).
	The title parameter MUST NOT appear more than once in a given link-value;
	occurrences after the first MUST be ignored by parsers."

	self parameterAt: 'title' put: aString
]

{ #category : #configuring }
WebLink >> toCollection [

	"The target IRI points to a resource which represents the collection resource for the context IRI."

	self relationType: 'collection'
]

{ #category : #configuring }
WebLink >> toCopyright [

	"Refers to a copyright statement that applies to the link's context."

	self relationType: 'copyright'
]

{ #category : #configuring }
WebLink >> toEdit [

	"Refers to a resource that can be used to edit the link's context."

	self relationType: 'edit'
]

{ #category : #configuring }
WebLink >> toExternalSite [

	"Refers to a resource that is not part of the same site as the current context."

	self relationType: 'external'
]

{ #category : #configuring }
WebLink >> toFirst [

	"An IRI that refers to the furthest preceding resource in a series of resources."

	self relationType: 'first'
]

{ #category : #configuring }
WebLink >> toHelp [

	"Refers to context-sensitive help."

	self relationType: 'help'
]

{ #category : #configuring }
WebLink >> toIcon [

	"Refers to an icon representing the link's context."

	self relationType: 'icon'
]

{ #category : #configuring }
WebLink >> toItem [

	"The target IRI points to a resource that is a member of the collection represented by the context IRI."

	self relationType: 'item'
]

{ #category : #configuring }
WebLink >> toLast [

	"An IRI that refers to the furthest following resource in a series of resources."

	self relationType: 'last'
]

{ #category : #configuring }
WebLink >> toLatestVersion [

	"Points to a resource containing the latest (e.g., current) version of the context."

	self relationType: 'latest-version'
]

{ #category : #configuring }
WebLink >> toLicense [

	"Refers to a license associated with this context."

	self relationType: 'license'
]

{ #category : #configuring }
WebLink >> toMyself [

	"Conveys an identifier for the link's context. "

	self relationType: 'self'
]

{ #category : #configuring }
WebLink >> toNext [

	"Indicates that the link's context is a part of a series, and that the next in the series is the link target."

	self relationType: 'next'
]

{ #category : #configuring }
WebLink >> toParent [

	"Refers to a parent document in a hierarchy of documents. "

	self relationType: 'up'
]

{ #category : #configuring }
WebLink >> toPayment [

	"Indicates a resource where payment is accepted."

	self relationType: 'payment'
]

{ #category : #configuring }
WebLink >> toPredecessorVersion [

	"Points to a resource containing the predecessor version in the version history. "

	self relationType: 'predecessor-version'
]

{ #category : #configuring }
WebLink >> toPrevious [

	"Indicates that the link's context is a part of a series, and that the previous in the series is the link target. "

	self relationType: 'prev'
]

{ #category : #configuring }
WebLink >> toProfile [

	"Identifying that a resource representation conforms to a certain profile,
	without affecting the non-profile semantics of the resource representation."

	self relationType: 'profile'
]

{ #category : #configuring }
WebLink >> toSearch [

	"Refers to a resource that can be used to search through the link's context and related resources."

	self relationType: 'search'
]

{ #category : #configuring }
WebLink >> toSuccessorVersion [

	"Points to a resource containing the successor version in the version history. "

	self relationType: 'successor-version'
]

{ #category : #configuring }
WebLink >> toTermsOfService [

	"Refers to the terms of service associated with the link's context."

	self relationType: 'terms-of-service'
]

{ #category : #configuring }
WebLink >> toVersionHistory [

	"Points to a resource containing the version history for the context. "

	self relationType: 'version-history'
]

{ #category : #configuring }
WebLink >> toWorkingCopy [

	"Points to a working copy for this resource."

	self relationType: 'working-copy'
]

{ #category : #configuring }
WebLink >> toWorkingCopyOrigin [

	"Points to the versioned resource from which this working copy was obtained."

	self relationType: 'working-copy-of'
]

{ #category : #accessing }
WebLink >> url [

	^ url
]
