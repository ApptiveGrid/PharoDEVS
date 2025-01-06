Class {
	#name : 'DESConnection',
	#superclass : 'Object',
	#instVars : [
		'startTime',
		'client',
		'server',
		'state',
		'dataTransferred'
	],
	#category : 'DES-Example',
	#package : 'DES-Example'
}

{ #category : 'as yet unclassified' }
DESConnection class >> startTime: aStartTime client: aClient server: aServer [ 
        ^ self new initialize: aStartTime client: aClient server: aServer.
]

{ #category : 'accessing' }
DESConnection >> client [
	^ client
]

{ #category : 'initialization' }
DESConnection >> dataTransferred [ 
        ^ dataTransferred.
]

{ #category : 'initialization' }
DESConnection >> establishConnection [ 
        state := 'ESTABLISHED'.
]

{ #category : 'initialization' }
DESConnection >> initialize: aStartTime client: aClient server: aServer [ 
        startTime := aStartTime.
        client := aClient.
        server := aServer.
        state := 'SYN_SENT'.
        dataTransferred := 0.
]

{ #category : 'printing' }
DESConnection >> printOn: aStream [ 
	aStream << 'connection: '.
	client printOn: aStream.
	aStream << ' -> '.
	server printOn: aStream.
	aStream << ', state: ' << state 

]

{ #category : 'accessing' }
DESConnection >> server [
	^ server
]

{ #category : 'initialization' }
DESConnection >> terminateConnection [ 
        state := 'CLOSED'.
]

{ #category : 'initialization' }
DESConnection >> transferData: data [ 
        dataTransferred := dataTransferred + data
]
