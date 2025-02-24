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
DEVSServer >> initialize [ 
	super initialize.
	
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	
	state := #idle.
	messages := OrderedCollection new.
	
]

{ #category : 'testing' }
DEVSServer >> isIncoming: message [
	^ message destinationAddress = parent address
]

{ #category : 'accessing' }
DEVSServer >> port [
	^ port
]

{ #category : 'accessing' }
DEVSServer >> port: anInteger [ 
	port := anInteger
]

{ #category : 'as yet unclassified' }
DEVSServer >> send: payload to: destinationAddress port: destinationPort [ 
	self sendMessage: (DEVSNetworkMessage new 
			destinationAddress: destinationAddress;
			destinationPort: destinationPort;
			sourceAddress: parent address;
			sourcePort: port;
			payload: payload)
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
