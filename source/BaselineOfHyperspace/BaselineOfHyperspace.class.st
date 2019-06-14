Class {
	#name : #BaselineOfHyperspace,
	#superclass : #Object,
	#category : #BaselineOfHyperspace
}

{ #category : #baselines }
BaselineOfHyperspace >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ 
			self setUpPackages: spec.
			spec
				group: 'CI' with: 'Tests';
				group: 'Development' with: 'Tests'
			]
]

{ #category : #accessing }
BaselineOfHyperspace >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpPackages: spec [

	spec
		package: 'Hyperspace-Model';
		group: 'Deployment' with: 'Hyperspace-Model'.
	spec
		package: 'Hyperspace-Model-Tests' with: [ spec requires: #('Hyperspace-Model') ];
		group: 'Tests' with: 'Hyperspace-Model-Tests'
]
