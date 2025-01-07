"
AbstractSimulation provides basic means for asynchronous simulation control - see #start, #stop, #rtFactor etc in ""simulation control"" category. A simulation runs as a background process.
A simple simulation run in foreground is also possible via #simulate:.
Subclasses have to specify simulationStep and may specify prepareToStart and prepareToStop.

Subclasses can be put to MyRepository and used in multisimulation experiments.

Note: Since the simulation runs as a sequence of steps, there could be possible to think about an alternative implementation which cyclically performs steps in all simulations in MyRepository - this could be an alternative to to background processes for all simulations. Independent schedulers would be possible. To do (?).  

"
Class {
	#name : 'DEVSAbstractSimulation',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'name',
		'process',
		'idleSemaphore',
		'startStopSemaphore',
		'accessProtect',
		'clock',
		'stopTime',
		'reportStream',
		'verbose'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
}

{ #category : 'private' }
DEVSAbstractSimulation >> accessProtect [

	^accessProtect
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> asyncReset [

	[ self reset ] fork

]

{ #category : 'private' }
DEVSAbstractSimulation >> asyncSafelyDo: aBlock [

	[ self safelyDo: aBlock ] fork
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> asyncStart [

	[ self start ] fork
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> asyncStop [

	[ self stop ] fork
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> asyncStopTime: endTime [

	self asyncSafelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> cancelStopTime [

	self stopTime: Float infinity
]

{ #category : 'simple simulation' }
DEVSAbstractSimulation >> doOneStep [

	self doSteps: 1.
]

{ #category : 'simple simulation' }
DEVSAbstractSimulation >> doSteps: n [

	self stop.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	n timesRepeat: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

	reportStream flush.

]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> fullName [
	^ self name, ' [', (self isRunning ifTrue: ['R'] ifFalse: ['S']) , ']'
]

{ #category : 'private' }
DEVSAbstractSimulation >> initialize [

	self initializeSimulationControl.
	clock ifNil: [ clock := 0 ]. stopTime := Float infinity.

	reportStream := Transcript. verbose := true.

]

{ #category : 'private' }
DEVSAbstractSimulation >> initializeSimulationControl [

	startStopSemaphore := Semaphore new.
	startStopSemaphore signal.							"means that simulator has been requested to stop"
	idleSemaphore := Semaphore new.
	idleSemaphore signal.								"means that simulator is stopped"
	accessProtect := Semaphore forMutualExclusion.		"thread safe start/stop etc."
	process := nil.

]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> isIdle [

	^ idleSemaphore isSignaled
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> isRunning [

	^ startStopSemaphore isSignaled not
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> name [
	^ name
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> name: n [
	name := n
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> parent [
	^ parent
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> parent: p [
	parent := p
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> pathName [
  parent isNil ifTrue: [^''] ifFalse: [^(parent pathName),'/',name].
]

{ #category : 'private' }
DEVSAbstractSimulation >> prepareToStart [

	"Subclasses may define some initalization code."
]

{ #category : 'private' }
DEVSAbstractSimulation >> prepareToStop [

	"Subclasses may define some finalization code."
]

{ #category : 'private' }
DEVSAbstractSimulation >> processBody [

	self prepareToStart.
	[ startStopSemaphore isSignaled ] whileFalse: [ 	
		clock < stopTime 	"clock = stopTime = Float infinity ---> stop non rt sim"
			ifTrue: [ self simulationStep. Processor yield ]
			ifFalse: [ startStopSemaphore signal ] ].
	self prepareToStop.

]

{ #category : 'GUI' }
DEVSAbstractSimulation >> remove [
  (UIManager default confirm: 'Really DELETE simulation?')
  ifTrue: [ parent removeComponents: (Array with: name) ].
]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> reportStream [

	^ reportStream 

]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> reportStream: s [

	self safelyDo: [ reportStream := s ]

]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> reset [

	self stop.
	clock := 0. stopTime := Float infinity.

]

{ #category : 'private' }
DEVSAbstractSimulation >> safelyDo: aBlock [

	| r v |
	accessProtect critical: [
		r := self stopUnprotected.
		v := aBlock value.
		r ifTrue: [ self startUnprotected ] ].
	^ v

]

{ #category : 'simple simulation' }
DEVSAbstractSimulation >> simulate: time [

	stopTime := time.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	[ clock < stopTime ] whileTrue: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

	reportStream flush.

]

{ #category : 'private' }
DEVSAbstractSimulation >> simulationStep [

	self subclassResponsibility

]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> start [

	| r |
	accessProtect critical: [ r := self startUnprotected ].
	^ r

]

{ #category : 'private' }
DEVSAbstractSimulation >> startUnprotected [

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
DEVSAbstractSimulation >> stop [

	^ accessProtect critical: [ 
		self stopUnprotected ].

]

{ #category : 'as yet unclassified' }
DEVSAbstractSimulation >> stopTime [
  ^stopTime
]

{ #category : 'simulation control' }
DEVSAbstractSimulation >> stopTime: endTime [

	self safelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'private' }
DEVSAbstractSimulation >> stopUnprotected [

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
DEVSAbstractSimulation >> timeToShow [
	^ clock 
]
