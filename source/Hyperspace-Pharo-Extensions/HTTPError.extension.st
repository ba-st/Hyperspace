Extension { #name : #HTTPError }

{ #category : #'*Hyperspace-Pharo-Extensions' }
HTTPError >> - anotherException [

	^ ExceptionSetWithExclusions new
		  add: self;
		  addExclusion: anotherException;
		  yourself
]
