"
I'm the field value of the If-Match and If-None-Match headers: a list of entity tags, or *, which matches any current representation of the resource.

I can be created from the field value, or from the collection of field values of a repeated field, which means the same as the comma-separated list of them:

```
EntityTagList fromString: 'W/""a"", ""b""'.
EntityTagList fromStrings: #( 'W/""a""' '""b""' ).
EntityTagList fromString: '*'.
```

#matchesStrongly: and #matchesWeakly: answer whether any of my entity tags matches the one given, using the comparison of the same name in EntityTag. If-Match asks for the strong comparison, and If-None-Match for the weak one. When I'm *, both answer true, but they can only be sent when there is a current representation to compare: when there is none, If-Match: * fails and If-None-Match: * succeeds, and that is the caller's decision.

References:
- [RFC 9110 §13.1.1](https://www.rfc-editor.org/rfc/rfc9110#section-13.1.1)
- [RFC 9110 §13.1.2](https://www.rfc-editor.org/rfc/rfc9110#section-13.1.2)
"
Class {
	#name : 'EntityTagList',
	#superclass : 'Object',
	#instVars : [
		'entityTags'
	],
	#category : 'Hyperspace-Model-IETF',
	#package : 'Hyperspace-Model',
	#tag : 'IETF'
}

{ #category : 'private - instance creation' }
EntityTagList class >> basicWithAll: anEntityTagCollection [

  ^ self new initializeWithAll: anEntityTagCollection
]

{ #category : 'instance creation' }
EntityTagList class >> fromString: string [

  | fieldValue |
  fieldValue := string trimBoth.
  ^ fieldValue = '*'
      ifTrue: [ self wildcard ]
      ifFalse: [ self withAll: ( self listElementsIn: fieldValue ) ]
]

{ #category : 'instance creation' }
EntityTagList class >> fromStrings: aStringCollection [

  ^ self fromString: ( ',' join: aStringCollection )
]

{ #category : 'private - parsing' }
EntityTagList class >> listElementsIn: aFieldValue [
  "Splits on the commas outside of double quotes, since an opaque tag can hold a comma.
  Empty list elements are ignored, as RFC 9110 §5.6.1 asks recipients to do."

  | elements element isInsideDoubleQuotes |
  elements := OrderedCollection new.
  element := String new writeStream.
  isInsideDoubleQuotes := false.
  aFieldValue do: [ :character |
      ( character = $, and: [ isInsideDoubleQuotes not ] )
        ifTrue: [
            element contents trimBoth ifNotEmpty: [ :contents | elements add: contents ].
            element := String new writeStream
          ]
        ifFalse: [
            character = $" ifTrue: [ isInsideDoubleQuotes := isInsideDoubleQuotes not ].
            element nextPut: character
          ]
    ].
  element contents trimBoth ifNotEmpty: [ :contents | elements add: contents ].
  ^ elements
]

{ #category : 'instance creation' }
EntityTagList class >> wildcard [

  ^ self basicWithAll: #(  )
]

{ #category : 'instance creation' }
EntityTagList class >> withAll: anEntityTagCollection [

  AssertionChecker
    refuse: [ anEntityTagCollection isEmpty ]
    because: 'An entity tag list must hold at least one entity tag.'
    raising: InstanceCreationFailed.
  ^ self basicWithAll: ( anEntityTagCollection collect: [ :entityTag | entityTag asEntityTag ] )
]

{ #category : 'converting' }
EntityTagList >> asString [

  ^ self printString
]

{ #category : 'initialization' }
EntityTagList >> initializeWithAll: anEntityTagCollection [

  entityTags := anEntityTagCollection asArray
]

{ #category : 'testing' }
EntityTagList >> isWildcard [

  ^ entityTags isEmpty
]

{ #category : 'testing' }
EntityTagList >> matchesStrongly: anEntityTag [

  ^ self isWildcard or: [
        entityTags anySatisfy: [ :entityTag | entityTag matchesStrongly: anEntityTag ] ]
]

{ #category : 'testing' }
EntityTagList >> matchesWeakly: anEntityTag [

  ^ self isWildcard or: [
        entityTags anySatisfy: [ :entityTag | entityTag matchesWeakly: anEntityTag ] ]
]

{ #category : 'printing' }
EntityTagList >> printOn: stream [

  self isWildcard then: [ ^ stream nextPut: $* ].
  entityTags do: [ :entityTag | entityTag printOn: stream ] separatedBy: [
      stream
        nextPut: $,;
        space
    ]
]
