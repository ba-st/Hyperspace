"
An AbstractCURIETest is a test class for testing the behavior of AbstractCURIE
"
Class {
	#name : 'AbstractCURIETest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests',
	#package : 'Hyperspace-Model-Tests'
}

{ #category : 'testing' }
AbstractCURIETest class >> isAbstract [

  ^ self = AbstractCURIETest
]

{ #category : 'private' }
AbstractCURIETest >> curieClass [

  ^ self subclassResponsibility
]

{ #category : 'tests' }
AbstractCURIETest >> testAccessing [

  | curie |
  curie := self curieClass prefixedBy: 'schema' referencing: 'Person' asUrl.

  self
    assert: curie prefix equals: 'schema';
    assertUrl: curie relativeReference equals: 'Person' asUrl.


  curie := self curieClass prefixedBy: 'schema' referencing: 'Person#legal' asUrl.

  self
    assert: curie prefix equals: 'schema';
    assertUrl: curie relativeReference equals: 'Person#legal' asUrl
]

{ #category : 'tests' }
AbstractCURIETest >> testAsWebLink [

  | curie |
  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.
  self assert: curie asWebLink equals: ( WebLink to: curie )
]

{ #category : 'tests' }
AbstractCURIETest >> testCantCreateWithAbsoluteReference [

  self
    should: [ self curieClass prefixedBy: 'users' referencing: 'https://google.com/' asUrl ]
    raise: InstanceCreationFailed
    withMessageText: 'https://google.com/ must be a relative reference'
]

{ #category : 'tests' }
AbstractCURIETest >> testCantCreateWithEmptyPrefix [

  self
    should: [ self curieClass prefixedBy: '' referencing: 'octocat' asUrl ]
    raise: InstanceCreationFailed
    withMessageText: 'A CURIE prefix cannot be empty'
]

{ #category : 'tests' }
AbstractCURIETest >> testCantExpandToURIInContext [

  | curie |
  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  self
    should: [ curie expandToURIIn: Dictionary new ]
    raise: ObjectNotFound
    withMessageText: 'Missing namespace "users"'
]

{ #category : 'tests' }
AbstractCURIETest >> testCantExpandToURIInContextRecursiverly [

  | userCurie usersCurie context |
  usersCurie := self curieClass prefixedBy: 'api' referencing: 'users' asUrl.
  userCurie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  context := Dictionary new.
  context at: 'users' put: usersCurie.
  self
    should: [ userCurie expandToURIIn: context ]
    raise: ObjectNotFound
    withMessageText: 'Missing namespace "api"'
]

{ #category : 'tests' }
AbstractCURIETest >> testComparing [

  | curie |
  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  self assert: curie equals: curie.

  self
    assert: curie equals: ( self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl );
    assert: curie hash
    equals: ( self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl ) hash;
    deny: curie equals: ( self curieClass prefixedBy: 'users' referencing: 'hexacat' asUrl );
    deny: curie equals: ( self curieClass prefixedBy: 'orgs' referencing: 'octocat' asUrl )
]

{ #category : 'tests' }
AbstractCURIETest >> testExpandToURIInContext [

  | curie context |
  curie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  context := Dictionary new.
  context at: 'users' put: 'https://api.github.com/users/' asUrl.
  self
    assertUrl: ( curie expandToURIIn: context )
    equals: 'https://api.github.com/users/octocat' asUrl
]

{ #category : 'tests' }
AbstractCURIETest >> testExpandToURIInContextRecursively [

  | usersCurie userCurie context |
  usersCurie := self curieClass prefixedBy: 'api' referencing: 'users' asUrl.
  userCurie := self curieClass prefixedBy: 'users' referencing: 'octocat' asUrl.

  context := Dictionary new.
  context at: 'api' put: 'https://api.github.com' asUrl.
  context at: 'users' put: usersCurie.

  self
    assertUrl: ( userCurie expandToURIIn: context )
    equals: 'https://api.github.com/users/octocat' asUrl
]
