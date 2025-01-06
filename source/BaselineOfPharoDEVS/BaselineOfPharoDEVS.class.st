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
				package: 'SmallDEVS-Core';
				package: 'DES-Example' ]
]
