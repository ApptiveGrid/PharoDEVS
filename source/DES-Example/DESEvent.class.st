Class {
	#name : 'DESEvent',
	#superclass : 'Object',
	#instVars : [
		'time',
		'eventType',
		'connection',
		'request'
	],
	#category : 'DES-Example',
	#package : 'DES-Example'
}

{ #category : 'as yet unclassified' }
DESEvent class >> time: aTime type: anEventType connection: aConnection request: aRequest [
	^ self new initialize: aTime type: anEventType connection: aConnection request: aRequest.
]

{ #category : 'accessing' }
DESEvent >> < aEvent [
        ^ time < aEvent time.
]

{ #category : 'accessing' }
DESEvent >> connection [ 
        ^ connection.
]

{ #category : 'accessing' }
DESEvent >> eventType [
        ^ eventType.
]

{ #category : 'initialization' }
DESEvent >> initialize: aTime type: anEventType connection: aConnection request: aRequest [ 
        time := aTime.
        eventType := anEventType.
        connection := aConnection.
        request := aRequest.
]

{ #category : 'printing' }
DESEvent >> printOn: aStream [ 
	aStream << 'event: ' << eventType printString 
]

{ #category : 'accessing' }
DESEvent >> request [ 
        ^ request.
]

{ #category : 'accessing' }
DESEvent >> time [ 
        ^ time.
]
