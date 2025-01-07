Class {
	#name : 'DEVSTrafficController',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'direction'
	],
	#category : 'DEVS-Examples-crossing',
	#package : 'DEVS-Examples',
	#tag : 'crossing'
}

{ #category : 'modeling' }
DEVSTrafficController >> initialize [
	super initialize.
	direction := #northSouth.
	self addOutputPortNamed: #out
]

{ #category : 'modeling' }
DEVSTrafficController >> intTransition [ 
	
]

{ #category : 'modeling' }
DEVSTrafficController >> outputFnc [
	(direction = #northSouth)
		ifTrue: [   
			self poke: #eastWestGreen to: #out.
			direction := #eastWest ]
		ifFalse: [ 
			self poke: #northSouthGreen to: #out.
			direction := #northSouth ]

]

{ #category : 'modeling' }
DEVSTrafficController >> prepareToStart [  
	
]

{ #category : 'modeling' }
DEVSTrafficController >> timeAdvance [
	^ 60
]
