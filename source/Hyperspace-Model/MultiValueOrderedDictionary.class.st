"
I'm like ZnMultiValueDictionary but preserving the insertion order of my keys.
I'm here to provide deterministic behavior to objects using me.
"
Class {
	#name : #MultiValueOrderedDictionary,
	#superclass : #OrderedDictionary,
	#category : #'Hyperspace-Model-IETF'
}

{ #category : #enumerating }
MultiValueOrderedDictionary >> at: key add: value [

	"Store value under key. If key already exists, store multiple values as Array"

	| newValue |

	newValue := self
		            at: key
		            ifPresent: [ :existing | 
			            existing isArray ifTrue: [ existing copyWith: value ]
				            ifFalse: [ Array with: existing with: value ]
			            ]
		            ifAbsent: [ value ].
	^ self at: key put: newValue
]

{ #category : #enumerating }
MultiValueOrderedDictionary >> keysAndValuesDo: block [
	"Execute a two argument (key, value) block for each header.
	Multi-valued headers are handled transparently."

	super keysAndValuesDo: [ :key :value |
		value isArray
			ifTrue: [ 
				value do: [ :each | 
					block value: key value: each ] ]
			ifFalse: [
				block value: key value: value ] ]
]
