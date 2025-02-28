Class {
	#name : 'DEVSNetworkMessage',
	#superclass : 'Object',
	#instVars : [
		'payload',
		'sourceAddress',
		'destinationAddress',
		'destinationPort',
		'sourcePort'
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
		<< 'message '
		<< sourceAddress asString 
		<< ':'
		<< sourcePort asString 
		<< ' -> '
		<< destinationAddress asString
		<< ':'
		<< destinationPort asString.
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
DEVSNetworkMessage >> sourcePort [

	^ sourcePort 
]

{ #category : 'accessing' }
DEVSNetworkMessage >> sourcePort: anObject [

	sourcePort := anObject
]
