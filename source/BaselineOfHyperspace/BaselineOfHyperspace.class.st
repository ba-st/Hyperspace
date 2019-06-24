Class {
	#name : #BaselineOfHyperspace,
	#superclass : #BaselineOf,
	#category : #BaselineOfHyperspace
}

{ #category : #baselines }
BaselineOfHyperspace >> baseline: spec [

	<baseline>
	spec
		for: #pharo
		do: [ self
				setUpDependencies: spec;
				setUpPackages: spec.
			spec
				group: 'CI' with: 'Tests';
				group: 'Development' with: 'Tests'
			].

	spec
		for: #'pharo6.x'
		do: [ self initializeHTTPStatusCodes ]
]

{ #category : #'private - baselines' }
BaselineOfHyperspace >> initializeHTTPStatusCodes [

	"Some constants are missing, reinitialize to fix that"

	^ ZnConstants initializeHTTPStatusCodes
]

{ #category : #accessing }
BaselineOfHyperspace >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v5/source' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ]
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpPackages: spec [

	spec
		package: 'Hyperspace-Model' with: [ spec requires: 'Buoy-Deployment' ];
		group: 'Deployment' with: 'Hyperspace-Model'.
	spec
		package: 'Hyperspace-Model-Tests' with: [ spec requires: #('Hyperspace-Model') ];
		group: 'Tests' with: 'Hyperspace-Model-Tests'
]
