Extension { #name : #HTTPClientError }

{ #category : #'*Hyperspace-Development-Tools' }
HTTPClientError >> referenceInspectorTab [

	<inspectorPresentationOrder: 0 title: 'Reference'>
	^ RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code )
]
