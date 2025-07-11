Extension { #name : 'ZnMessage' }

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> binaryBodyInspectorTab: builder [

  <inspectorPresentationOrder: 0 title: 'Body Raw'>
  ^ self entity inspectBytes: builder
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> binaryBodyInspectorTabContext: aContext [

	aContext active:
		( self hasEntity and: [ self entity hasContentType and: [ self entity contentType isBinary ] ] )
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> headersInspectorTab: builder [

	<inspectorPresentationOrder: 2 title: 'Headers'>
	^ self headers itemsInspectorTab: builder
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> headersInspectorTabContext: aContext [

	aContext active: self hasHeaders
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> jsonBodyInspectorTab: builder [

  <inspectorPresentationOrder: 1 title: 'Body JSON Pretty'>
  ^ builder newText
      text: ( STONJSON toStringPretty: ( STONJSON fromString: self contents ) );
      beWrapWord;
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> jsonBodyInspectorTabContext: aContext [

	aContext active: ( self hasEntity and: [ 
			  self entity hasContentType and: [ self entity contentType accepts: ZnMimeType applicationJson ] ] )
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> textBodyInspectorTab: builder [

  <inspectorPresentationOrder: 0 title: 'Body Raw'>
  ^ builder newText
      text: self contents;
      beWrapWord;
      yourself
]

{ #category : '*Hyperspace-Development-Tools' }
ZnMessage >> textBodyInspectorTabContext: aContext [

	aContext active:
		( self hasEntity and: [ self entity hasContentType and: [ self entity contentType isBinary not ] ] )
]
