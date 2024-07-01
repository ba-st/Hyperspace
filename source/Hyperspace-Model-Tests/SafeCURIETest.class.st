"
A SafeCURIETest is a test class for testing the behavior of SafeCURIE
"
Class {
	#name : 'SafeCURIETest',
	#superclass : 'AbstractCURIETest',
	#category : 'Hyperspace-Model-Tests',
	#package : 'Hyperspace-Model-Tests'
}

{ #category : 'private' }
SafeCURIETest >> curieClass [

  ^ SafeCURIE
]

{ #category : 'tests' }
SafeCURIETest >> testAsSafeCURIE [

  | curie |
  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  self assert: curie asSafeCURIE equals: curie
]

{ #category : 'tests' }
SafeCURIETest >> testFromString [

  | curie |
  curie := self curieClass fromString: '[users:octocat/tokens]'.

  self
    assert: curie prefix equals: 'users';
    assertUrl: curie relativeReference equals: 'octocat' asUrl / 'tokens'
]

{ #category : 'tests' }
SafeCURIETest >> testParsingErrors [

  self
    should: [ self curieClass fromString: '[:]' ]
    raise: InstanceCreationFailed
    withMessageText: 'A CURIE prefix cannot be empty';
    should: [ self curieClass fromString: '' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a Safe CURIE from ""';
    should: [ self curieClass fromString: '[' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a Safe CURIE from "["';
    should: [ self curieClass fromString: ']' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a Safe CURIE from "]"';
    should: [ self curieClass fromString: '[]' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a Safe CURIE from "[]"';
    should: [ self curieClass fromString: '[users:octocat:AAA]' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a CURIE from "users:octocat:AAA"';
    should: [ self curieClass fromString: '[users]' ]
    raise: InstanceCreationFailed
    withMessageText: 'Cannot create a CURIE from "users"'
]

{ #category : 'tests' }
SafeCURIETest >> testPrinting [

  | curie curieWithPath curieWithFragment |

  self assert: ( self curieClass fromString: '[users:]' ) printString equals: '[users:]'.

  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  self assert: curie printString equals: '[users:octocat]'.

  curieWithPath := curie / 'addresses'.

  self assert: curieWithPath printString equals: '[users:octocat/addresses]'.

  curieWithFragment := curieWithPath withFragment: 'primary'.

  self assert: curieWithFragment printString equals: '[users:octocat/addresses#primary]'
]
