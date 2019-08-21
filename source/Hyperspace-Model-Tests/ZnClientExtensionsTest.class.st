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
