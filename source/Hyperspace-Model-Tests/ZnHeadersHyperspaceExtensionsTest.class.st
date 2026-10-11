Class {
	#name : 'ZnHeadersHyperspaceExtensionsTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-Zinc',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'Zinc'
}

{ #category : 'tests' }
ZnHeadersHyperspaceExtensionsTest >> testAddToListCombinesSeveralFieldLines [

  | headers |
  headers := ZnHeaders new.
  headers
    at: 'Vary' add: 'Accept';
    at: 'Vary' add: 'Origin';
    at: 'Vary' addToList: 'Accept-Language'.

  self assert: ( headers at: 'Vary' ) equals: 'Accept, Origin, Accept-Language'
]

{ #category : 'tests' }
ZnHeadersHyperspaceExtensionsTest >> testAddToListOnAbsentField [

  | headers |
  headers := ZnHeaders new.
  headers at: 'Vary' addToList: 'Accept'.

  self assert: ( headers at: 'Vary' ) equals: 'Accept'
]

{ #category : 'tests' }
ZnHeadersHyperspaceExtensionsTest >> testAddToListOnSingleFieldLine [

  | headers |
  headers := ZnHeaders new.
  headers
    at: 'Vary' put: 'Accept, Origin';
    at: 'vary' addToList: 'Accept-Language'.

  self assert: ( headers at: 'Vary' ) equals: 'Accept, Origin, Accept-Language'
]

{ #category : 'tests' }
ZnHeadersHyperspaceExtensionsTest >> testFieldLinesAt [

  | headers |
  headers := ZnHeaders new.

  self assert: ( headers fieldLinesAt: 'Vary' ) equals: #(  ).

  headers at: 'Vary' put: 'Accept, Origin'.
  self assert: ( headers fieldLinesAt: 'Vary' ) equals: #( 'Accept, Origin' ).

  headers at: 'Vary' add: 'Accept-Language'.
  self assert: ( headers fieldLinesAt: 'Vary' ) equals: #( 'Accept, Origin' 'Accept-Language' )
]
