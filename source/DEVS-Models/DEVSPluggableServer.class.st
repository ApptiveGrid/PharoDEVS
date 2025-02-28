"
I represent application server that can consume incoming messages. I have a hook method - a block that is defined outside of me that I can execute during generating output when incoming message is for me. 
"
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

{ #category : 'accessing' }
DEVSPluggableServer >> onIncomingDo: aBlock [ 
	"aBlock that is executed when incoming message is for me"
	block := aBlock
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
