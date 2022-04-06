Class {
	#name : #RichTextPresenter,
	#superclass : #Object,
	#category : #'Hyperspace-Development-Tools'
}

{ #category : #rendering }
RichTextPresenter class >> rendering: microdownText [

	| text |

	text := BeautifulComments render: microdownText.

	^ SpMorphPresenter new
		  morph: ( RubScrolledTextMorph new
				    setText: text;
				    wrapped: true;
				    in: [ :this | this textArea readOnly: true ];
				    yourself );
		  yourself
]
