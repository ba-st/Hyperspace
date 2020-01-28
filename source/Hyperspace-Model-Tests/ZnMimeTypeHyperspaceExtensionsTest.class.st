Class {
	#name : #ZnMimeTypeHyperspaceExtensionsTest,
	#superclass : #TestCase,
	#category : #'Hyperspace-Model-Tests-Zinc'
}

{ #category : #tests }
ZnMimeTypeHyperspaceExtensionsTest >> testComparingWithParameters [

	| mimeType equalMimeType |

	mimeType := ZnMimeType fromString: 'application/json;q=1'.
	equalMimeType := ZnMimeType applicationJson parameterAt: 'q' put: '1'.

	self
		assert: mimeType equals: equalMimeType;
		assert: mimeType hash equals: equalMimeType hash;
		deny: mimeType = ZnMimeType applicationJson
]
