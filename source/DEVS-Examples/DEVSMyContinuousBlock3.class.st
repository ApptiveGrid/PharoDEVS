"
Atomic DEVnDESS example.
"
Class {
	#name : 'DEVSMyContinuousBlock3',
	#superclass : 'DEVSAtomicDESS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> initConditions [

	self allocateIntegrators: 3.

	intg at: 1 put: 0.1.
	intg at: 2 put: 0.2.
	intg at: 3 put: 0.3.

	self addOutputNPortNamed: #o1.
	self addOutputNPortNamed: #o2.
	self addOutputNPortNamed: #o3.


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> internalTransition [


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> intgStep [

	self intg: 1 integrate: [ 10 * ((intg at: 2) - (intg at: 1)) ].
 	self intg: 2 integrate: [ (1 + 24 - (intg at: 3)) * (intg at: 1) - (intg at: 2) ].
	self intg: 3 integrate: [ ((intg at: 1) * (intg at: 2)) - (2 * (intg at: 3)) ].


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> outputFunction [


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> outputNFnc [

	self poke: (intg at: 1) to: #o1.
	self poke: (intg at: 2) to: #o2.
	self poke: (intg at: 3) to: #o3.


]

{ #category : 'as yet unclassified' }
DEVSMyContinuousBlock3 >> timeAdvance [

	^ Float infinity

]
