"
I'm a test case for EntityTag
"
Class {
	#name : #EntityTagTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-IETF'
}

{ #category : #tests }
EntityTagTest >> testAsEntityTag [

	self
		assert: '"12345"' asEntityTag equals: (EntityTag fromString: '"12345"');
		assert: (EntityTag fromString: '"12345"') asEntityTag equals: (EntityTag fromString: '"12345"')
]

{ #category : #tests }
EntityTagTest >> testAsString [ 
	
	self 	assert: (EntityTag with: '12345') asString equals: '"12345"'.
	self 	assert: (EntityTag weakWith: '12345') asString equals: 'W/"12345"'.
]

{ #category : #tests }
EntityTagTest >> testCaseSensitiveWeakEntityTagCreation [

	self
		assert: (EntityTag fromString: 'W/"12345"') value equals: '12345';
		should: [ EntityTag fromString: 'w/"12345"' ]
			raise: InstanceCreationFailed
]

{ #category : #tests }
EntityTagTest >> testFromString [

	self
		assert: (EntityTag fromString: '"12345"') value equals: '12345';
		should: [ EntityTag fromString: '""' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: '' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: '123' ] raise: InstanceCreationFailed;
		assert: (EntityTag fromString: 'W/"12345"') value equals: '12345';
		assert: (EntityTag fromString: 'W/"12345"') value equals: '12345';
		should: [ EntityTag fromString: 'W/""' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: 'Q/"11"' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: 'W*""' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: 'W"1"' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: 'WW"1"' ] raise: InstanceCreationFailed;
		should: [ EntityTag fromString: 'w/"1"' ] raise: InstanceCreationFailed
]

{ #category : #tests }
EntityTagTest >> testHash [

	self
		assert: (EntityTag fromString: '"12345"') hash
		equals: (EntityTag fromString: '"12345"') hash.
	self
		assert: (EntityTag fromString: 'W/"12345"') hash
		equals: (EntityTag fromString: 'W/"12345"') hash
]

{ #category : #tests }
EntityTagTest >> testPrinting [

	self assert: (EntityTag with: '12345') printString equals: '"12345"'.
	self assert: (EntityTag fromString: '"12345"') printString equals: '"12345"'.
	self assert: (EntityTag fromString: 'W/"12345"') printString equals: 'W/"12345"'.
	
]
