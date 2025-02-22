Class {
	#name : 'DEVSTestNetwork',
	#superclass : 'DEVSCoupledComponent',
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSTestNetwork >> initialize [ 
	| serverName network server host |
	super initialize.
	name := 'test network'.
	
	network := DEVSNetworkNode new name: #networknode.
	self addComponent: network.
	1 to: 3 do: [ :n |
		serverName := ('server', n asString).
		host := DEVSNetworkHost new
			name:  ('host:10.0.0.', n asString);
			hostname: 'server', n asString, '.local';
			address: ('10.0.0.', n asString).
		self addComponent: host.
		server := DEVSUDPServer new 
			name: serverName.
		self addComponent: server.
		network addHost: host.
		host addServer: server atPort: 7000.
		
		self addCouplings: { 
			{ host name . #out } -> { network name . #in}.
			{ network name . host address } -> { host name . #in } }
		]
]
