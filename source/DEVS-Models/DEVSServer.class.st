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
	"this does nothing for now"
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

	^ messages 
		ifNotEmpty: [ 1 ] 
		ifEmpty: [ self infinityTime ]
]
