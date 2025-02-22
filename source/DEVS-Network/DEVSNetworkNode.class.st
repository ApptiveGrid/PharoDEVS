Class {
	#name : 'DEVSNetworkNode',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages',
		'dns',
		'hostMapping'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'adding' }
DEVSNetworkNode >> addHost: host [
	| hostPortName |
	dns at: host hostname put: host address.
	hostPortName := host address asString.
	hostMapping 
		at: host address 
		put: (self addOutputPortNamed: hostPortName ).

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
	hostMapping := Dictionary new
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
		self poke: msg to: (hostMapping at: msg destinationAddress) name ].
]

{ #category : 'modeling' }
DEVSNetworkNode >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
