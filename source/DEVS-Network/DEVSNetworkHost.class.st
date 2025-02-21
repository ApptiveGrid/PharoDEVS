Class {
	#name : 'DEVSNetworkHost',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'hostname',
		'address',
		'ports',
		'messages',
		'state'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'adding' }
DEVSNetworkHost >> addServer: aDEVSUDPServer atPort: anInteger [ 
	| portName |
	portName := 'port_', anInteger asString.
	ports 
		at: anInteger put: (self addOutputPortNamed: portName ).
	parent addCouplings: { 
			{ aDEVSUDPServer name . #out } -> { name . #in}.
			{ name . portName } -> { aDEVSUDPServer name . #in } }
]

{ #category : 'accessing' }
DEVSNetworkHost >> address [
	^ address
]

{ #category : 'accessing' }
DEVSNetworkHost >> address: aString [ 
	address := aString 
]

{ #category : 'modeling' }
DEVSNetworkHost >> externalTransition [

	| msg |
	msg := self peekFrom: #in.
	messages add: msg.
	state := #processing 
]

{ #category : 'accessing' }
DEVSNetworkHost >> hostname [
	^ hostname
]

{ #category : 'initialization' }
DEVSNetworkHost >> hostname: aString [ 
	hostname := aString
]

{ #category : 'modeling' }
DEVSNetworkHost >> initialize [
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	ports := Dictionary new.
	messages := OrderedCollection new
]

{ #category : 'modeling' }
DEVSNetworkHost >> internalTransition [
	messages ifEmpty: [  
		state := #idle ]
]

{ #category : 'modeling' }
DEVSNetworkHost >> outputFunction [
	| msg |
	(state = #processing) ifTrue: [ 
		msg := messages removeFirst.
		(msg destinationAddress = self address)
			ifTrue: [  
				self 
					poke: msg 
					to: (ports at: msg destinationPort) name ]
			ifFalse: [
				self 
					poke: msg 
					to: #out ] ]
]

{ #category : 'modeling' }
DEVSNetworkHost >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
