"
AbstractSimulation provides basic means for asynchronous simulation control - see #start, #stop, #rtFactor etc in ""simulation control"" category. A simulation runs as a background process.
A simple simulation run in foreground is also possible via #simulate:.
Subclasses have to specify simulationStep and may specify prepareToStart and prepareToStop.

Subclasses can be put to MyRepository and used in multisimulation experiments.

Note: Since the simulation runs as a sequence of steps, there could be possible to think about an alternative implementation which cyclically performs steps in all simulations in MyRepository - this could be an alternative to to background processes for all simulations. Independent schedulers would be possible. To do (?).  

"
Class {
	#name : 'DEVSBasicSolver',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'process',
		'idleSemaphore',
		'startStopSemaphore',
		'accessProtect',
		'clock',
		'stopTime'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'private' }
DEVSBasicSolver >> accessProtect [

	^accessProtect
]

{ #category : 'simulation control' }
DEVSBasicSolver >> asyncReset [

	[ self reset ] fork

]

{ #category : 'private' }
DEVSBasicSolver >> asyncSafelyDo: aBlock [

	[ self safelyDo: aBlock ] fork
]

{ #category : 'simulation control' }
DEVSBasicSolver >> asyncStart [

	[ self start ] fork
]

{ #category : 'simulation control' }
DEVSBasicSolver >> asyncStop [

	[ self stop ] fork
]

{ #category : 'simulation control' }
DEVSBasicSolver >> asyncStopTime: endTime [

	self asyncSafelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'simulation control' }
DEVSBasicSolver >> cancelStopTime [

	self stopTime: Float infinity
]

{ #category : 'simple simulation' }
DEVSBasicSolver >> doOneStep [

	self doSteps: 1.
]

{ #category : 'simple simulation' }
DEVSBasicSolver >> doSteps: n [

	self stop.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	n timesRepeat: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> fullName [
	^ self name, ' [', (self isRunning ifTrue: ['R'] ifFalse: ['S']) , ']'
]

{ #category : 'private' }
DEVSBasicSolver >> initialize [

	self initializeSimulationControl.
	clock ifNil: [ clock := 0 ].
	stopTime := Float infinity
]

{ #category : 'private' }
DEVSBasicSolver >> initializeSimulationControl [

	startStopSemaphore := Semaphore new.
	startStopSemaphore signal.							"means that simulator has been requested to stop"
	idleSemaphore := Semaphore new.
	idleSemaphore signal.								"means that simulator is stopped"
	accessProtect := Semaphore forMutualExclusion.		"thread safe start/stop etc."
	process := nil.

]

{ #category : 'simulation control' }
DEVSBasicSolver >> isIdle [

	^ idleSemaphore isSignaled
]

{ #category : 'simulation control' }
DEVSBasicSolver >> isRunning [

	^ startStopSemaphore isSignaled not
]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> name [
	^ name
]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> name: aString [
	name := aString
]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> parent [
	^ parent
]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> parent: anObject [
	parent := anObject
]

{ #category : 'private' }
DEVSBasicSolver >> prepareToStart [

	"Subclasses may define some initalization code."
]

{ #category : 'private' }
DEVSBasicSolver >> prepareToStop [

	"Subclasses may define some finalization code."
]

{ #category : 'private' }
DEVSBasicSolver >> processBody [

	self prepareToStart.
	[ startStopSemaphore isSignaled ] whileFalse: [ 	
		clock < stopTime 	"clock = stopTime = Float infinity ---> stop non rt sim"
			ifTrue: [ self simulationStep. Processor yield ]
			ifFalse: [ startStopSemaphore signal ] ].
	self prepareToStop.

]

{ #category : 'simulation control' }
DEVSBasicSolver >> reset [

	self stop.
	clock := 0. stopTime := Float infinity.

]

{ #category : 'private' }
DEVSBasicSolver >> safelyDo: aBlock [

	| r v |
	accessProtect critical: [
		r := self stopUnprotected.
		v := aBlock value.
		r ifTrue: [ self startUnprotected ] ].
	^ v

]

{ #category : 'simple simulation' }
DEVSBasicSolver >> simulate: time [

	stopTime := time.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	[ clock < stopTime ] whileTrue: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.
]

{ #category : 'private' }
DEVSBasicSolver >> simulationStep [

	self subclassResponsibility

]

{ #category : 'simulation control' }
DEVSBasicSolver >> start [

	| r |
	accessProtect critical: [ r := self startUnprotected ].
	^ r

]

{ #category : 'private' }
DEVSBasicSolver >> startUnprotected [

	| r |
	r := true.
	startStopSemaphore isSignaled ifTrue: [ "Simulation has been requested to stop recently."
		idleSemaphore wait.		"Ensure that the simulation really does not run."
		startStopSemaphore initSignals.	"Not signaled means the simulation may run."
		process := [ [ self processBody. ] ensure: [ idleSemaphore signal ] ] 
						forkAt: Processor userBackgroundPriority.
		r := false ].
	^ r

]

{ #category : 'simulation control' }
DEVSBasicSolver >> stop [

	^ accessProtect critical: [ 
		self stopUnprotected ].

]

{ #category : 'as yet unclassified' }
DEVSBasicSolver >> stopTime [
  ^stopTime
]

{ #category : 'simulation control' }
DEVSBasicSolver >> stopTime: endTime [

	self safelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'private' }
DEVSBasicSolver >> stopUnprotected [

	| r |
	r := false.
	startStopSemaphore isSignaled ifFalse: [
		startStopSemaphore signal.	"A signal to stop."
		idleSemaphore wait.	"Waiting for current step finishing." 
		idleSemaphore initSignals; signal. "Initialize the semaphore."
		r := true ].
	^ r




]

{ #category : 'GUI' }
DEVSBasicSolver >> timeToShow [
	^ clock 
]
