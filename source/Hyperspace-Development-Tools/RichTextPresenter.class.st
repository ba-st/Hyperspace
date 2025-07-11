Class {
	#name : 'RichTextPresenter',
	#superclass : 'Object',
	#category : 'Hyperspace-Development-Tools',
	#package : 'Hyperspace-Development-Tools'
}

{ #category : 'rendering' }
RichTextPresenter class >> rendering: microdownText [

  | text |
  text := BeautifulComments render: microdownText.

  ^ RubScrolledTextMorph new
      setText: text;
      wrapped: true;
      in: [ :this | this textArea readOnly: true ];
      yourself
]
