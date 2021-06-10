"
I represent a Link Header. 
The Link entity-header field provides a means for serialising one or more links in HTTP headers.  
It is semantically equivalent to the <LINK> element in HTML, as well as the atom:link feed-level element in Atom.

References

	https://tools.ietf.org/html/rfc5988#page-6
"
Class {
	#name : #ZnLink,
	#superclass : #Object,
	#instVars : [
		'parameters',
		'url'
	],
	#category : #'Hyperspace-Model-IETF'
}

{ #category : #'private - preconditions' }
ZnLink class >> assertFormatIsValidAndParseParameters: linkParts [

	| parameters |

	AssertionCheckerBuilder new
		raising: InstanceCreationFailed;
		failFast;
		checking: [ :asserter | 
			asserter
				enforce: [ linkParts notEmpty ]
				because: 'Missing "<".'
				onSuccess: [ :successAsserter | 
					successAsserter
						enforce: [ linkParts first beginsWith: '<' ] because: 'Missing "<".';
						enforce: [ linkParts first endsWith: '>' ] because: 'Missing ">".'.

					parameters := linkParts withoutFirst collect: [ :candidate | candidate substrings: '=' ].
					parameters
						do:
							[ :parameter | successAsserter enforce: [ parameter size = 2 ] because: 'Invalid parameter format.' ]
					]
			];
		buildAndCheck.
	^ parameters
]

{ #category : #'instance creation' }
ZnLink class >> fromString: aString [

	| linkParts urlCandidate parameters url link |

	"A string representing a link is something like <https://google.com/>;rel=search.
	So we need to split on ; and then parse the first element as a URL and the others
	as parameters splitted by = "

	linkParts := aString substrings: ';'.
	parameters := self assertFormatIsValidAndParseParameters: linkParts.

	urlCandidate := linkParts first.
	"Trim < > tags"
	url := ( urlCandidate copyFrom: 2 to: urlCandidate size - 1 ) asUrl.

	link := self to: url.

	parameters do: [ :parameter | link parameterAt: parameter first put: parameter last ].

	^ link
]

{ #category : #'instance creation' }
ZnLink class >> to: aUrl [

	^ self new initializeTo: aUrl
]

{ #category : #comparing }
ZnLink >> = anObject [

	^ self equalityChecker
		compare: #url;
		compareWith: [ :myself :other | myself hasSameParametersAs: other ];
		checkAgainst: anObject
]

{ #category : #converting }
ZnLink >> asByteArray [

	^ self printString asByteArray
]

{ #category : #converting }
ZnLink >> asWebLink [

	^ self
]

{ #category : #testing }
ZnLink >> hasParameters [

	^ parameters notNil and: [ parameters notEmpty ]
]

{ #category : #testing }
ZnLink >> hasSameParametersAs: aLink [

	^ self hasParameters = aLink hasParameters
		and: [self parameters size = aLink parameters size
			and: [self parameters associations allSatisfy: [:each |
				aLink parameters includesAssociation: each]]]
]

{ #category : #comparing }
ZnLink >> hash [

	^ self hasParameters
		then: [ self equalityHashCombinator combineHashOf: self url with: self parameters ]
		otherwise: [ self url hash ]
]

{ #category : #'initialize - release' }
ZnLink >> initializeTo: aUrl [

	url := aUrl
]

{ #category : #parameters }
ZnLink >> parameterAt: key [

	^ self parameterAt: key ifAbsent: [ KeyNotFound signalFor: key ]
]

{ #category : #parameters }
ZnLink >> parameterAt: key ifAbsent: block [

	parameters ifNil: [ ^ block value ].
	^ self parameters at: key ifAbsent: block
]

{ #category : #parameters }
ZnLink >> parameterAt: aKey put: aValue [

	self parameters at: aKey put: aValue
]

{ #category : #parameters }
ZnLink >> parameters [

	parameters ifNil: [ parameters := SmallDictionary new ].
	^ parameters
]

{ #category : #copying }
ZnLink >> postCopy [

	super postCopy.
	parameters := parameters copy
]

{ #category : #printing }
ZnLink >> printOn: stream [

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

{ #category : #accessing }
ZnLink >> rel [
	
	^self parameterAt: 'rel'
]

{ #category : #parameters }
ZnLink >> rel: aRelation [

	self parameterAt: 'rel' put: aRelation
]

{ #category : #parameters }
ZnLink >> removeParameter: key [

	parameters ifNil: [ ^ self ].
	^ self parameters removeKey: key ifAbsent: [ nil ]
]

{ #category : #accessing }
ZnLink >> url [

	^ url
]
