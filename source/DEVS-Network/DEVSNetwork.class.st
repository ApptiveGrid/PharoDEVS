Class {
	#name : 'DEVSNetwork',
	#superclass : 'DEVSCoupledComponent',
	#category : 'DEVS-Network',
	#package : 'DEVS-Network'
}

{ #category : 'modeling' }
DEVSNetwork >> initialize [ 
	| serverName router host |
	super initialize.
	
	router := DEVSNetworkRouter new name: #router.
	self addComponent: router.
	1 to: 3 do: [ :n |
		serverName := ('server', n asString).
		host := DEVSNetworkHost new
			name:  ('host:10.0.0.', n asString);
			hostname: 'server', n asString, '.local';
			address: ('10.0.0.', n asString).
		self addComponent: host.
		router addHost: host.
		
		self addCouplings: { 
			{ host name . #out } -> { router name . #in}.
			{ router name . host address } -> { host name . #in } }.
		]
]
