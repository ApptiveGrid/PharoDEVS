Class {
	#name : 'DEVSTrafficController',
	#superclass : 'DEVSAtomic',
	#instVars : [
		'direction'
	],
	#category : 'DEVS-Examples-traffic-system',
	#package : 'DEVS-Examples',
	#tag : 'traffic-system'
}

{ #category : 'modeling' }
DEVSTrafficController >> initialize [
	super initialize.
	direction := #northSouth.
	self addOutputPortNamed: #out
]

{ #category : 'modeling' }
DEVSTrafficController >> internalTransition [ 
	
]

{ #category : 'modeling' }
DEVSTrafficController >> outputFunction [
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
