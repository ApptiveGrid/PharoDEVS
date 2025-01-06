"
AbstractSimulation provides basic means for asynchronous simulation control - see #start, #stop, #rtFactor etc in ""simulation control"" category. A simulation runs as a background process.
A simple simulation run in foreground is also possible via #simulate:.
Subclasses have to specify simulationStep and may specify prepareToStart and prepareToStop.

Subclasses can be put to MyRepository and used in multisimulation experiments.

Note: Since the simulation runs as a sequence of steps, there could be possible to think about an alternative implementation which cyclically performs steps in all simulations in MyRepository - this could be an alternative to to background processes for all simulations. Independent schedulers would be possible. To do (?).  

"
Class {
	#name : 'AbstractSimulation',
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
	#category : 'SmallDEVS-Core',
	#package : 'SmallDEVS-Core'
}

{ #category : 'private' }
AbstractSimulation >> accessProtect [

	^accessProtect
]

{ #category : 'simulation control' }
AbstractSimulation >> asyncReportStream: s [

	self asyncSafelyDo: [ reportStream := s ]

]

{ #category : 'simulation control' }
AbstractSimulation >> asyncReset [

	[ self reset ] fork

]

{ #category : 'private' }
AbstractSimulation >> asyncSafelyDo: aBlock [

	[ self safelyDo: aBlock ] fork
]

{ #category : 'simulation control' }
AbstractSimulation >> asyncStart [

	[ self start ] fork
]

{ #category : 'simulation control' }
AbstractSimulation >> asyncStop [

	[ self stop ] fork
]

{ #category : 'simulation control' }
AbstractSimulation >> asyncStopTime: endTime [

	self asyncSafelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'simulation control' }
AbstractSimulation >> cancelStopTime [

	self stopTime: Float infinity
]

{ #category : 'copying' }
AbstractSimulation >> copy [

	| aCopy |
	self safelyDo: [
		aCopy := self shallowCopy postCopy initializeSimulationControl ].
	^aCopy
]

{ #category : 'GUI' }
AbstractSimulation >> cutAction [
  self copyToClipboard.
  self remove.
]

{ #category : 'copying' }
AbstractSimulation >> doNotStore [
	^{ 'parent'. 'namedComponents'. 'process'. 'idleSemaphore'. 	'startStopSemaphore'. 'accessProtect'.  'reportStream'.  'rtTimer'. 'inputQueue'. 'seQueue'. 			"TO DO: move this to subclasses!!!"  
	}
]

{ #category : 'simple simulation' }
AbstractSimulation >> doOneStep [

	self doSteps: 1.
]

{ #category : 'simple simulation' }
AbstractSimulation >> doSteps: n [

	self stop.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	n timesRepeat: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

	reportStream flush.

]

{ #category : 'as yet unclassified' }
AbstractSimulation >> fullName [
	^ self name, ' [', (self isRunning ifTrue: ['R'] ifFalse: ['S']) , ']'
]

{ #category : 'private' }
AbstractSimulation >> initialize [

	self initializeSimulationControl.
	clock ifNil: [ clock := 0 ]. stopTime := Float infinity.

	reportStream := Transcript. verbose := true.

]

{ #category : 'private' }
AbstractSimulation >> initializeSimulationControl [

	startStopSemaphore := Semaphore new.
	startStopSemaphore signal.							"means that simulator has been requested to stop"
	idleSemaphore := Semaphore new.
	idleSemaphore signal.								"means that simulator is stopped"
	accessProtect := Semaphore forMutualExclusion.		"thread safe start/stop etc."
	process := nil.

]

{ #category : 'simulation control' }
AbstractSimulation >> isIdle [

	^ idleSemaphore isSignaled
]

{ #category : 'simulation control' }
AbstractSimulation >> isRunning [

	^ startStopSemaphore isSignaled not
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> name [
	^ name
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> name: n [
	name := n
]

{ #category : 'GUI' }
AbstractSimulation >> openModel [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> parent [
	^ parent
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> parent: p [
	parent := p
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> pathName [
  parent isNil ifTrue: [^''] ifFalse: [^(parent pathName),'/',name].
]

{ #category : 'private' }
AbstractSimulation >> prepareToStart [

	"Subclasses may define some initalization code."
]

{ #category : 'private' }
AbstractSimulation >> prepareToStop [

	"Subclasses may define some finalization code."
]

{ #category : 'private' }
AbstractSimulation >> processBody [

	self prepareToStart.
	[ startStopSemaphore isSignaled ] whileFalse: [ 	
		clock < stopTime 	"clock = stopTime = Float infinity ---> stop non rt sim"
			ifTrue: [ self simulationStep. Processor yield ]
			ifFalse: [ startStopSemaphore signal ] ].
	self prepareToStop.

]

{ #category : 'GUI' }
AbstractSimulation >> remove [
  (UIManager default confirm: 'Really DELETE simulation?')
  ifTrue: [ parent removeComponents: (Array with: name) ].
]

{ #category : 'as yet unclassified' }
AbstractSimulation >> reportStream [

	reportStream ifNil: [ reportStream := (DummyStream on: nil) ].
	^ reportStream 

]

{ #category : 'simulation control' }
AbstractSimulation >> reportStream: s [

	self safelyDo: [ reportStream := s ]

]

{ #category : 'simulation control' }
AbstractSimulation >> reset [

	self stop.
	clock := 0. stopTime := Float infinity.

]

{ #category : 'private' }
AbstractSimulation >> safelyDo: aBlock [

	| r v |
	accessProtect critical: [
		r := self stopUnprotected.
		v := aBlock value.
		r ifTrue: [ self startUnprotected ] ].
	^ v

]

{ #category : 'simple simulation' }
AbstractSimulation >> simulate: t [

	stopTime := t.
	self prepareToStart.
	startStopSemaphore initSignals.	"running simulation indication"
	[ clock < stopTime ] whileTrue: [ self simulationStep ].
	startStopSemaphore signal.
	self prepareToStop.

	reportStream flush.

]

{ #category : 'private' }
AbstractSimulation >> simulationStep [

	self subclassResponsibility

]

{ #category : 'simulation control' }
AbstractSimulation >> start [

	| r |
	accessProtect critical: [ r := self startUnprotected ].
	^ r

]

{ #category : 'private' }
AbstractSimulation >> startUnprotected [

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
AbstractSimulation >> stop [

	| r |
	accessProtect critical: [ r := self stopUnprotected ].
	^ r

]

{ #category : 'as yet unclassified' }
AbstractSimulation >> stopTime [
  ^stopTime
]

{ #category : 'simulation control' }
AbstractSimulation >> stopTime: endTime [

	self safelyDo: [ stopTime := endTime ]. 				"in seconds"

]

{ #category : 'private' }
AbstractSimulation >> stopUnprotected [

	| r |
	r := false.
	startStopSemaphore isSignaled ifFalse: [
		startStopSemaphore signal.	"A signal to stop."
		idleSemaphore wait.	"Waiting for current step finishing." 
		idleSemaphore initSignals; signal. "Initialize the semaphore."
		r := true ].
	^ r




]

{ #category : 'copying' }
AbstractSimulation >> storeOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' new'.	"initialized instance"
	(self class allInstVarNames difference: self doNotStore) do: [:n |
		aStream nextPutAll: ' instVarNamed: ';
			store: n;
			nextPutAll: ' put: ';
			store: (self instVarNamed: n);
			nextPut: $; ; 
			nextPutAll: String cr ].
	aStream nextPutAll: ' yourself)'; nextPutAll: String cr

]

{ #category : 'GUI' }
AbstractSimulation >> timeToShow [
	^ clock 
]
