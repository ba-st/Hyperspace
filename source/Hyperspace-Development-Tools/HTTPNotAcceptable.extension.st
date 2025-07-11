Extension { #name : 'HTTPNotAcceptable' }

{ #category : '*Hyperspace-Development-Tools' }
HTTPNotAcceptable >> allowedLanguageTagsInspectorTab: builder [

  <inspectorPresentationOrder: 2 title: 'Allowed language tags'>
  ^ builder newTable
      items: allowedLanguageTags;
      addColumn: ( SpStringTableColumn new
            title: 'Language Tag';
            evaluated: [ :each | each printString ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
HTTPNotAcceptable >> allowedLanguageTagsInspectorTabContext: aContext [

	aContext active: allowedLanguageTags notEmpty
]

{ #category : '*Hyperspace-Development-Tools' }
HTTPNotAcceptable >> allowedMediaTypesInspectorTab: builder [

  <inspectorPresentationOrder: 1 title: 'Allowed media types'>
  ^ builder newTable
      items: allowedMediaTypes;
      addColumn: ( SpStringTableColumn new
            title: 'Media Type';
            evaluated: [ :each | each printString ];
            yourself );
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
HTTPNotAcceptable >> allowedMediaTypesInspectorTabContext: aContext [

	aContext active: allowedMediaTypes notEmpty
]
