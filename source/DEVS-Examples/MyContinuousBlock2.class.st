"
Atomic DEVnDESS example.
"
Class {
	#name : 'MyContinuousBlock2',
	#superclass : 'AtomicDEVnDESS',
	#category : 'DEVS-Examples',
	#package : 'DEVS-Examples'
}

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> initConditions [

	self allocateIntegrators: 2.
	intg at: 1 put: 1.0.
	intg at: 2 put: 0.0.

	self addSECondition: [ intg at: 1 ].

	self addOutputNPortNamed: #o1.
	self addOutputNPortNamed: #o2.
	self addOutputPortNamed: #o3.


]

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> intTransition [

	sePolarity < 0 ifFalse: [ ^self ].
	
	intg at: 1 put: 0.0.
	intg at: 2 put: -0.8 * (intg at: 2).
	self saveState. "is it needed??"
	
]

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> intgStep [

	self intg: 1 integrate: [ intg at: 2 ].
 	self intg: 2 integrate: [ -9.81 * 1 ].


]

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> outputFnc [

	self poke: #e to: #o3.

]

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> outputNFnc [

	self poke: (intg at: 1) to: #o1.
	self poke: (intg at: 2) to: #o2.


]

{ #category : 'as yet unclassified' }
MyContinuousBlock2 >> timeAdvance [

	^ Float infinity

]
