Class {
	#name : 'CachingDirectivesParser',
	#superclass : 'Object',
	#instVars : [
		'headerStream',
		'directiveRegistry',
		'nextTokenParseMethod',
		'currentDirective',
		'directives'
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

  headerStream := aReadStream.
  nextTokenParseMethod := #parseDirective.
  currentDirective := nil.
  directives := OrderedCollection new
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseArguments [

  | arguments |
  arguments := ( headerStream peekFor: $" )
                 then: [ '"<1s>"' expandMacrosWith: ( headerStream upTo: $" ) ]
                 otherwise: [ headerStream upTo: $, ].

  directives add: ( '<1s>=<2s>' expandMacrosWith: currentDirective contents with: arguments ).

  nextTokenParseMethod := #parseDirective
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseDirective [

  currentDirective := WriteStream on: String new.

  [ headerStream atEnd ] whileFalse: [
      ( headerStream peekFor: $, ) then: [
          directives add: currentDirective contents.
          ^ self
        ].
      ( headerStream peekFor: $= ) then: [
          nextTokenParseMethod := #parseArguments.
          ^ self
        ].

      currentDirective nextPut: headerStream next
    ].

  directives add: currentDirective contents
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseDirectives [

  [ headerStream atEnd ] whileFalse: [
      self consumeSeparators.
      self perform: nextTokenParseMethod
    ].

  ^ directives asArray
]
