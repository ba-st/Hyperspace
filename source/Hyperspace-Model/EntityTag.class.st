"
An entity-tag is an opaque validator for differentiating between multiple representations of the same resource, regardless of whether those multiple representations are due to resource state changes over time, content negotiation resulting in multiple representations being valid at the same time, or both.  An entity-tag consists of an opaque quoted string, possibly prefixed by a weakness indicator.

The ETag HTTP response header is an identifier for a specific version of a resource. It allows caches to be more efficient, and saves bandwidth, as a web server does not need to send a full response if the content has not changed. On the other side, if the content has changed, etags are useful to help prevent simultaneous updates of a resource from overwriting each other (""mid-air collisions"").

If the resource at a given URL changes, a new Etag value must be generated. Etags are therefore similar to fingerprints and might also be used for tracking purposes by some servers. A comparison of them allows to quickly determine whether two representations of a resource are the same, but they might also be set to persist indefinitely by a tracking server.

Two entity tags can be compared in two ways. #matchesStrongly: answers true only when neither of them is weak and their opaque values are equal, and is the comparison If-Match asks for. #matchesWeakly: ignores the weakness indicator, and is the one If-None-Match asks for. #= is value equality, the same as #matchesWeakly:.

The field values of If-Match and If-None-Match are lists of entity tags, or *. See EntityTagList.

References:
- [RFC 9110 §8.8.3](https://www.rfc-editor.org/rfc/rfc9110#section-8.8.3)
"
Class {
	#name : 'EntityTag',
	#superclass : 'Object',
	#instVars : [
		'value',
		'weaknessIndicator'
	],
	#category : 'Hyperspace-Model-IETF',
	#package : 'Hyperspace-Model',
	#tag : 'IETF'
}

{ #category : 'instance creation' }
EntityTag class >> fromString: string [

  ^ [ self with: ( self opaqueValueOf: string ) ]
      unless: ( string beginsWith: 'W/' )
      inWhichCase: [ self weakWith: ( self opaqueValueOf: ( string withoutFirst: 2 ) ) ]
]

{ #category : 'private - testing' }
EntityTag class >> isEnclosedInDoubleQuotes: anOpaqueTag [

  ^ anOpaqueTag size >= 2 and: [ anOpaqueTag first = $" and: [ anOpaqueTag last = $" ] ]
]

{ #category : 'private - testing' }
EntityTag class >> isValidForEntityTag: aCharacter [
  "etagc = %x21 / %x23-7E / obs-text. obs-text is not accepted."

  ^ ( aCharacter between: $! and: $~ ) and: [ aCharacter ~= $" ]
]

{ #category : 'private - instance creation' }
EntityTag class >> opaqueValueOf: anOpaqueTag [

  | unquotedTag |
  AssertionChecker
    enforce: [ self isEnclosedInDoubleQuotes: anOpaqueTag ]
    because: 'Entity tags must be enclosed in double quotes.' localized
    raising: InstanceCreationFailed.
  unquotedTag := anOpaqueTag copyFrom: 2 to: anOpaqueTag size - 1.
  AssertionChecker
    enforce: [ unquotedTag allSatisfy: [ :character | self isValidForEntityTag: character ] ]
    because: 'Entity tags only allow visible ASCII characters other than double quotes.' localized
    raising: InstanceCreationFailed.
  ^ unquotedTag
]

{ #category : 'instance creation' }
EntityTag class >> weakWith: anETagValue [

  ^ self with: anETagValue prefixedBy: 'W/'
]

{ #category : 'instance creation' }
EntityTag class >> with: anETagValue [

  ^ self with: anETagValue prefixedBy: ''
]

{ #category : 'private - instance creation' }
EntityTag class >> with: anETagValue prefixedBy: aWeaknessIndicator [

  ^ self new initializeWith: anETagValue prefixedBy: aWeaknessIndicator
]

{ #category : 'comparing' }
EntityTag >> = anObject [

	^ self equalityChecker
		compare: #value;
		checkAgainst: anObject
]

{ #category : 'converting' }
EntityTag >> asEntityTag [

	^ self
]

{ #category : 'printing' }
EntityTag >> asString [

	^self printString
]

{ #category : 'comparing' }
EntityTag >> hash [

	^ value hash
]

{ #category : 'initialization' }
EntityTag >> initializeWith: anETagValue prefixedBy: aWeaknessIndicator [

  value := anETagValue.
  weaknessIndicator := aWeaknessIndicator
]

{ #category : 'testing' }
EntityTag >> isStrong [

  ^ self isWeak not
]

{ #category : 'testing' }
EntityTag >> isWeak [

  ^ weaknessIndicator notEmpty
]

{ #category : 'comparing' }
EntityTag >> matchesStrongly: anEntityTag [

  ^ self isStrong and: [ anEntityTag isStrong and: [ self matchesWeakly: anEntityTag ] ]
]

{ #category : 'comparing' }
EntityTag >> matchesWeakly: anEntityTag [

  ^ value = anEntityTag value
]

{ #category : 'printing' }
EntityTag >> printOn: aStream [

  aStream
    nextPutAll: weaknessIndicator;
    nextPut: $";
    nextPutAll: value;
    nextPut: $"
]

{ #category : 'evaluating' }
EntityTag >> value [

	^ value
]
