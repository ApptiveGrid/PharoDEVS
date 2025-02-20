Class {
	#name : 'DEVSNetworkMessage',
	#superclass : 'Object',
	#instVars : [
		'from',
		'to',
		'payload'
	],
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'accessing' }
DEVSNetworkMessage >> from [

	^ from
]

{ #category : 'accessing' }
DEVSNetworkMessage >> from: anObject [

	from := anObject
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
	from printOn: aStream.
	aStream << ' -> '.
	to printOn: aStream.
	aStream << ', payload: '.
	payload printOn: aStream 
]

{ #category : 'accessing' }
DEVSNetworkMessage >> to [

	^ to
]

{ #category : 'accessing' }
DEVSNetworkMessage >> to: anObject [

	to := anObject
]
