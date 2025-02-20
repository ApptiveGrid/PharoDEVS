Class {
	#name : 'DEVSUDPServer',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'address',
		'messages'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'accessing' }
DEVSUDPServer >> address [
	^ address
]

{ #category : 'accessing' }
DEVSUDPServer >> address: aString [ 
	address := aString.
	(address endsWith: '1') ifTrue: [ 
		messages add: (DEVSNetworkMessage new 
				from: name;
				to: 'server3';
				payload: #foo)  ]
]

{ #category : 'modeling' }
DEVSUDPServer >> externalTransition [ 
	| msg |
	msg := self peekFrom: #in.
	(msg from = '10.0.0.1') ifTrue: [  
	messages add: (DEVSNetworkMessage new
		from: msg to;
		to: msg from;
		payload: #bar) ].

]

{ #category : 'modeling' }
DEVSUDPServer >> initialize [ 
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	state := #idle.
	messages := OrderedCollection new.
	
]

{ #category : 'modeling' }
DEVSUDPServer >> internalTransition [
	
]

{ #category : 'modeling' }
DEVSUDPServer >> outputFunction [
	messages ifNotEmpty: [  
		self 
			poke: messages removeFirst 
			to: #out ].

]

{ #category : 'modeling' }
DEVSUDPServer >> timeAdvance [

	^ messages ifNotEmpty: [ 1 ] ifEmpty: [ self infinityTime ]
]
