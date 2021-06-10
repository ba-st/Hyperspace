"
A LanguageRangeTest is a test class for testing the behavior of LanguageRange
"
Class {
	#name : #LanguageRangeTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-IETF'
}

{ #category : #tests }
LanguageRangeTest >> testAny [

	self
		assert: LanguageRange any printString equals: '*';
		assert: LanguageRange any equals: LanguageRange any;
		assert: LanguageRange any hash equals: LanguageRange any hash;
		assert: LanguageRange any subtags equals: #('*')
]

{ #category : #tests }
LanguageRangeTest >> testAnyMatches [

	| range |

	range := LanguageRange any.
	self
		assert: ( range matches: 'en-Latn-US' asLanguageTag );
		assert: ( range matches: 'en' asLanguageTag );
		assert: ( range matches: 'es-ar' asLanguageTag )
]

{ #category : #tests }
LanguageRangeTest >> testComparison [

	| range |

	range := LanguageRange from: #('en' 'US').
	self
		assert: range equals: ( LanguageRange fromString: 'en-us' );
		assert: range hash equals: ( LanguageRange fromString: 'en-us' ) hash;
		deny: range equals: LanguageRange any;
		deny: range equals: ( LanguageRange from: #('en') )
]

{ #category : #tests }
LanguageRangeTest >> testCreation [

	| range |

	range := LanguageRange from: #('en' 'Latn' 'us').
	self
		assert: range subtags equals: #('en' 'Latn' 'US');
		assert: range printString equals: 'en-Latn-US'
]

{ #category : #tests }
LanguageRangeTest >> testMatches [

	| range |

	range := LanguageRange from: #('en' 'US').
	self
		deny: ( range matches: 'en-Latn-US' asLanguageTag );
		assert: ( range matches: 'en-US' asLanguageTag );
		deny: ( range matches: 'en' asLanguageTag );
		assert: ( range matches: 'en-us-x-x-x' asLanguageTag ).

	range := LanguageRange from: #('en').
	self
		assert: ( range matches: 'en-Latn-US' asLanguageTag );
		assert: ( range matches: 'en-US' asLanguageTag );
		assert: ( range matches: 'en' asLanguageTag );
		assert: ( range matches: 'en-us-x-x-x' asLanguageTag )
]
