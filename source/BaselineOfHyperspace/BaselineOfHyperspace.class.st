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
				group: 'Development' with: 'Tests' ].
	spec
		for: #'pharo7.x'
		do: [ spec
				package: 'Hyperspace-Pharo-7';
				group: 'Tests' with: 'Hyperspace-Pharo-7';
				group: 'Deployment' with: 'Hyperspace-Pharo-7'
			]
]

{ #category : #accessing }
BaselineOfHyperspace >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6/source' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ]
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpPackages: spec [

	spec
		package: 'Hyperspace-Model' with: [ spec requires: 'Buoy-Deployment' ];
		group: 'Deployment' with: 'Hyperspace-Model';
		package: 'Hyperspace-Model-Tests'
			with: [ spec requires: #('Hyperspace-Model' 'Dependent-SUnit-Extensions') ];
		group: 'Tests' with: 'Hyperspace-Model-Tests'.

	spec
		package: 'Hyperspace-SUnit-Model';
		group: 'Dependent-SUnit-Extensions' with: 'Hyperspace-SUnit-Model';
		package: 'Hyperspace-SUnit-Tests' with: [ spec requires: 'Hyperspace-SUnit-Model' ];
		group: 'Tests' with: 'Hyperspace-SUnit-Tests'
]
