Class {
	#name : #ZnRequestHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> googleUrl [

	^ 'https://google.com' asZnUrl
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testIfMatch [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setIfMatchTo: ( ZnETag with: '12345' );
		yourself.

	self assert: ( request headers at: #'If-Match' ) equals: '"12345"'
]

{ #category : #tests }
ZnRequestHyperspaceExtensionsTest >> testIfNoneMatch [

	| request |

	request := ( ZnRequest get: self googleUrl )
		setIfNoneMatchTo: ( ZnETag with: '12345' );
		yourself.
		
	self assert: (request headers at: #'If-None-Match') equals: '"12345"'
]
