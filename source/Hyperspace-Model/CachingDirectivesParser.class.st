Class {
	#name : 'CachingDirectivesParser',
	#superclass : 'Object',
	#category : 'Hyperspace-Model-IETF',
	#package : 'Hyperspace-Model',
	#tag : 'IETF'
}

{ #category : 'instance creation' }
CachingDirectivesParser class >> on: aReadStream [ 
	
	^self new initialize: aReadStream
]

{ #category : 'parsing' }
CachingDirectivesParser >> parse: string [

  | readStream directives isInsideQuotes currentDirectiveStream |
  directives := OrderedCollection new.
  isInsideQuotes := false.
  currentDirectiveStream := String new writeStream.
  readStream := string readStream.
  [ readStream atEnd ] whileFalse: [
      | nextCharacter |
      nextCharacter := readStream next.
      nextCharacter = $,
        then: [
            isInsideQuotes
              then: [ "Inside quotes keeps processing, do not use as separator"
                  currentDirectiveStream nextPut: nextCharacter ]
              otherwise: [ "Outside quotes use a directive separator"
                  directives add: currentDirectiveStream contents trimBoth.
                  currentDirectiveStream := String new writeStream
                ]
          ]
        otherwise: [
            nextCharacter = $" then: [ isInsideQuotes := isInsideQuotes not ].
            currentDirectiveStream nextPut: nextCharacter
          ]
    ].
  "Process any remaining part of the input"
  currentDirectiveStream contents trimBoth ifNotEmpty: [ :directive | directives add: directive ].
  ^ directives asArray
]
