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

{ #category : 'private - parsing' }
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

{ #category : 'private - parsing' }
CachingDirectivesParser >> parseArguments [

  | arguments |
  arguments := ( headerStream peekFor: $" )
                 then: [ '"<1s>"' expandMacrosWith: ( headerStream upTo: $" ) ]
                 otherwise: [ headerStream upTo: $, ].

  currentDirective
    nextPut: $=;
    nextPutAll: arguments.

  self storeCurrentDirective.

  nextTokenParseMethod := #parseDirective
]

{ #category : 'private - parsing' }
CachingDirectivesParser >> parseDirective [

  currentDirective := WriteStream on: String new.

  [ headerStream atEnd ] whileFalse: [
      ( headerStream peekFor: $, ) then: [
          self storeCurrentDirective.
          ^ self
        ].
      ( headerStream peekFor: $= ) then: [
          nextTokenParseMethod := #parseArguments.
          ^ self
        ].

      currentDirective nextPut: headerStream next
    ].
  self storeCurrentDirective
]

{ #category : 'parsing' }
CachingDirectivesParser >> parseDirectives [

  [ headerStream atEnd ] whileFalse: [
      self consumeSeparators.
      self perform: nextTokenParseMethod
    ].

  ^ directives asArray
]

{ #category : 'private - parsing' }
CachingDirectivesParser >> storeCurrentDirective [

  directives add: currentDirective contents
]
