Class {
	#name : 'DESHttpRequest',
	#superclass : 'Object',
	#instVars : [
		'startTime',
		'client',
		'server',
		'responseTime',
		'statusCode'
	],
	#category : 'DES-Example',
	#package : 'DES-Example'
}

{ #category : 'as yet unclassified' }
DESHttpRequest class >> startTime: aStartTime client: aClient server: aServer [ 
        ^ self new initialize: aStartTime client: aClient server: aServer.
]

{ #category : 'initialization' }
DESHttpRequest >> initialize: aStartTime client: aClient server: aServer [ 
        startTime := aStartTime.
        client := aClient.
        server := aServer.
        responseTime := nil.
        statusCode := 'PENDING'.
]

{ #category : 'accessing' }
DESHttpRequest >> receiveResponseAt: aResponseTime statusCode: aStatusCode [
        responseTime := aResponseTime.
        statusCode := aStatusCode.
]
