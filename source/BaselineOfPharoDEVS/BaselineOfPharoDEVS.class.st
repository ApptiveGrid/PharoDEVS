Class {
	#name : 'BaselineOfPharoDEVS',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfPharoDEVS',
	#package : 'BaselineOfPharoDEVS'
}

{ #category : 'baselines' }
BaselineOfPharoDEVS >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				package: 'DEVS-Core';
				package: 'DEVS-Core-Tests' with: [ spec requires: #('DEVS-Core') ];
				package: 'DEVS-Examples' with: [ spec requires: #('DEVS-Core') ];
				package: 'DEVS-Models' with: [ spec requires: #('DEVS-Core') ].
				
			spec 
				group: 'default' with: #('Core' 'Models');
				group: 'Core' with: #('DEVS-Core' 'DEVS-Core-Tests' );
				group: 'Models' with: #('DEVS-Models')]
]
