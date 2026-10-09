"
I'm a test case for EntityTag
"
Class {
	#name : 'EntityTagTest',
	#superclass : 'TestCase',
	#category : 'Hyperspace-Model-Tests-IETF',
	#package : 'Hyperspace-Model-Tests',
	#tag : 'IETF'
}

{ #category : 'tests' }
EntityTagTest >> testAsEntityTag [

	self
		assert: '"12345"' asEntityTag equals: (EntityTag fromString: '"12345"');
		assert: (EntityTag fromString: '"12345"') asEntityTag equals: (EntityTag fromString: '"12345"')
]

{ #category : 'tests' }
EntityTagTest >> testAsString [ 
	
	self 	assert: (EntityTag with: '12345') asString equals: '"12345"'.
	self 	assert: (EntityTag weakWith: '12345') asString equals: 'W/"12345"'.
]

{ #category : 'tests' }
EntityTagTest >> testCaseSensitiveWeakEntityTagCreation [

	self
		assert: (EntityTag fromString: 'W/"12345"') value equals: '12345';
		should: [ EntityTag fromString: 'w/"12345"' ]
			raise: InstanceCreationFailed
]

{ #category : 'tests' }
EntityTagTest >> testEmptyEntityTag [

  self
    assert: ( EntityTag fromString: '""' ) value equals: '';
    deny: ( EntityTag fromString: '""' ) isWeak;
    assert: ( EntityTag fromString: 'W/""' ) value equals: '';
    assert: ( EntityTag fromString: 'W/""' ) isWeak;
    assert: ( EntityTag fromString: '""' ) printString equals: '""';
    assert: ( EntityTag fromString: 'W/""' ) printString equals: 'W/""'
]

{ #category : 'tests' }
EntityTagTest >> testFromString [

  self
    assert: ( EntityTag fromString: '"12345"' ) value equals: '12345';
    should: [ EntityTag fromString: '' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '123' ] raise: InstanceCreationFailed;
    assert: ( EntityTag fromString: 'W/"12345"' ) value equals: '12345';
    assert: ( EntityTag fromString: 'W/"12345"' ) value equals: '12345';
    should: [ EntityTag fromString: 'W/' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'W/"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'Q/"11"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'W*""' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'W"1"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'WW"1"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: 'w/"1"' ] raise: InstanceCreationFailed
]

{ #category : 'tests' }
EntityTagTest >> testFromStringRefusesCharactersOutsideEntityTagCharacters [

  self
    assert: ( EntityTag fromString: '"!#~,W/"' ) value equals: '!#~,W/';
    should: [ EntityTag fromString: '"a"b"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '"a b"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '"a' , ( String with: Character tab ) , '"' ]
    raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '"a' , ( String with: ( Character value: 16r7F ) ) , '"' ]
    raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '"a' , ( String with: ( Character value: 16rE9 ) ) , '"' ]
    raise: InstanceCreationFailed
    withMessageText: 'Entity tags only allow visible ASCII characters other than double quotes.'
]

{ #category : 'tests' }
EntityTagTest >> testFromStringRefusesListsAndWildcard [

  self
    should: [ EntityTag fromString: '"a", "b"' ]
    raise: InstanceCreationFailed
    withMessageText: 'Entity tags only allow visible ASCII characters other than double quotes.';
    should: [ EntityTag fromString: 'W/"a", W/"b"' ] raise: InstanceCreationFailed;
    should: [ EntityTag fromString: '*' ]
    raise: InstanceCreationFailed
    withMessageText: 'Entity tags must be enclosed in double quotes.'
]

{ #category : 'tests' }
EntityTagTest >> testHash [

	self
		assert: (EntityTag fromString: '"12345"') hash
		equals: (EntityTag fromString: '"12345"') hash.
	self
		assert: (EntityTag fromString: 'W/"12345"') hash
		equals: (EntityTag fromString: 'W/"12345"') hash
]

{ #category : 'tests' }
EntityTagTest >> testPrinting [

	self assert: (EntityTag with: '12345') printString equals: '"12345"'.
	self assert: (EntityTag fromString: '"12345"') printString equals: '"12345"'.
	self assert: (EntityTag fromString: 'W/"12345"') printString equals: 'W/"12345"'.
	
]

{ #category : 'tests' }
EntityTagTest >> testIsStrong [

  self
    assert: ( EntityTag with: '12345' ) isStrong;
    assert: '"12345"' asEntityTag isStrong;
    deny: ( EntityTag weakWith: '12345' ) isStrong;
    deny: 'W/"12345"' asEntityTag isStrong
]

{ #category : 'tests' }
EntityTagTest >> testIsWeak [

  self
    deny: ( EntityTag with: '12345' ) isWeak;
    deny: '"12345"' asEntityTag isWeak;
    assert: ( EntityTag weakWith: '12345' ) isWeak;
    assert: 'W/"12345"' asEntityTag isWeak
]

{ #category : 'tests' }
EntityTagTest >> testMatchesStrongly [

  self
    assert: ( '"a"' asEntityTag matchesStrongly: '"a"' asEntityTag );
    deny: ( '"a"' asEntityTag matchesStrongly: '"b"' asEntityTag );
    deny: ( 'W/"a"' asEntityTag matchesStrongly: '"a"' asEntityTag );
    deny: ( '"a"' asEntityTag matchesStrongly: 'W/"a"' asEntityTag );
    deny: ( 'W/"a"' asEntityTag matchesStrongly: 'W/"a"' asEntityTag )
]

{ #category : 'tests' }
EntityTagTest >> testMatchesWeakly [

  self
    assert: ( '"a"' asEntityTag matchesWeakly: '"a"' asEntityTag );
    deny: ( '"a"' asEntityTag matchesWeakly: '"b"' asEntityTag );
    assert: ( 'W/"a"' asEntityTag matchesWeakly: '"a"' asEntityTag );
    assert: ( '"a"' asEntityTag matchesWeakly: 'W/"a"' asEntityTag );
    assert: ( 'W/"a"' asEntityTag matchesWeakly: 'W/"a"' asEntityTag );
    deny: ( 'W/"a"' asEntityTag matchesWeakly: 'W/"b"' asEntityTag )
]
