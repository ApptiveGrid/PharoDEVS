Class {
	#name : 'DEVSHostServiceResolver',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'hostname',
		'address',
		'ports',
		'messages',
		'state'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'adding' }
DEVSHostServiceResolver >> addServer: aServer [ 
	ports 
		at: aServer port 
		put: (self addOutputPortNamed: aServer port )
]

{ #category : 'accessing' }
DEVSHostServiceResolver >> address [
	^ address
]

{ #category : 'accessing' }
DEVSHostServiceResolver >> address: aString [ 
	address := aString 
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> externalTransition [

	| msg |
	msg := self peekFrom: #in.
	messages add: msg.
	state := #processing 
]

{ #category : 'accessing' }
DEVSHostServiceResolver >> hostname [
	^ hostname
]

{ #category : 'initialization' }
DEVSHostServiceResolver >> hostname: aString [ 
	hostname := aString
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> initialize [
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	ports := Dictionary new.
	messages := OrderedCollection new
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> internalTransition [
	messages ifEmpty: [  
		state := #idle ]
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> outputFunction [
	| message |
	(state = #processing) ifTrue: [ 
		message := messages removeFirst.
		self 
			poke: message 
			to: (ports at: message destinationPort) name ]
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
