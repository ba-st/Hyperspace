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
		'entityTags',
		'isWildcard'
	],
	#category : 'Hyperspace-Model-IETF',
	#package : 'Hyperspace-Model',
	#tag : 'IETF'
}

{ #category : 'instance creation' }
EntityTagList class >> fromString: aString [

  | fieldValue |
  fieldValue := aString trimBoth.
  ^ fieldValue = '*'
      ifTrue: [ self wildcard ]
      ifFalse: [ self withAll: ( self listElementsIn: fieldValue ) ]
]

{ #category : 'instance creation' }
EntityTagList class >> fromStrings: aStringCollection [

  | fieldValue |
  fieldValue := WriteStream on: String new.
  aStringCollection
    do: [ :string | fieldValue nextPutAll: string ]
    separatedBy: [ fieldValue nextPut: $, ].
  ^ self fromString: fieldValue contents
]

{ #category : 'private - parsing' }
EntityTagList class >> listElementsIn: aFieldValue [
  "Splits on the commas outside of double quotes, since an opaque tag can hold a comma.
  Empty list elements are ignored, as RFC 9110 §5.6.1 asks recipients to do."

  | elements element isQuoted |
  elements := OrderedCollection new.
  element := WriteStream on: String new.
  isQuoted := false.
  aFieldValue do: [ :character |
      ( character = $, and: [ isQuoted not ] )
        ifTrue: [
            elements add: element contents.
            element := WriteStream on: String new
          ]
        ifFalse: [
            character = $" ifTrue: [ isQuoted := isQuoted not ].
            element nextPut: character
          ]
    ].
  elements add: element contents.
  ^ ( elements collect: [ :each | each trimBoth ] ) reject: [ :each | each isEmpty ]
]

{ #category : 'instance creation' }
EntityTagList class >> wildcard [

  ^ self new initializeWildcard
]

{ #category : 'instance creation' }
EntityTagList class >> withAll: anEntityTagCollection [

  AssertionChecker
    refuse: [ anEntityTagCollection isEmpty ]
    because: 'An entity tag list must hold at least one entity tag.'
    raising: InstanceCreationFailed.
  ^ self new initializeWithAll:
      ( anEntityTagCollection collect: [ :entityTag | entityTag asEntityTag ] )
]

{ #category : 'printing' }
EntityTagList >> asString [

  ^ self printString
]

{ #category : 'initialization' }
EntityTagList >> initializeWildcard [

  entityTags := #(  ).
  isWildcard := true
]

{ #category : 'initialization' }
EntityTagList >> initializeWithAll: anEntityTagCollection [

  entityTags := anEntityTagCollection asArray.
  isWildcard := false
]

{ #category : 'testing' }
EntityTagList >> isWildcard [

  ^ isWildcard
]

{ #category : 'testing' }
EntityTagList >> matchesStrongly: anEntityTag [

  ^ isWildcard or: [ entityTags anySatisfy: [ :entityTag | entityTag matchesStrongly: anEntityTag ] ]
]

{ #category : 'testing' }
EntityTagList >> matchesWeakly: anEntityTag [

  ^ isWildcard or: [ entityTags anySatisfy: [ :entityTag | entityTag matchesWeakly: anEntityTag ] ]
]

{ #category : 'printing' }
EntityTagList >> printOn: aStream [

  isWildcard ifTrue: [ ^ aStream nextPut: $* ].
  entityTags
    do: [ :entityTag | entityTag printOn: aStream ]
    separatedBy: [ aStream nextPutAll: ', ' ]
]
