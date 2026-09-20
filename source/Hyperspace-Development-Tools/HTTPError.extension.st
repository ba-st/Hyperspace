Extension { #name : 'HTTPError' }

{ #category : '*Hyperspace-Development-Tools' }
HTTPError >> additionalDataInspectorTab: builder [

	<inspectorPresentationOrder: 1 title: 'Additional data'>
	| items |

	items := OrderedCollection new.
	self additionalDataKeysAndValuesDo: [ :key :value | items add: key -> value ].
	^ builder newTable
		  items: items;
		  addColumn: ( SpStringTableColumn new
				    title: 'Key';
				    evaluated: [ :each | each key ];
				    yourself );
		  addColumn: ( SpStringTableColumn new
				    title: 'Value';
				    evaluated: [ :each | each value printString ];
				    yourself );
		  yourself
]

{ #category : '*Hyperspace-Development-Tools' }
HTTPError >> additionalDataInspectorTabContext: aContext [

	aContext active: self hasAdditionalData
]
