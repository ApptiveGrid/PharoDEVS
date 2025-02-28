"
A network that is represented by router and hosts. I wire together router with my hosts.
"
Class {
	#name : 'DEVSNetwork',
	#superclass : 'DEVSCoupledComponent',
	#instVars : [
		'router'
	],
	#category : 'DEVS-Models-network',
	#package : 'DEVS-Models',
	#tag : 'network'
}

{ #category : 'examples' }
DEVSNetwork class >> example [

	<example>
   "discrete event time simulation of network of UDP servers and network node sending UDP packets (messages)"
   DEVSSimulation new 
		model: (self new name: 'UDP network simulation');
		coordinator: DEVSRootSolver new;
		runTo: 10;
		logger
]

{ #category : 'modeling' }
DEVSNetwork >> addHost: host [ 
	
	"add as model for DEVS"
	self addComponent: host.
	
	router addHost: host.
	
	self addCouplings: { 
		{ host name . #out } -> { router name . #in}.
		{ router name . host address } -> { host name . #in } }
]

{ #category : 'modeling' }
DEVSNetwork >> initialize [ 
	super initialize.
	
	router := DEVSNetworkRouter new name: #router.
	self addComponent: router.
]
