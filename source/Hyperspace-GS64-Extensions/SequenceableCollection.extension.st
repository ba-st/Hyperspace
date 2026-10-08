Extension { #name : #SequenceableCollection }

{ #category : #'*Hyperspace-GS64-Extensions' }
SequenceableCollection >> asEntityTagList [

  ^ EntityTagList fromStrings: self
]
