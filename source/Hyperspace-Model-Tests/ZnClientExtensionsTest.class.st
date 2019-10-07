Class {
	#name : #ZnClientExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnClientExtensionsTest >> testSetAccept [

	| client |

	client := ZnClient new.

	self assert: client request accept equals: '*/*'.
	client setAccept: ZnMimeType applicationPdf.
	self assert: client request accept equals: ZnMimeType applicationPdf asString
]

{ #category : #tests }
ZnClientExtensionsTest >> testSetIfMatchTo [

	| client |

	client := ZnClient new.

	self should: [ client request headers at: #'If-Match' ] raise: KeyNotFound.
	client setIfMatchTo: ( ZnETag with: '12345' ).
	self assert: ( client request headers at: #'If-Match' ) equals: '"12345"'
]
