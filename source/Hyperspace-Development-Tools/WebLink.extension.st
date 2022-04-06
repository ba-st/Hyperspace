Extension { #name : #WebLink }

{ #category : #'*Hyperspace-Development-Tools' }
WebLink >> parametersInspectorTab: builder [

	<inspectorPresentationOrder: 901 title: 'Parameters'>
	^ self parameters inspectionItems: builder
]
