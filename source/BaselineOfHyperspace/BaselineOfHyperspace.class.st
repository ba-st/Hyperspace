Class {
	#name : #BaselineOfHyperspace,
	#superclass : #BaselineOf,
	#category : #BaselineOfHyperspace
}

{ #category : #baselines }
BaselineOfHyperspace >> baseline: spec [

	<baseline>
	spec for: #pharo do: [ 
		self
			setUpDependencies: spec;
			setUpPackages: spec.

		spec
			group: 'CI' with: 'Tests';
			group: 'Development' with: #( 'Tests' 'Tools' )
		].
	spec for: #'pharo7.x' do: [ 
		spec
			package: 'Hyperspace-Pharo-7';
			group: 'Tests' with: 'Hyperspace-Pharo-7';
			group: 'Deployment' with: 'Hyperspace-Pharo-7'
		].

	spec for: #'pharo10.x' do: [ self setUpPharo10Packages: spec ]
]

{ #category : #accessing }
BaselineOfHyperspace >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpDependencies: spec [

	spec
		baseline: 'Buoy' with: [ spec repository: 'github://ba-st/Buoy:v6' ];
		project: 'Buoy-Deployment' copyFrom: 'Buoy' with: [ spec loads: 'Deployment' ];
		project: 'Buoy-SUnit' copyFrom: 'Buoy' with: [ spec loads: 'Dependent-SUnit-Extensions' ];
		project: 'Buoy-Tools' copyFrom: 'Buoy' with: [ spec loads: 'Tools' ].
	spec
		baseline: 'ZincHTTPComponents' with: [ spec repository: 'github://svenvc/zinc' ];
		project: 'Zinc-Core' copyFrom: 'ZincHTTPComponents' with: [ spec loads: 'Core' ]
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpPackages: spec [

	spec
		package: 'Hyperspace-Model'
		with: [ spec requires: #( 'Buoy-Deployment' 'Zinc-Core' ) ];
		group: 'Deployment' with: 'Hyperspace-Model';
		package: 'Hyperspace-Extensions'
		with: [ spec requires: 'Hyperspace-Model' ];
		group: 'Deployment' with: 'Hyperspace-Extensions';
		package: 'Hyperspace-Pharo-Extensions'
		with: [ spec requires: 'Hyperspace-Model' ];
		group: 'Deployment' with: 'Hyperspace-Pharo-Extensions'.

	spec
		package: 'Hyperspace-Model-Tests' with: [
			spec requires:
					#( 'Hyperspace-Model' 'Hyperspace-Extensions'
					   'Hyperspace-Pharo-Extensions' 'Dependent-SUnit-Extensions' ) ];
		group: 'Tests' with: 'Hyperspace-Model-Tests'.

	spec
		package: 'Hyperspace-SUnit-Model'
		with: [ spec requires: 'Buoy-SUnit' ];
		group: 'Dependent-SUnit-Extensions' with: 'Hyperspace-SUnit-Model';
		package: 'Hyperspace-SUnit-Model-Tests'
		with: [ spec requires: 'Hyperspace-SUnit-Model' ];
		group: 'Tests' with: 'Hyperspace-SUnit-Model-Tests'.

	spec group: 'Tools' with: 'Buoy-Tools'
]

{ #category : #initialization }
BaselineOfHyperspace >> setUpPharo10Packages: spec [

	spec
		package: 'Hyperspace-Development-Tools' with: [ spec requires: 'Hyperspace-Model' ];
		group: 'Tools' with: 'Hyperspace-Development-Tools'
]
