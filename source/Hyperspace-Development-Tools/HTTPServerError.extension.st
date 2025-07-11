Extension { #name : 'HTTPServerError' }

{ #category : '*Hyperspace-Development-Tools' }
HTTPServerError >> referenceInspectorTab: builder [

  <inspectorPresentationOrder: 0 title: 'Reference'>
  ^ ( builder instantiate: SpMorphPresenter )
      morph: ( RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code ) );
      yourself
]
