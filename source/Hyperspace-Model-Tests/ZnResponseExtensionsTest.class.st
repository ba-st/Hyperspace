Class {
	#name : #ZnResponseExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Extensions'
}

{ #category : #tests }
ZnResponseExtensionsTest >> googleUrl [

	^ 'https://google.com' asZnUrl
]

{ #category : #tests }
ZnResponseExtensionsTest >> testEntityTag [

	| response |

	response := ZnResponse noContent
		setEntityTag: ( ZnETag with: '1234' );
		yourself.
		
	self assert: response entityTag equals: (ZnETag with: '1234')
]

{ #category : #tests }
ZnResponseExtensionsTest >> testLink [

	| response |

	response := ZnResponse noContent
		addLink: ( ZnLink to: self googleUrl );
		yourself.
		
	self assert: response links equals: { ZnLink to: self googleUrl }
]
