Extension { #name : #ZnRequest }

{ #category : #'*Hyperspace-Development-Tools' }
ZnRequest >> basicInspectorTab [

	<inspectorPresentationOrder: -2 title: 'Basic'>
	| text |

	text := String streamContents: [ :stream | self requestLine printMethodAndUriOn: stream ].
	^ SpTextPresenter new
		  text: text;
		  beWrapWord;
		  yourself
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnRequest >> queryParametersInspectorTab: builder [

	<inspectorPresentationOrder: -1 title: 'Query Params'>
	^ self uri query inspectionItems: builder
]

{ #category : #'*Hyperspace-Development-Tools' }
ZnRequest >> queryParametersInspectorTabContext: aContext [

	aContext active: self uri hasQuery
]
