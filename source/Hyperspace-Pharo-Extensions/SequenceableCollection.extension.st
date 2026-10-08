Extension { #name : 'SequenceableCollection' }

{ #category : '*Hyperspace-Pharo-Extensions' }
SequenceableCollection >> asEntityTagList [

  ^ EntityTagList fromStrings: self
]
