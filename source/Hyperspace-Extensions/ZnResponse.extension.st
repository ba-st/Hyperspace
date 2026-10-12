Extension { #name : 'ZnResponse' }

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> addCachingDirective: aDirective [

  self headers at: 'Cache-Control' addToList: aDirective
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> addLink: aLink [

	self headers at: 'Link' add: aLink
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> addToVary: headerName [

  self headers at: 'Vary' addToList: headerName
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> cachingDirectives [

  | directives |
  directives := OrderedCollection new.
  ( self headers fieldLinesAt: 'Cache-Control' ) do: [ :fieldLine |
      directives addAll: ( CachingDirectivesParser new parse: fieldLine ) ].
  ^ directives asArray
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> entityTag [

	^ (self headers at: 'ETag') asEntityTag
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> hasLocation [

	^ self headers includesKey: 'Location'
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> links [

	| headerValue |

	headerValue := self headers at: 'Link' ifAbsent: [ ^ #() ].
	^ headerValue isArray
		ifTrue: [ headerValue collect: #asWebLink ]
		ifFalse: [ Array with: headerValue asWebLink ]
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> setEntityTag: aStringOrEntityTag [

	self headers at: 'ETag' put: aStringOrEntityTag asEntityTag asString
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> varyHeaderNames [

  | headerNames |
  headerNames := OrderedCollection new.
  ( self headers fieldLinesAt: 'Vary' ) do: [ :fieldLine |
      ( $, split: fieldLine ) do: [ :headerName |
          headerName trimBoth ifNotEmpty: [ :trimmedName | headerNames add: trimmedName ] ]
    ].
  ^ headerNames asArray
]

{ #category : '*Hyperspace-Extensions' }
ZnResponse >> withEntityTagDo: foundBlock ifAbsent: absentBlock [

	self headers at: 'ETag' ifPresent: [ :headerValue | ^ foundBlock cull: headerValue asEntityTag ].
	^ absentBlock value
]
