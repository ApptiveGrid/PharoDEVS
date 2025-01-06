Class {
	#name : 'DESServer',
	#superclass : 'Object',
	#instVars : [
		'serverId',
		'activeConnections'
	],
	#category : 'DES-Example',
	#package : 'DES-Example'
}

{ #category : 'accessing' }
DESServer class >> id: anId [ 
        ^ self new initialize: anId.
]

{ #category : 'as yet unclassified' }
DESServer >> closeConnection: aConnection [ 
        activeConnections remove: aConnection ifAbsent: [].
]

{ #category : 'as yet unclassified' }
DESServer >> diskAccess [ 
        ^ 0.1 + (0.5 * (Random new next)).
]

{ #category : 'initialization' }
DESServer >> initialize: anId [ 
        serverId := anId.
        activeConnections := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
DESServer >> openConnection: aConnection [ 
        activeConnections add: aConnection.
]

{ #category : 'printing' }
DESServer >> printOn: aStream [ 
	aStream << 'server id: ' << serverId printString 
]
