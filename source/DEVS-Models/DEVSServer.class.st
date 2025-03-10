"
I represent simple application server that is part of host. I can receive input messages from input port and sent messages to output port that is identified by my network port number.
"
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

{ #category : 'printing' }
DEVSServer >> printOn: aStream [
	
	aStream << '<'.
	self printPathOn: aStream.
	self port ifNotNil: [:aPort | aStream << ':'; << aPort asString ].
	aStream << '>'
]

{ #category : 'actions' }
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
