"
I route incoming messages from hosts (its servers) to other hosts that is identified by IP address. 
"
Class {
	#name : 'DEVSNetworkRouter',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages',
		'hostMapping'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'adding' }
DEVSNetworkRouter >> addHost: host [
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
	state = #processing ifFalse: [ ^ self ].
	msg := messages removeFirst.
	self poke: msg to: (hostMapping at: msg destinationAddress) name
]

{ #category : 'modeling' }
DEVSNetworkRouter >> timeAdvance [

 	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
