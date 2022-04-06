Extension { #name : #ZnHeaders }

{ #category : #'*Hyperspace-Development-Tools' }
ZnHeaders >> itemsInspectorTab: builder [

	<inspectorPresentationOrder: 0 title: 'Items'>
	^ self headers inspectionItems: builder
]
