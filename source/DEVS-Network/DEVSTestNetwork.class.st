Class {
	#name : 'DEVSTestNetwork',
	#superclass : 'DEVSCoupledComponent',
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSTestNetwork >> initialize [ 
	| serverName node server |
	super initialize.
	
	node := DEVSNetworkNode new name: #networknode.
	self addComponent: node.
	1 to: 3 do: [ :n |
		serverName := ('server', n asString).
		server := DEVSUDPServer new 
			name: serverName;
			address: ('10.0.0.', n asString).
		self addComponent: server.
		node addOutputPortNamed: serverName.
		self addCouplings: { 
			{ serverName . #out } -> #(networknode in).
			{ #networknode . serverName } -> { serverName . #in } } ].

]
