Class {
	#name : 'DEVSRootSolver',
	#superclass : 'DEVSBasicSolver',
	#instVars : [
		'component'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'modeling' }
DEVSRootSolver >> component [

	^ component



]

{ #category : 'modeling' }
DEVSRootSolver >> component: aComponent [

	component := aComponent.



]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> doSteps: n [

	| tmp |
	tmp := self rtFactor.
	self rtFactor: 0.
	super doSteps: n.
	self rtFactor: tmp.

]

{ #category : 'modeling' }
DEVSRootSolver >> initializeModel [

	"let's initialize the model"
	component reset.	

	"let's initilalize simulation as well"
	clock := 0. stopTime := Float infinity.
	component receiveMsgInitTime: clock.	"it also starts processes in atomic devses"
	component receiveMsgSyncTime: clock.				"here we stop them"

	

]

{ #category : 'simulation' }
DEVSRootSolver >> prepareToStart [

	component receiveMsgInitTime: clock.

]

{ #category : 'simulation' }
DEVSRootSolver >> prepareToStop [

	component receiveMsgSyncTime: clock.

]

{ #category : 'simulation' }
DEVSRootSolver >> reset [

	super reset.
	self initializeModel.
]

{ #category : 'simulation' }
DEVSRootSolver >> simulationStep [

	clock := self component timeNext.
	clock isInfinite ifTrue: [^self].
	component receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
	
	component logOutgoing.
	clock := component timeLast.



]

{ #category : 'simulation' }
DEVSRootSolver >> time [

	^ clock

]
