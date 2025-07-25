"
A CURIE is a compact syntax for URIs.

Normative Reference:
- https://www.w3.org/TR/curie/
"
Class {
	#name : 'CURIE',
	#superclass : 'AbstractCURIE',
	#instVars : [
		'prefix',
		'relativeReference'
	],
	#category : 'Hyperspace-Model-IETF',
	#package : 'Hyperspace-Model',
	#tag : 'IETF'
}

{ #category : 'instance creation' }
CURIE class >> fromString: string [

  | segments |
  segments := $: split: string.
  AssertionChecker
    enforce: [ segments size = 2 ]
    because: [ 'Cannot create a CURIE from "<1s>"' expandMacrosWith: string ]
    raising: InstanceCreationFailed.
  ^ self prefixedBy: segments first referencing: segments second asUrl
]

{ #category : 'instance creation' }
CURIE class >> prefixedBy: aPrefix referencing: aRelativeUrl [

  AssertionChecker
    check: [ :asserter |
        asserter
          enforce: [ aRelativeUrl isRelative ]
          because: [ '<1p> must be a relative reference' expandMacrosWith: aRelativeUrl ];
          enforce: [ aPrefix notEmpty ] because: 'A CURIE prefix cannot be empty'
      ]
    configuredBy: [ :checker | checker raising: InstanceCreationFailed ].

  ^ self new initializePrefixedBy: aPrefix referencing: aRelativeUrl
]

{ #category : 'comparing' }
CURIE >> = object [

  ^ self equalityChecker
      compare: #prefix;
      compare: #relativeReference;
      checkAgainst: object
]

{ #category : 'converting' }
CURIE >> asSafeCURIE [

  ^ SafeCURIE from: self
]

{ #category : 'comparing' }
CURIE >> hash [

  ^ self equalityHashCombinator combineHashOf: prefix with: relativeReference
]

{ #category : 'initialization' }
CURIE >> initializePrefixedBy: aPrefix referencing: aRelativeUrl [

  prefix := aPrefix.
  relativeReference := aRelativeUrl
]

{ #category : 'accessing' }
CURIE >> prefix [

  ^ prefix
]

{ #category : 'printing' }
CURIE >> printOn: stream [

  stream
    nextPutAll: prefix;
    nextPut: $:.
  relativeReference hasPath then: [
      relativeReference segments
        do: [ :segment | relativeReference encodePath: segment on: stream ]
        separatedBy: [ stream nextPut: $/ ]
    ].
  relativeReference hasQuery then: [ relativeReference printQueryOn: stream ].
  relativeReference hasFragment then: [
      stream nextPut: $#.
      relativeReference encodeFragment: relativeReference fragment on: stream
    ]
]

{ #category : 'accessing' }
CURIE >> relativeReference [

  ^ relativeReference
]
