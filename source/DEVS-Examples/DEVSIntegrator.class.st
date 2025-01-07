Class {
	#name : 'DEVSIntegrator',
	#superclass : 'DEVSAtomicDESS',
	#instVars : [
		'initCondition',
		'pm'
	],
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSIntegrator class >> newWithInitialCondition: aValue [

	| integrator |
	integrator := self new.
	integrator addInputNPortNamed: #input; addOutputNPortNamed: #output.	
	integrator initCondition: aValue.
	^ integrator
]

{ #category : 'as yet unclassified' }
DEVSIntegrator >> initCondition: aValue [

	initCondition := aValue.
	intg at: 1 put: initCondition.
	self saveState.



]

{ #category : 'as yet unclassified' }
DEVSIntegrator >> initConditions [

	self allocateIntegrators: 1.

]

{ #category : 'as yet unclassified' }
DEVSIntegrator >> intgStep [

	self intg: 1 integrate: [ input values at: 1 ].


]

{ #category : 'as yet unclassified' }
DEVSIntegrator >> outputNFnc [

	self poke: (intg at: 1) to: #output.


]

{ #category : 'as yet unclassified' }
DEVSIntegrator >> timeAdvance [

	^ Float infinity


]
