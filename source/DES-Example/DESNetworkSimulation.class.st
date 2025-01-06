Class {
	#name : 'DESNetworkSimulation',
	#superclass : 'Object',
	#instVars : [
		'currentTime',
		'endTime',
		'eventQueue',
		'servers',
		'connections',
		'requests'
	],
	#category : 'DES-Example',
	#package : 'DES-Example'
}

{ #category : 'as yet unclassified' }
DESNetworkSimulation class >> endTime: anEndTime servers: aServers [
        ^ self new initialize: anEndTime servers: aServers.
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleDiskAccess: anEvent [ 
        | dataTransferTime |
        dataTransferTime := currentTime + (0.1 + (1 * (Random new next))).
        self scheduleEvent: (DESEvent time: dataTransferTime type: #tcpDataTransfer connection: anEvent connection request: anEvent request).
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleHttpRequestSend: anEvent [ 
        | client server request connection handshakeTime |
        client := servers at: ((servers size atRandom)).
        server := servers at: ((servers size atRandom)).
        
        request := DESHttpRequest startTime: currentTime client: client server: server.
        requests add: request.
        
        connection := DESConnection startTime: currentTime client: client server: server.
        connections add: connection.
        client openConnection: connection.

        handshakeTime := currentTime + (0.1 + (1 * (Random new next))).
        self scheduleEvent: (DESEvent time: handshakeTime type: #tcpConnectionStart connection: connection request: request).
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleHttpResponseSend: anEvent [ 
        anEvent request receiveResponseAt: currentTime statusCode: 200.
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleTcpConnectionStart: anEvent [ 
        | diskTime |
        anEvent connection establishConnection.
        
        diskTime := currentTime + (anEvent connection server diskAccess).
        self scheduleEvent: (DESEvent time: diskTime type: #diskAccess connection: anEvent connection request: anEvent request).
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleTcpConnectionTerminate: anEvent [
        | responseTime |
        anEvent connection terminateConnection.
        anEvent connection client closeConnection: anEvent connection.

        responseTime := currentTime + (0.05 + (0.1 * (Random new next))).
        self scheduleEvent: (DESEvent time: responseTime type: #httpResponseSend connection: nil request: anEvent request).
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> handleTcpDataTransfer: anEvent [ 
        | terminateTime dataSize |
        dataSize := 100 + (900 * (Random new next)) rounded.
        anEvent connection transferData: dataSize.

        terminateTime := currentTime + (0.1 + (0.3 * (Random new next))).
        self scheduleEvent: (DESEvent time: terminateTime type: #tcpConnectionTerminate connection: anEvent connection request: anEvent request).
]

{ #category : 'initialization' }
DESNetworkSimulation >> initialize: anEndTime servers: aServers [ 
        currentTime := 0.
        endTime := anEndTime.
        eventQueue := OrderedCollection new.
        servers := aServers.
        connections := OrderedCollection new.
        requests := OrderedCollection new.
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> run [ 
        self scheduleEvent: (DESEvent time: 0 type: #httpRequestSend connection: nil request: nil).

        [ eventQueue isEmpty not and: [ currentTime < endTime ] ] whileTrue: [
            | event |
            event := eventQueue removeFirst.
            currentTime := event time.

            (event eventType = #httpRequestSend) ifTrue: [ self handleHttpRequestSend: event ].
            (event eventType = #tcpConnectionStart) ifTrue: [ self handleTcpConnectionStart: event ].
            (event eventType = #tcpDataTransfer) ifTrue: [ self handleTcpDataTransfer: event ].
            (event eventType = #diskAccess) ifTrue: [ self handleDiskAccess: event ].
            (event eventType = #tcpConnectionTerminate) ifTrue: [ self handleTcpConnectionTerminate: event ].
            (event eventType = #httpResponseSend) ifTrue: [ self handleHttpResponseSend: event ].
        ].
]

{ #category : 'as yet unclassified' }
DESNetworkSimulation >> scheduleEvent: anEvent [
        eventQueue add: anEvent.
]
