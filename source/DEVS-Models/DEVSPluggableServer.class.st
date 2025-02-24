Class {
	#name : 'DEVSPluggableServer',
	#superclass : 'DEVSServer',
	#instVars : [
		'block'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'accessing' }
DEVSPluggableServer >> block: aBlock [ 
	block := aBlock
]

{ #category : 'modeling' }
DEVSPluggableServer >> externalTransition [ 
	messages add: (self peekFrom: #in).
	state := #processing
]

{ #category : 'modeling' }
DEVSPluggableServer >> internalTransition [ 
	messages ifEmpty: [ 
		state := #idle ]
]

{ #category : 'modeling' }
DEVSPluggableServer >> outputFunction [ 
	| message |
	messages ifNotEmpty: [
		message := messages removeFirst. 
		(self isIncoming: message)
			ifTrue: [ 
				(block 
					cull: message 
					cull: self)
					ifNotNil: [ :reply | 
						self 
							poke: reply
							to: #out  ] ]
			ifFalse: [ 
				self 
					poke: message
					to: #out ] ]
]
