Extension { #name : 'ZnHeaders' }

{ #category : '*Hyperspace-Extensions' }
ZnHeaders >> at: fieldName addToList: aValue [

  | combinedValue |
  combinedValue := String streamContents: [ :stream |
                       ( self fieldLinesAt: fieldName ) , ( Array with: aValue )
                         do: [ :member | stream nextPutAll: member ]
                         separatedBy: [ stream nextPutAll: ', ' ]
                     ].
  self at: fieldName put: combinedValue
]

{ #category : '*Hyperspace-Extensions' }
ZnHeaders >> fieldLinesAt: fieldName [

  | fieldValue |
  fieldValue := self at: fieldName ifAbsent: [ ^ #(  ) ].
  ^ fieldValue isArray
      ifTrue: [ fieldValue ]
      ifFalse: [ Array with: fieldValue ]
]
