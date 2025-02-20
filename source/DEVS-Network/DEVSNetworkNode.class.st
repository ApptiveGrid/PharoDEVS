Class {
	#name : 'DEVSNetworkNode',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages',
		'routingTable'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSNetworkNode >> externalTransition [

	| msg |
	msg := self peekFrom: #in.
	messages add: msg.
	state := #processing 
]

{ #category : 'modeling' }
DEVSNetworkNode >> initialize [ 
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	state := #idle.
	messages := OrderedCollection new.
	routingTable := Dictionary new
]

{ #category : 'modeling' }
DEVSNetworkNode >> internalTransition [
	messages ifEmpty: [  
		state := #idle ]
]

{ #category : 'modeling' }
DEVSNetworkNode >> outputFunction [
	| msg |
	(state = #processing) ifTrue: [ 
		msg := messages removeFirst.
		self poke: msg to: msg to ].
]

{ #category : 'modeling' }
DEVSNetworkNode >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
