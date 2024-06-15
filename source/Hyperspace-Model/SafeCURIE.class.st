"
A SafeCURIE is a compact syntax for URIs; used in contexts where a URI can also be used, to disambiguate.

Normative Reference:

•	https://www.w3.org/TR/curie/
"
Class {
	#name : 'SafeCURIE',
	#superclass : 'AbstractCURIE',
	#instVars : [
		'curie'
	],
	#category : 'Hyperspace-Model',
	#package : 'Hyperspace-Model'
}

{ #category : 'instance creation' }
SafeCURIE class >> from: aCURIE [

  ^ self new initializeFrom: aCURIE
]

{ #category : 'instance creation' }
SafeCURIE class >> fromString: string [

  AssertionChecker
    check: [ :asserter |
        asserter
          enforce: [ string size > 2 ]
          because: [ 'Cannot create a Safe CURIE from "<1s>"' expandMacrosWith: string ]
          onSuccess: [ :successAsserter |
              successAsserter
                enforce: [ string first = $[ ] because: [ 'Missing "["' ];
                enforce: [ string last = $] ] because: [ 'Missing "]"' ]
            ]
      ]
    configuredBy: [ :checker | checker raising: InstanceCreationFailed ].

  ^ self from: ( CURIE fromString: ( string copyFrom: 2 to: string size - 1 ) )
]

{ #category : 'instance creation' }
SafeCURIE class >> prefixedBy: prefix referencing: relativeUrl [

  ^ self from: ( CURIE prefixedBy: prefix referencing: relativeUrl )
]

{ #category : 'comparing' }
SafeCURIE >> = object [

  ^ self equalityChecker
      compare: #prefix;
      compare: #relativeReference;
      checkAgainst: object
]

{ #category : 'converting' }
SafeCURIE >> asSafeCURIE [

  ^ self
]

{ #category : 'comparing' }
SafeCURIE >> hash [

  ^ self equalityHashCombinator combineHashOf: self prefix with: self relativeReference
]

{ #category : 'initialization' }
SafeCURIE >> initializeFrom: aCURIE [

  curie := aCURIE
]

{ #category : 'accessing' }
SafeCURIE >> prefix [

  ^ curie prefix
]

{ #category : 'printing' }
SafeCURIE >> printOn: stream [

  stream nextPut: $[.
  curie printOn: stream.
  stream nextPut: $]
]

{ #category : 'accessing' }
SafeCURIE >> relativeReference [

  ^ curie relativeReference
]
