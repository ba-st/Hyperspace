"
I'm a test case for EntityTagList
"
Class {
	#name : 'EntityTagListTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-IETF',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'IETF'
}

{ #category : 'tests' }
EntityTagListTest >> testAsEntityTagList [

  self
    assert: '"a", W/"b"' asEntityTagList printString equals: '"a", W/"b"';
    assert: #( '"a"' 'W/"b", "c"' ) asEntityTagList printString equals: '"a", W/"b", "c"';
    assert: '*' asEntityTagList isWildcard;
    assert: #( '*' ) asEntityTagList isWildcard
]

{ #category : 'tests' }
EntityTagListTest >> testAsString [

  self
    assert: ( EntityTagList fromString: 'W/"a" ,"b"' ) asString equals: 'W/"a", "b"';
    assert: EntityTagList wildcard asString equals: '*'
]

{ #category : 'tests' }
EntityTagListTest >> testFromRepeatedHeader [

  | headers entityTags |
  headers := ZnHeaders new.
  headers
    at: 'If-None-Match' add: '"a"';
    at: 'If-None-Match' add: 'W/"b"'.

  entityTags := ( headers at: 'If-None-Match' ) asEntityTagList.

  self
    assert: entityTags printString equals: '"a", W/"b"';
    assert: ( entityTags matchesWeakly: '"b"' asEntityTag )
]

{ #category : 'tests' }
EntityTagListTest >> testFromString [

  self
    assert: ( EntityTagList fromString: '"a"' ) printString equals: '"a"';
    assert: ( EntityTagList fromString: 'W/"a"' ) printString equals: 'W/"a"';
    assert: ( EntityTagList fromString: '"a", W/"b", ""' ) printString equals: '"a", W/"b", ""';
    assert: ( EntityTagList fromString: '"a",W/"b"' ) printString equals: '"a", W/"b"';
    assert:
      ( EntityTagList fromString: '"a",' , ( String with: Character tab ) , '"b"' ) printString
    equals: '"a", "b"';
    deny: ( EntityTagList fromString: '"a"' ) isWildcard
]

{ #category : 'tests' }
EntityTagListTest >> testFromStringIgnoresEmptyListElements [

  self assert: ( EntityTagList fromString: ' , "a",, "b" ,' ) printString equals: '"a", "b"'
]

{ #category : 'tests' }
EntityTagListTest >> testFromStringKeepsCommasInsideOpaqueTags [

  | entityTags |
  entityTags := EntityTagList fromString: '"a,b", W/","'.

  self
    assert: entityTags printString equals: '"a,b", W/","';
    assert: ( entityTags matchesStrongly: '"a,b"' asEntityTag );
    deny: ( entityTags matchesStrongly: '"a"' asEntityTag );
    assert: ( entityTags matchesWeakly: '","' asEntityTag )
]

{ #category : 'tests' }
EntityTagListTest >> testFromStringRefusesEmptyLists [

  #( '' ' ' ',' ' , , ' ) do: [ :fieldValue |
      self
        should: [ EntityTagList fromString: fieldValue ]
        raise: InstanceCreationFailed
        withMessageText: 'An entity tag list must hold at least one entity tag.'
    ]
]

{ #category : 'tests' }
EntityTagListTest >> testFromStringRefusesInvalidEntityTags [

  #( '"a" "b"' '"a", b' '"a, "b"' '"a' 'a' '*, "a"' '"a", *' '**' 'W/ "a"' '"a"W/"b"' ) do: [
    :fieldValue |
      self should: [ EntityTagList fromString: fieldValue ] raise: InstanceCreationFailed ]
]

{ #category : 'tests' }
EntityTagListTest >> testFromStrings [

  self
    assert: ( EntityTagList fromStrings: #( '"a"' ) ) printString equals: '"a"';
    assert: ( EntityTagList fromStrings: #( '"a", W/"b"' '"c"' ) ) printString
    equals: '"a", W/"b", "c"';
    assert: ( EntityTagList fromStrings: #( '*' ) ) isWildcard;
    should: [ EntityTagList fromStrings: #(  ) ] raise: InstanceCreationFailed;
    should: [ EntityTagList fromStrings: #( '*' '"a"' ) ] raise: InstanceCreationFailed
]

{ #category : 'tests' }
EntityTagListTest >> testMatchesStrongly [

  | entityTags |
  entityTags := EntityTagList fromString: 'W/"a", "b"'.

  self
    deny: ( entityTags matchesStrongly: '"a"' asEntityTag );
    deny: ( entityTags matchesStrongly: 'W/"a"' asEntityTag );
    assert: ( entityTags matchesStrongly: '"b"' asEntityTag );
    deny: ( entityTags matchesStrongly: 'W/"b"' asEntityTag );
    deny: ( entityTags matchesStrongly: '"c"' asEntityTag )
]

{ #category : 'tests' }
EntityTagListTest >> testMatchesWeakly [

  | entityTags |
  entityTags := EntityTagList fromString: 'W/"a", "b"'.

  self
    assert: ( entityTags matchesWeakly: '"a"' asEntityTag );
    assert: ( entityTags matchesWeakly: 'W/"a"' asEntityTag );
    assert: ( entityTags matchesWeakly: '"b"' asEntityTag );
    assert: ( entityTags matchesWeakly: 'W/"b"' asEntityTag );
    deny: ( entityTags matchesWeakly: '"c"' asEntityTag )
]

{ #category : 'tests' }
EntityTagListTest >> testWildcard [

  | wildcard |
  wildcard := EntityTagList fromString: ' * '.

  self
    assert: wildcard isWildcard;
    assert: ( wildcard matchesStrongly: '"a"' asEntityTag );
    assert: ( wildcard matchesStrongly: 'W/"a"' asEntityTag );
    assert: ( wildcard matchesWeakly: '"a"' asEntityTag );
    assert: ( wildcard matchesWeakly: 'W/"a"' asEntityTag );
    assert: EntityTagList wildcard isWildcard
]

{ #category : 'tests' }
EntityTagListTest >> testWithAll [

  | entityTags |
  entityTags := EntityTagList withAll: { EntityTag with: 'a' . 'W/"b"' }.

  self
    assert: entityTags printString equals: '"a", W/"b"';
    deny: entityTags isWildcard;
    should: [ EntityTagList withAll: #(  ) ]
    raise: InstanceCreationFailed
    withMessageText: 'An entity tag list must hold at least one entity tag.';
    should: [ EntityTagList withAll: #( '*' ) ] raise: InstanceCreationFailed
]
