Class {
	#name : 'DEVSTestNetwork',
	#superclass : 'DEVSCoupledComponent',
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSTestNetwork >> initialize [ 
	| serverName network server |
	super initialize.
	
	network := DEVSNetworkNode new name: #networknode.
	self addComponent: network.
	1 to: 3 do: [ :n |
		serverName := ('server', n asString).
		server := DEVSUDPServer new 
			name: serverName;
			hostname: 'server', n asString, '.local';
			address: ('10.0.0.', n asString).
		self addComponent: server.
		network addServer: server ]
]
