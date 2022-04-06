Extension { #name : #ZnResponse }

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> cachingDirectivesInspectorTab [

	<inspectorPresentationOrder: 3 title: 'Caching'>
	^ SpTablePresenter new
		  items: self cachingDirectives;
		  addColumn: ( SpStringTableColumn new
				    title: 'Value';
				    evaluated: [ :each | each ];
				    yourself );
		  yourself
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> cachingDirectivesInspectorTabContext: aContext [

	aContext active: self cachingDirectives notEmpty
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> contentLanguageTagsInspectorTab [

	<inspectorPresentationOrder: 5 title: 'Content Language'>
	^ SpTablePresenter new
		  items: self contentLanguageTags;
		  addColumn: ( SpStringTableColumn new
				    title: 'Tags';
				    evaluated: [ :each | each printString ];
				    yourself );
		  yourself
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> contentLanguageTagsInspectorTabContext: aContext [

	aContext active: self contentLanguageTags notEmpty
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> linksInspectorTab [

	<inspectorPresentationOrder: 2 title: 'Links'>
	^ SpTablePresenter new
		  items: self links;
		  addColumn: ( SpStringTableColumn new
				    title: 'Value';
				    evaluated: [ :each | each printString ];
				    yourself );
		  yourself
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> linksInspectorTabContext: aContext [

	aContext active: self links notEmpty
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> referenceInspectorTab [

	<inspectorPresentationOrder: -1 title: 'Reference'>
	^ RichTextPresenter rendering: ( HTTPStatusReference referenceFor: self code )
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> varyHeaderInspectorTab [

	<inspectorPresentationOrder: 6 title: 'Vary'>
	^ SpTablePresenter new
		  items: self varyHeaderNames;
		  addColumn: ( SpStringTableColumn new
				    title: 'Value';
				    evaluated: [ :each | each ];
				    yourself );
		  yourself
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnResponse >> varyHeaderInspectorTabContext: aContext [

	aContext active: self varyHeaderNames notEmpty
]
