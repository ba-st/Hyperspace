Extension { #name : 'HTTPClientError' }

{ #category : '*Hyperspace-Development-Tools' }
HTTPClientError >> referenceInspectorTab: builder [

  <inspectorPresentationOrder: 0 title: 'Reference'>
  ^ ( builder instantiate: SpMorphPresenter )
      morph: ( RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code ) );
      yourself
]
