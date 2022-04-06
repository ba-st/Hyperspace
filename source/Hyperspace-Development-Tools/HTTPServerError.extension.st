Extension { #name : #HTTPServerError }

{ #category : #'*Hyperspace-Development-Tools' }
HTTPServerError >> referenceInspectorTab [

	<inspectorPresentationOrder: 0 title: 'Reference'>
	^ RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code )
]
