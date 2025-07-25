Class {
	#name : 'CachingDirectivesParser',
	#superclass : 'Object',
	#instVars : [
		'headerStream',
		'directiveRegistry'
	],
	#category : 'Hyperspace-Model',
	#package : 'Hyperspace-Model'
}

{ #category : 'instance creation' }
CachingDirectivesParser class >> on: aReadStream [ 
	
	^self new initialize: aReadStream
]

{ #category : 'adding' }
CachingDirectivesParser >> consumeSeparators [

  [ ( headerStream peekFor: $, ) or: [ headerStream peekFor: Character space ] ] whileTrue
]

{ #category : 'initialization' }
CachingDirectivesParser >> initialize: aReadStream [

  headerStream := aReadStream
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseArguments [

  ^ ( headerStream peekFor: $" )
      then: [ headerStream upTo: $" ]
      otherwise: [ headerStream upTo: $, ]
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseDirectives [

  | directives |
  directives := OrderedCollection new.
  [ headerStream atEnd ] whileFalse: [
      | directive |
      directive := self parseNextDirective.
      headerStream peekBack = $=
        then: [
            | arguments |
            arguments := self parseArguments.
            directives add: ( '<1s>=<2s>' expandMacrosWith: directive with: arguments )
          ]
        otherwise: [ directives add: directive ].
      self consumeSeparators
    ].

  ^ directives asArray
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseNextDirective [

  ^ String streamContents: [ :stream |
        [ headerStream atEnd or: [ ( headerStream peekFor: $, ) or: [ headerStream peekFor: $= ] ] ]
          whileFalse: [
              | char |
              char := headerStream next.
              stream nextPut: char
            ]
      ]
]
