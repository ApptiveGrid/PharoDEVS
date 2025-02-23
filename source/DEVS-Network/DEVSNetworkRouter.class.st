Class {
	#name : 'DEVSNetworkRouter',
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
DEVSNetworkRouter >> addHost: host [
	dns 
		at: host hostname 
		put: host address.
	hostMapping 
		at: host address 
		put: (self addOutputPortNamed: host address ).

]

{ #category : 'modeling' }
DEVSNetworkRouter >> externalTransition [

	| msg |
	msg := self peekFrom: #in.
	messages add: msg.
	state := #processing 
]

{ #category : 'modeling' }
DEVSNetworkRouter >> initialize [ 
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	state := #idle.
	messages := OrderedCollection new.
	dns := Dictionary new.
	hostMapping := Dictionary new
]

{ #category : 'modeling' }
DEVSNetworkRouter >> internalTransition [
	messages ifEmpty: [  
		state := #idle ]
]

{ #category : 'modeling' }
DEVSNetworkRouter >> outputFunction [
	| msg |
	(state = #processing) ifTrue: [ 
		msg := messages removeFirst.
		self poke: msg to: (hostMapping at: msg destinationAddress) name ].
]

{ #category : 'modeling' }
DEVSNetworkRouter >> timeAdvance [
 	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
