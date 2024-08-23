Extension { #name : 'ZnMessage' }

{ #category : '*Hyperspace-Extensions' }
ZnMessage >> addContentLanguage: aLanguageTag [

	self headers at: 'Content-Language' add: aLanguageTag
]

{ #category : '*Hyperspace-Extensions' }
ZnMessage >> contentLanguageTags [

	| headerValue |

	headerValue := self headers at: 'Content-Language' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asLanguageTag ]
		ifFalse: [ Array with: headerValue asLanguageTag ]
]
