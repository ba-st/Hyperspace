"
I'm a test case for ZnETag
"
Class {
	#name : #ZnETagTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnETagTest >> testAsEtag [

	self
		assert: '"12345"' asETag equals: (ZnETag fromString: '"12345"');
		assert: (ZnETag fromString: '"12345"') asETag equals: (ZnETag fromString: '"12345"')
]

{ #category : #tests }
ZnETagTest >> testAsString [ 
	
	self 	assert: (ZnETag with: '12345') asString equals: '"12345"'.
	self 	assert: (ZnETag weekValidatedWith: '12345') asString equals: 'W/"12345"'.
]

{ #category : #tests }
ZnETagTest >> testFromString [

	self
		assert: (ZnETag fromString: '"12345"') value equals: '12345';
		should: [ ZnETag fromString: '""' ] raise: InstanceCreationFailed;
		should: [ ZnETag fromString: '' ] raise: InstanceCreationFailed;
		should: [ ZnETag fromString: '123' ] raise: InstanceCreationFailed;
		assert: (ZnETag fromString: 'W/"12345"') value equals: '12345';
		assert: (ZnETag fromString: 'W/"12345"') value equals: '12345';
		should: [ ZnETag fromString: 'W/""' ] raise: InstanceCreationFailed;
		should: [ ZnETag fromString: 'Q/"11"' ] raise: InstanceCreationFailed;
		should: [ ZnETag fromString: 'W*""' ] raise: InstanceCreationFailed;
		should: [ ZnETag fromString: 'W"1"' ] raise: InstanceCreationFailed

]

{ #category : #tests }
ZnETagTest >> testHash [

	self
		assert: (ZnETag fromString: '"12345"') hash
		equals: (ZnETag fromString: '"12345"') hash.
	self
		assert: (ZnETag fromString: 'W/"12345"') hash
		equals: (ZnETag fromString: 'W/"12345"') hash
]

{ #category : #tests }
ZnETagTest >> testPrinting [

	self assert: (ZnETag with: '12345') printString equals: '"12345"'.
	self assert: (ZnETag fromString: '"12345"') printString equals: '"12345"'.
	self assert: (ZnETag fromString: 'W/"12345"') printString equals: 'W/"12345"'.
	
]
