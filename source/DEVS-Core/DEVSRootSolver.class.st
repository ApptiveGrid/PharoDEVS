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

{ #category : 'simulation' }
DEVSRootSolver >> asyncReportStream: s [

	self asyncSafelyDo: [ reportStream := s ]


]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> beVerbose: truefalse [

	verbose := truefalse.
	component beVerbose: truefalse.


]

{ #category : 'modeling' }
DEVSRootSolver >> component [

	^ component



]

{ #category : 'modeling' }
DEVSRootSolver >> component: aComponent [

	component := aComponent.



]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> deepVerbose: truefalse [

	verbose := truefalse.
	component deepVerbose: truefalse.


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
DEVSRootSolver >> reportStream: s [

	self safelyDo: [ reportStream := s ]

]

{ #category : 'simulation' }
DEVSRootSolver >> reset [

	super reset.
	self initializeModel.
]

{ #category : 'modeling' }
DEVSRootSolver >> rootSolver [

	^ self
]

{ #category : 'simulation' }
DEVSRootSolver >> simulationStep [

	clock := component timeNext.
	clock isInfinite ifTrue: [^self].
	reportStream nextPutAll: '****************** time: ', clock printString, String cr.
	component receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
	verbose ifTrue: [
		reportStream nextPutAll: '* Root DEVS Output Port Configuration: ', String cr.
	 	component reportOutputPortConfig ].
	reportStream flush.
	clock := component timeLast.



]

{ #category : 'simulation' }
DEVSRootSolver >> time [

	^ clock

]
