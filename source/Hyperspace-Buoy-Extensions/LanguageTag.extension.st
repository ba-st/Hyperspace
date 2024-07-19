Extension { #name : 'LanguageTag' }

{ #category : '*Hyperspace-Buoy-Extensions' }
LanguageTag >> asByteArray [

	^ self printString asByteArray
]
