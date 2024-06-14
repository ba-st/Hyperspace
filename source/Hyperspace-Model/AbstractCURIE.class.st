Class {
	#name : 'AbstractCURIE',
	#superclass : 'Object',
	#category : 'Hyperspace-Model',
	#package : 'Hyperspace-Model'
}

{ #category : 'instance creation' }
AbstractCURIE class >> fromString: string [

  ^ self subclassResponsibility
]

{ #category : 'testing' }
AbstractCURIE class >> isAbstract [

  ^ self = AbstractCURIE
]

{ #category : 'instance creation' }
AbstractCURIE class >> prefixedBy: aPrefix referencing: aRelativeUrl [

  ^ self subclassResponsibility
]

{ #category : 'converting' }
AbstractCURIE >> / object [

  ^ self class prefixedBy: self prefix referencing: self relativeReference / object
]

{ #category : 'converting' }
AbstractCURIE >> asSafeCURIE [

  ^ self subclassResponsibility
]

{ #category : 'converting' }
AbstractCURIE >> asWebLink [

  ^ WebLink to: self
]

{ #category : 'converting' }
AbstractCURIE >> expandToURIIn: context [

  | base |
  base := context
            at: self prefix
            ifAbsent: [
              ObjectNotFound signal: ( 'Missing namespace "<1s>"' expandMacrosWith: self prefix ) ].

  ^ base / self relativeReference expandToURIIn: context
]

{ #category : 'accessing' }
AbstractCURIE >> prefix [

  ^ self subclassResponsibility
]

{ #category : 'accessing' }
AbstractCURIE >> relativeReference [

  ^ self subclassResponsibility
]

{ #category : 'converting' }
AbstractCURIE >> withFragment: fragment [

  ^ self class
      prefixedBy: self prefix
      referencing: ( self relativeReference withFragment: fragment )
]
