"
Atomic DEVnDESS example.
"
Class {
	#name : #MyContinuousBlock4,
	#superclass : #AtomicDEVnDESS,
	#category : #'SmallDEVS-Core-Examples'
}

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> initConditions [

	self allocateIntegrators: 3.

	intg at: 1 put: 0.1234.
	intg at: 2 put: 0.2.
	intg at: 3 put: 0.1.

	self addOutputNPortNamed: #o1.
	self addOutputNPortNamed: #o2.
	self addOutputNPortNamed: #o3.


]

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> intTransition [


]

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> intgStep [

	self intg: 1 integrate: [ intg at: 2 ].
 	self intg: 2 integrate: [ intg at: 3 ].
	self intg: 3 integrate: [ -0.4 * (intg at: 3) - (intg at: 2) + (0.65 * (intg at: 1) * (1.0 - (intg at: 1) squared)) ].


]

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> outputFnc [


]

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> outputNFnc [

	self poke: (intg at: 1) to: #o1.
	self poke: (intg at: 2) to: #o2.
	self poke: (intg at: 3) to: #o3.


]

{ #category : #'as yet unclassified' }
MyContinuousBlock4 >> timeAdvance [

	^ Float infinity

]
