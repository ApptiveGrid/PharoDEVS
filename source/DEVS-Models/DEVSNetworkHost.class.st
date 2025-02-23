Class {
	#name : 'DEVSNetworkHost',
	#superclass : 'DEVSCoupledComponent',
	#instVars : [
		'hostname',
		'address'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'accessing' }
DEVSNetworkHost >> address [
	^ address
]

{ #category : 'accessing' }
DEVSNetworkHost >> address: aString [ 
	address := aString 
]

{ #category : 'accessing' }
DEVSNetworkHost >> hostname [
	^ hostname
]

{ #category : 'initialization' }
DEVSNetworkHost >> hostname: aString [ 
	hostname := aString
]

{ #category : 'modeling' }
DEVSNetworkHost >> initialize [
	| resolver server |
	super initialize.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
			
	resolver := DEVSHostServiceResolver new name: #resolver.
	self addComponent: resolver.
	7001 to: 7003 do: [ :n |
		server := DEVSServer new
			name:  ('port:', n asString);
			port: n .
		self addComponent: server.
		resolver addServer: server.
		self addCouplings: { 
			{ server name . #out } -> { #self . #out }.
			{ #self . #in } -> { resolver name . #in }.
			{ resolver name . server port } -> { server name . #in } }.
		]
]
