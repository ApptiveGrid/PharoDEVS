Class {
	#name : 'DEVSUDPServer',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSUDPServer >> externalTransition [ 
	| msg |
	msg := self peekFrom: #in.
	(msg sourceAddress = '10.0.0.1') ifTrue: [  
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

{ #category : 'as yet unclassified' }
DEVSUDPServer >> name: aString [ 
	super name: aString.
	(aString endsWith: '1') ifTrue: [ 
		messages add: (DEVSNetworkMessage new 
				sourceAddress: name;
				destinationAddress: '10.0.0.3';
				destinationPort: 7000;
				payload: #foo)  ]
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
