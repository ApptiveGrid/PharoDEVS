"
This class needs refactoring!

TO DO:

Move RT scheduling to AbstractSimulation.

Lots of operations are not thread safe !


"
Class {
	#name : 'DEVSRootSolverRT',
	#superclass : 'DEVSRootSolver',
	#instVars : [
		'rtTimer',
		'startTime',
		'inputQueue',
		'seQueue',
		'rtFactor',
		'lastTime'
	],
	#category : 'DEVS-Core-RT',
	#package : 'DEVS-Core',
	#tag : 'RT'
}

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> asyncRtFactor: f [

	self asyncSafelyDo: [ rtFactor := f ]

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> initialize [

	super initialize.	
	inputQueue := SharedQueue new.
	seQueue := SharedQueue new.	
	startTime := Time millisecondClockValue.
	lastTime := startTime.
	rtFactor := 1.


]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> initializeModel [

	super initializeModel.
	inputQueue := SharedQueue new.
	seQueue := SharedQueue new.	
	startTime := Time millisecondClockValue.
	lastTime:=startTime.
	
]

{ #category : 'asynchronous interrupts' }
DEVSRootSolverRT >> inject: value to: port [

	inputQueue isNil ifFalse: [ inputQueue nextPut: { port. value. } ].
	rtTimer isNil ifFalse: [ rtTimer unschedule ].		"wake up"

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> nonRTStep [

	^ super simulationStep

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> prepareToStart [

	rtFactor = 0 
		ifFalse: [ startTime := Time millisecondClockValue - (clock / rtFactor * 1000) ]
		ifTrue: [ startTime := Time millisecondClockValue - (clock  * 1000) ].
	component receiveMsgInitTime: clock.

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> realTime [
	"returns real time in seconds"
	(self isRunning) 
		ifTrue: [ ^ (Time millisecondClockValue - startTime)  * rtFactor / 1000 ]
		ifFalse: [ ^ clock ].

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> receiveMsgSETime: t [
	"nothing to do here"


]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> rtFactor [
  ^rtFactor
]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> rtFactor: f [

	self safelyDo: [ rtFactor := f ]

]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> simulate: t [
	"Performs the simulation. For simulation in background use start/stop instead."

	startTime := Time millisecondClockValue.
	stopTime := t.	"in seconds"
	clock := self realTime min: component timeNext.		"isn't this redundant ???"
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	[ clock <= stopTime ] whileTrue: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

	self finalize.	"stops processes in atomic submodels"


]

{ #category : 'realtime simulation' }
DEVSRootSolverRT >> simulationStep [

	| msg aSubModel duration inputOccured input |

	rtFactor = 0 ifTrue: [ ^ self nonRTStep ].

	"Synchronize with real time"
	rtTimer := DEVSTimer at: ((startTime + ((component timeNext min: stopTime) / rtFactor * 1000)) min: SmallInteger maxVal) rounded.
	rtTimer wait.		"Waiting can be interrupted by asynchronous internal or external event."
	
	startStopSemaphore isSignaled ifTrue: [^self].	"No step, return immediately."

	"Step"
	"TO DO: make it more consistent with other solvers - first accept interrupts, then make discrete step."
	clock := self realTime min: component timeNext. 
	duration := Time millisecondsToRun: [
		inputOccured := false.
		input := Dictionary new.
		[ (msg := inputQueue nextOrNil) == nil ] whileFalse: [ 
			input at: (component inputPortNamed: msg first) put: msg second.
			inputOccured := true ].
		[ (aSubModel := seQueue nextOrNil) == nil ] whileFalse: [ 
			aSubModel sendMsgSETime: clock ].
		inputOccured
		   ifTrue: [
			component receiveMsgX: input time: clock.	 "... put input & update event lists"
			component logIncoming ]
		   ifFalse: [
			((component timeNext - clock) closeTo: 0) 
				ifTrue: [ component receiveMsgStarTime: clock ] "The planned event takes place."	
				ifFalse: []].	 
		component logOutgoing ]

]

{ #category : 'as yet unclassified' }
DEVSRootSolverRT >> startUnprotected [

	super startUnprotected.
	rtFactor = 0 ifTrue: [ process priority: process priority - 1 ].	
	"Non-RT simulation should have lower priority."

]

{ #category : 'asynchronous interrupts' }
DEVSRootSolverRT >> stateEventIn: aSubmodel [

	seQueue isNil ifFalse: [ seQueue nextPut: aSubmodel ].
	rtTimer isNil ifFalse: [ rtTimer unschedule ].		"wake up"

]

{ #category : 'asynchronous interrupts' }
DEVSRootSolverRT >> stopUnprotected [

	| r |
	r := false.
	startStopSemaphore isSignaled ifFalse: [
		startStopSemaphore signal.	"A signal to stop."

		rtTimer isNil ifFalse: [ rtTimer unschedule ].		"wake up"
		lastTime:=Time millisecondClockValue.

		idleSemaphore wait.	"Waiting for current step finishing." 
		idleSemaphore initSignals; signal. "Initialize the semaphore."
		r := true ].
	^ r

]

{ #category : 'as yet unclassified' }
DEVSRootSolverRT >> timeToShow [

	^ rtFactor = 0 ifTrue: [ self time ] ifFalse: [ self realTime ] 	


]
