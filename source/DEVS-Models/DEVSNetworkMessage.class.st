Class {
	#name : 'DEVSNetworkMessage',
	#superclass : 'Object',
	#instVars : [
		'payload',
		'sourceAddress',
		'sourePort',
		'destinationAddress',
		'destinationPort'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'accessing' }
DEVSNetworkMessage >> destinationAddress [

	^ destinationAddress
]

{ #category : 'accessing' }
DEVSNetworkMessage >> destinationAddress: anObject [

	destinationAddress := anObject
]

{ #category : 'accessing' }
DEVSNetworkMessage >> destinationPort [

	^ destinationPort
]

{ #category : 'accessing' }
DEVSNetworkMessage >> destinationPort: anObject [

	destinationPort := anObject
]

{ #category : 'accessing' }
DEVSNetworkMessage >> payload [

	^ payload
]

{ #category : 'accessing' }
DEVSNetworkMessage >> payload: anObject [

	payload := anObject
]

{ #category : 'printing' }
DEVSNetworkMessage >> printOn: aStream [ 
	aStream 
		<< 'message '.
	sourceAddress printOn: aStream.
	aStream << ' -> '.
	destinationAddress printOn: aStream.
	aStream << ', payload: '.
	payload printOn: aStream 
]

{ #category : 'accessing' }
DEVSNetworkMessage >> sourceAddress [

	^ sourceAddress
]

{ #category : 'accessing' }
DEVSNetworkMessage >> sourceAddress: anObject [

	sourceAddress := anObject
]

{ #category : 'accessing' }
DEVSNetworkMessage >> sourePort [

	^ sourePort
]

{ #category : 'accessing' }
DEVSNetworkMessage >> sourePort: anObject [

	sourePort := anObject
]
