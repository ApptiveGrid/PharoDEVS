"
I represent echo server just to just return the message I receive. I exchange source and destination information and send it to output port.
"
Class {
	#name : 'DEVSEchoServer',
	#superclass : 'DEVSServer',
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'modeling' }
DEVSEchoServer >> externalTransition [ 
	messages add: (self peekFrom: #in).
	state := #processing
]

{ #category : 'modeling' }
DEVSEchoServer >> internalTransition [ 
	messages ifEmpty: [ 
		state := #idle ]
]

{ #category : 'modeling' }
DEVSEchoServer >> outputFunction [ 
	| message |
	messages ifNotEmpty: [ 
		"an echo server is supposed to just return the message it
		received. We just exchange source and destination information
		and send it back"
		message := messages removeFirst.
		self 
			poke: (DEVSNetworkMessage new 
				destinationAddress: message sourceAddress;
				sourceAddress: message destinationAddress;
				destinationPort: message sourcePort;
				sourcePort: message destinationPort;
				payload: message payload)
			to: #out  ]
]
