Class {
	#name : 'DEVSNetworkHost',
	#superclass : 'DEVSCoupledComponent',
	#instVars : [
		'address',
		'resolver'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'adding' }
DEVSNetworkHost >> addServer: server [ 
		self addComponent: server.
		
		resolver addServer: server.
		
		self addCouplings: { 
			{ server name . #out } -> { #self . #out }.
			{ #self . #in } -> { resolver name . #in }.
			{ resolver name . server port } -> { server name . #in } }
]

{ #category : 'accessing' }
DEVSNetworkHost >> address [
	^ address
]

{ #category : 'accessing' }
DEVSNetworkHost >> address: aString [ 
	address := aString 
]

{ #category : 'modeling' }
DEVSNetworkHost >> initialize [
	super initialize.
	
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
			
	resolver := DEVSHostServiceResolver new name: #resolver.
	self addComponent: resolver
]
