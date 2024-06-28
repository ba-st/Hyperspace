"
A CompactURITest is a test class for testing the behavior of CompactURI
"
Class {
	#name : #CURIETest,
	#superclass : #AbstractCURIETest,
	#category : 'Hyperspace-Model-Tests'
}

{ #category : #private }
CURIETest >> curieClass [

  ^ CURIE
]

{ #category : #tests }
CURIETest >> testAsSafeCURIE [

  self
    assert: ( self curieClass fromString: 'users:octocat' ) asSafeCURIE printString
    equals: '[users:octocat]'
]

{ #category : #tests }
CURIETest >> testFromString [

  | curie |
  curie := self curieClass fromString: 'users:octocat/tokens'.

  self
    assert: curie prefix equals: 'users';
    assertUrl: curie relativeReference equals: 'octocat' asUrl / 'tokens'
]

{ #category : #tests }
CURIETest >> testParsingErrors [

  self
    should: [ self curieClass fromString: ':' ]
    raise: InstanceCreationFailed
    withMessageText: 'A CURIE prefix cannot be empty';
    should: [ self curieClass fromString: '' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a CURIE from ""';
    should: [ self curieClass fromString: 'users:octocat:AAA' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a CURIE from "users:octocat:AAA"';
    should: [ self curieClass fromString: 'users' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a CURIE from "users"'
]

{ #category : #tests }
CURIETest >> testPrinting [

  | curie curieWithPath curieWithFragment |

  self assert: ( self curieClass fromString: 'users:' ) printString equals: 'users:'.

  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  self assert: curie printString equals: 'users:octocat'.

  curieWithPath := curie / 'addresses'.

  self assert: curieWithPath printString equals: 'users:octocat/addresses'.

  curieWithFragment := curieWithPath withFragment: 'primary'.

  self assert: curieWithFragment printString equals: 'users:octocat/addresses#primary'
]
