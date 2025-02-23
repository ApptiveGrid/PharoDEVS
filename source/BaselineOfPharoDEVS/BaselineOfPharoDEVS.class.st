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
				package: 'DEVS-Examples' with: [ spec requires: #('DEVS-Core') ] ]
]
