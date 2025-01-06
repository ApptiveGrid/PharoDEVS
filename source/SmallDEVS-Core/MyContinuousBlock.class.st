"
Atomic DEVnDESS example.
"
Class {
	#name : 'MyContinuousBlock',
	#superclass : 'AtomicDEVnDESS',
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MyContinuousBlock >> initConditions [

	self allocateIntegrators: 2.

	intg at: 1 put: -2.0.
	intg at: 2 put: 2.0.

	self addSECondition: [ intg at: 1 ].

	self addOutputNPortNamed: #o1.
	self addOutputNPortNamed: #o2.

	self addOutputPortNamed: #o3.
	


]

{ #category : 'as yet unclassified' }
MyContinuousBlock >> intTransition [

	
]

{ #category : 'as yet unclassified' }
MyContinuousBlock >> intgStep [

	self intg: 1 integrate: [ intg at: 2 ].
 	self intg: 2 integrate: [ 1.0 * (1.0 - (intg at: 1) squared) * (intg at: 2) - (intg at: 1) ].


]

{ #category : 'as yet unclassified' }
MyContinuousBlock >> outputFnc [

	self poke: #e to: #o3.

]

{ #category : 'as yet unclassified' }
MyContinuousBlock >> outputNFnc [

	self poke: (intg at: 1) to: #o1.
	self poke: (intg at: 2) to: #o2.


]

{ #category : 'as yet unclassified' }
MyContinuousBlock >> timeAdvance [

	^ Float infinity

]
