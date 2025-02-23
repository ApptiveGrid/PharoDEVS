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
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
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

{ #category : 'as yet unclassified' }
DEVSHostServiceResolver >> internalTransition [
	messages ifEmpty: [  
		state := #idle ]
]

{ #category : 'modeling' }
DEVSHostServiceResolver >> outputFunction [
	| msg |
	(state = #processing) ifTrue: [ 
		msg := messages removeFirst.
		(msg destinationAddress = parent address)
			ifTrue: [  
				self 
					poke: msg 
					to: (ports at: msg destinationPort) name ]
			ifFalse: [
				self 
					poke: msg 
					to: #out ] ]
]

{ #category : 'as yet unclassified' }
DEVSHostServiceResolver >> timeAdvance [
	^ (state = #processing)
		ifTrue: [ 1 ]
		ifFalse: [ self infinityTime ]
]
