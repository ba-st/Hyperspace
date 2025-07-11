Extension { #name : 'ZnResponse' }

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> cachingDirectivesInspectorTab: builder [

  <inspectorPresentationOrder: 3 title: 'Caching'>
  ^ builder newTable
      items: self cachingDirectives;
      addColumn: ( SpStringTableColumn new
            title: 'Value';
            evaluated: [ :each | each ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> cachingDirectivesInspectorTabContext: aContext [

	aContext active: self cachingDirectives notEmpty
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> contentLanguageTagsInspectorTab: builder [

  <inspectorPresentationOrder: 5 title: 'Content Language'>
  ^ builder newTable
      items: self contentLanguageTags;
      addColumn: ( SpStringTableColumn new
            title: 'Tags';
            evaluated: [ :each | each printString ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> contentLanguageTagsInspectorTabContext: aContext [

	aContext active: self contentLanguageTags notEmpty
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> linksInspectorTab: builder [

  <inspectorPresentationOrder: 2 title: 'Links'>
  ^ builder newTable
      items: self links;
      addColumn: ( SpStringTableColumn new
            title: 'Value';
            evaluated: [ :each | each printString ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> linksInspectorTabContext: aContext [

	aContext active: self links notEmpty
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> referenceInspectorTab: builder [

  <inspectorPresentationOrder: -1 title: 'Reference'>
  ^ ( builder instantiate: SpMorphPresenter )
      morph: ( RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code ) );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> varyHeaderInspectorTab: builder [

  <inspectorPresentationOrder: 6 title: 'Vary'>
  ^ builder newTable
      items: self varyHeaderNames;
      addColumn: ( SpStringTableColumn new
            title: 'Value';
            evaluated: [ :each | each ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnResponse >> varyHeaderInspectorTabContext: aContext [

	aContext active: self varyHeaderNames notEmpty
]
