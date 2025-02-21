Class {
	#name : 'DEVSNetworkNode',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages',
		'dns',
		'outputPortMapping'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'adding' }
DEVSNetworkNode >> addServer: aDEVSUDPServer [
	| portName |
	dns at: aDEVSUDPServer hostname put: aDEVSUDPServer address.
	portName := 'out_', aDEVSUDPServer address asString.
	outputPortMapping at: aDEVSUDPServer address put: (self addOutputPortNamed: portName ).
	parent addCouplings: { 
			{ aDEVSUDPServer name . #out } -> { name . #in}.
			{ name . portName } -> { aDEVSUDPServer name . #in } }
]

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
	dns := Dictionary new.
	outputPortMapping := Dictionary new
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
		self poke: msg to: (outputPortMapping at: msg to) name ].
]

{ #category : 'modeling' }
DEVSNetworkNode >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
