Class {
	#name : #ExceptionSelectorSet,
	#superclass : #Object,
	#instVars : [
		'value',
		'suffix',
		'selectors'
	],
	#category : #'Hyperspace-Model-IETF'
}

{ #category : #'exception selector' }
ExceptionSelectorSet >> , exceptionSelector [

	selectors add: exceptionSelector
]

{ #category : #'exception selector' }
ExceptionSelectorSet >> handles: anException [

	^ selectors anySatisfy: [ :selector | selector handles: anException ]
]

{ #category : #initialization }
ExceptionSelectorSet >> initialize [

	super initialize.
	selectors := OrderedCollection new
]
