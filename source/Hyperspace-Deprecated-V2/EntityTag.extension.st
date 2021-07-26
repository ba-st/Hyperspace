Extension { #name : #EntityTag }

{ #category : #'*Hyperspace-Deprecated-V2' }
EntityTag >> asETag [

	self deprecated: 'Use asEntityTag' transformWith: '`@receiver asETag' -> '`@receiver asEntityTag'.
	^ self asEntityTag
]
