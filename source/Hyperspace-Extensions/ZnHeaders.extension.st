Extension { #name : 'ZnHeaders' }

{ #category : '*Hyperspace-Extensions' }
ZnHeaders >> at: fieldName addToList: aValue [

  | combinedValue |
  combinedValue := String streamContents: [ :stream |
                       ( self fieldLinesAt: fieldName ) do: [ :member |
                           stream
                             nextPutAll: member;
                             nextPut: $,;
                             space
                         ].
                       stream nextPutAll: aValue
                     ].
  self at: fieldName put: combinedValue
]

{ #category : '*Hyperspace-Extensions' }
ZnHeaders >> fieldLinesAt: fieldName [

  | fieldValue |
  fieldValue := self at: fieldName ifAbsent: [ ^ #(  ) ].
  ^ fieldValue isArray
      ifTrue: [ fieldValue ]
      ifFalse: [ { fieldValue } ]
]
