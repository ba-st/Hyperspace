Extension { #name : #WebLink }

{ #category : #'*Hyperspace-Deprecated-V2' }
WebLink >> rel [

	self deprecated: 'Use relationType' transformWith: '`@receiver rel' -> '`@receiver relationType'.
	^ self relationType
]

{ #category : #'*Hyperspace-Deprecated-V2' }
WebLink >> rel: aRelation [

	self deprecated: 'Use #relationType:'
		transformWith: '`@receiver rel: `@type' -> '`@receiver relationType: `@type'.

	self relationType: aRelation
]
