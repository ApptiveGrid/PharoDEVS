"
Atomic DEVnDESS example.
"
Class {
	#name : 'DEVSMyContinuousBlock',
	#superclass : 'AtomicDEVnDESS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> initConditions [

	self allocateIntegrators: 2.

	intg at: 1 put: -2.0.
	intg at: 2 put: 2.0.

	self addSECondition: [ intg at: 1 ].

	self addOutputNPortNamed: #o1.
	self addOutputNPortNamed: #o2.

	self addOutputPortNamed: #o3.
	


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> internalTransition [

	
]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> intgStep [

	self intg: 1 integrate: [ intg at: 2 ].
 	self intg: 2 integrate: [ 1.0 * (1.0 - (intg at: 1) squared) * (intg at: 2) - (intg at: 1) ].


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> outputFunction [

	self poke: #e to: #o3.

]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> outputNFnc [

	self poke: (intg at: 1) to: #o1.
	self poke: (intg at: 2) to: #o2.


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock >> timeAdvance [

	^ Float infinity

]
