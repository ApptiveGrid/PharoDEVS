Class {
	#name : 'Integrator',
	#superclass : 'AtomicDEVnDESS',
	#instVars : [
		'initCondition',
		'pm'
	],
	#category : 'SmallDEVS-Core-Continuous',
	#package : 'SmallDEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'as yet unclassified' }
Integrator class >> newWithInitialCondition: aValue [

	| integrator |
	integrator := self new.
	integrator addInputNPortNamed: #input; addOutputNPortNamed: #output.	
	integrator initCondition: aValue.
	^ integrator
]

{ #category : 'as yet unclassified' }
Integrator >> initCondition: aValue [

	initCondition := aValue.
	intg at: 1 put: initCondition.
	self saveState.



]

{ #category : 'as yet unclassified' }
Integrator >> initConditions [

	self allocateIntegrators: 1.

]

{ #category : 'as yet unclassified' }
Integrator >> intgStep [

	self intg: 1 integrate: [ input values at: 1 ].


]

{ #category : 'as yet unclassified' }
Integrator >> outputNFnc [

	self poke: (intg at: 1) to: #output.


]

{ #category : 'as yet unclassified' }
Integrator >> timeAdvance [

	^ Float infinity


]
