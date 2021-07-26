Extension { #name : #String }

{ #category : #'*Hyperspace-Deprecated-V2' }
String >> asETag [

	self deprecated: 'Use asEntityTag' transformWith: '`@receiver asETag' -> '`@receiver asEntityTag'.
	^ self asEntityTag
]
