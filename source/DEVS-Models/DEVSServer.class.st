Class {
	#name : 'DEVSServer',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'messages',
		'port'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'modeling' }
DEVSServer >> externalTransition [ 
	| msg |
	msg := self peekFrom: #in.
	(msg sourceAddress = '10.0.0.1') ifTrue: [  
	messages add: (DEVSNetworkMessage new
		sourceAddress: msg destinationAddress;
		destinationAddress: msg sourceAddress;
		destinationPort: 7003;
		payload: #bar) ].

]

{ #category : 'modeling' }
DEVSServer >> initialize [ 
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	state := #idle.
	messages := OrderedCollection new.
	
]

{ #category : 'modeling' }
DEVSServer >> internalTransition [
	
]

{ #category : 'as yet unclassified' }
DEVSServer >> name: aString [ 
	super name: aString
]

{ #category : 'modeling' }
DEVSServer >> outputFunction [
	messages ifNotEmpty: [  
		self 
			poke: messages removeFirst 
			to: #out ].

]

{ #category : 'accessing' }
DEVSServer >> port [
	^ port
]

{ #category : 'accessing' }
DEVSServer >> port: anInteger [ 
	port := anInteger
]

{ #category : 'actions' }
DEVSServer >> sendMessage: aMessage [ 

	messages add: aMessage 
]

{ #category : 'modeling' }
DEVSServer >> timeAdvance [

	^ messages ifNotEmpty: [ 1 ] ifEmpty: [ self infinityTime ]
]
