Class {
	#name : 'DEVSComponent',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'inputPorts',
		'outputPorts',
		'input',
		'output',
		'timeLast',
		'timeNext',
		'name'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSComponent class >> displayLabel [ 
	self subclassResponsibility 
]

{ #category : 'as yet unclassified' }
DEVSComponent class >> newSimulator [

	^ self new newSimulator

]

{ #category : 'as yet unclassified' }
DEVSComponent class >> newSimulatorRT [

	^ self new newSimulatorRT

]

{ #category : 'modeling' }
DEVSComponent >> addInputPortNamed: n [

	^ self 
		addInputPortOfType: DEVSInputPort 
		named: n
]

{ #category : 'private' }
DEVSComponent >> addInputPortOfType: inputPortClass named: aString [

	| port |
	port := inputPortClass 
		hostDEVS: self 
		name: aString.
		
	inputPorts 
		at: aString 
		put: port.
		
	^ port
]

{ #category : 'modeling2' }
DEVSComponent >> addInputPorts: aCollection [

	aCollection do: [ :p | self addInputPortNamed: p ].

]

{ #category : 'modeling' }
DEVSComponent >> addOutputPortNamed: n [

	^ self addOutputPortOfType: DEVSOutputPort named: n
]

{ #category : 'private' }
DEVSComponent >> addOutputPortOfType: portClass named: n [

	| port |
	port := portClass hostDEVS: self name: n.
	outputPorts at: n put: port.
	^ port
]

{ #category : 'modeling2' }
DEVSComponent >> addOutputPorts: list [

	list do: [ :p | self addOutputPortNamed: p ].

]

{ #category : 'as yet unclassified' }
DEVSComponent >> buildName [
	^ UUID new asString36 
]

{ #category : 'modeling2' }
DEVSComponent >> componentNames [
  ^Array new
]

{ #category : 'announcer' }
DEVSComponent >> emitEvent: anAnnouncement [ 
	self simulation emitEvent: anAnnouncement 
]

{ #category : 'accessing' }
DEVSComponent >> incomingValues [ 
	| dict |
	dict := Dictionary new.
	inputPorts keysAndValuesDo: [ :label :port |
		dict 
			at: label
			put: (input at: port ifAbsent: nil) ].
	^ dict 
]

{ #category : 'accessing' }
DEVSComponent >> infinityTime [
	^ Float infinity 
]

{ #category : 'modeling' }
DEVSComponent >> initialize [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.
	input := Dictionary new.
	output := Dictionary new.

	timeLast := 0.
	timeNext := Float infinity.


]

{ #category : 'misc' }
DEVSComponent >> initializeModel [

	^ self
]

{ #category : 'misc' }
DEVSComponent >> input [
	^input
]

{ #category : 'misc' }
DEVSComponent >> input: i [
	input := i
]

{ #category : 'modeling' }
DEVSComponent >> inputPortNamed: n [
	
	^  inputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
DEVSComponent >> inputPortNames [
  ^self inputPorts collect: [:ip | ip name]
]

{ #category : 'modeling' }
DEVSComponent >> inputPorts [

	^ inputPorts values

]

{ #category : 'misc' }
DEVSComponent >> isRoot [
	^ parent isNil 
]

{ #category : 'as yet unclassified' }
DEVSComponent >> logIncoming [
	self emitEvent: (DEVSExternalTransitionEvent new 
		component: self;
		incoming: self incomingValues;
		timeNext: timeNext
		).
]

{ #category : 'as yet unclassified' }
DEVSComponent >> logOutgoing [
	self emitEvent: (DEVSInternalTransitionEvent new 
		component: self;
		outgoing: self outgoingValues;
		timeNext: timeNext
		).
]

{ #category : 'as yet unclassified' }
DEVSComponent >> name [

	^ name ifNil: [ 
		name := self buildName ]
]

{ #category : 'as yet unclassified' }
DEVSComponent >> name: n [

	name := n. 
]

{ #category : 'simulation' }
DEVSComponent >> newSimulator [

	^ DEVSRootSolver new 
		component: self;
		yourself 
]

{ #category : 'simulation' }
DEVSComponent >> newSimulatorRT [

	^ DEVSRootSolverRT new 
		component: self;
		yourself
]

{ #category : 'accessing' }
DEVSComponent >> outgoingValues [ 
	| dict |
	dict := Dictionary new.
	outputPorts keysAndValuesDo: [ :label :port |
		dict 
			at: label
			put: (output at: port ifAbsent: nil) ].
	^ dict 
]

{ #category : 'misc' }
DEVSComponent >> output [
	^output
]

{ #category : 'misc' }
DEVSComponent >> output: o [
	output := o
]

{ #category : 'modeling' }
DEVSComponent >> outputPortNamed: n [

	^  outputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
DEVSComponent >> outputPortNames [
  ^self outputPorts collect: [:op | op name]
]

{ #category : 'modeling' }
DEVSComponent >> outputPorts [

	^ outputPorts values

]

{ #category : 'modeling' }
DEVSComponent >> parent [

	^ parent

]

{ #category : 'modeling' }
DEVSComponent >> parent: p [

	parent := p

]

{ #category : 'printing' }
DEVSComponent >> path [ 
	^ String streamContents: [ :stream |
		self printPathOn: stream ]
]

{ #category : 'port accessing' }
DEVSComponent >> peekFrom: p [
	| port |
	(port := (self inputPortNamed: p)) ifNil: [self error: 'port not found'].
	^ input at: port ifAbsent: [ nil ]
]

{ #category : 'port accessing' }
DEVSComponent >> poke: x to: p [
	| port |
	(port := (self outputPortNamed: p)) ifNil: [self error: 'port not found'].
	output at: port  put: x
]

{ #category : 'printing' }
DEVSComponent >> printOn: aStream [
	aStream << '<'.
	self printPathOn: aStream.
	aStream << '>'
]

{ #category : 'printing' }
DEVSComponent >> printPathOn: aStream [ 
	parent ifNotNil: [ 
		parent printPathOn: aStream. 
		aStream << '/' ].
	self name 
		ifNotNil: [ aStream << self name asString ]
		ifNil: [ super printOn: aStream ]

]

{ #category : 'simulation' }
DEVSComponent >> receiveMsgSyncTime: t [

	"See subclasses. MsgSync prepares atomic models to receive MsgInit safely during simulation. It updates elapsed time of atomic models. This is used before cloning, removing, and adding submodels during simulation. MsgInit uses saved value if timeAdvance for sure (it eases random generation of timeAdvance because timeAdvenace is not invocated more then once at a time).

(Things like this were not mentioned neither in [Uhrmacher:JAMES] nor [Kim&Kim] both dealing with dynamic modification of a model during simulation. JAMES initalizes only new components (model migration is not explicitly dealt with), Kim uses message Query, no Init (?), so elapsed time is not maintained (?). Theoretically it is possible to modify Kim's approach (MsgQuery) to deal with elapsed time instead of introducing MsgSync (?).)"



]

{ #category : 'modeling' }
DEVSComponent >> removeAllPorts [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.

]

{ #category : 'modeling' }
DEVSComponent >> removeInputPortNamed: n [

	inputPorts removeKey: n.

]

{ #category : 'modeling2' }
DEVSComponent >> removeInputPorts: list [

	list do: [ :p | self removeInputPortNamed: p ].

]

{ #category : 'modeling' }
DEVSComponent >> removeOutputPortNamed: n [

	outputPorts removeKey: n.

]

{ #category : 'modeling2' }
DEVSComponent >> removeOutputPorts: list [

	list do: [ :p | self removeOutputPortNamed: p ].

]

{ #category : 'modeling2' }
DEVSComponent >> renameInputPort: n1 to: n2 [
	"returns true if ok"
	(inputPorts keys includes: n1) ifFalse: [^false].
	(inputPorts keys includes: n2) ifTrue: [^false].
	inputPorts at: n2 put: (inputPorts removeKey: n1).
	(inputPorts at: n2) name: n2.
	^true

]

{ #category : 'modeling2' }
DEVSComponent >> renameOutputPort: n1 to: n2 [
	"returns true if ok"
	(outputPorts keys includes: n1) ifFalse: [^false].
	(outputPorts keys includes: n2) ifTrue: [^false].
	outputPorts at: n2 put: (outputPorts removeKey: n1).
	(outputPorts at: n2) name: n2.
	^true

]

{ #category : 'misc' }
DEVSComponent >> reset [

	timeLast = 0. timeNext := Float infinity.
	self initializeModel
]

{ #category : 'misc' }
DEVSComponent >> rootSolver [

	^ parent rootSolver 

]

{ #category : 'private' }
DEVSComponent >> safelyDo: aBlock [
	"Intended for model edition at runtime (not thread safe - usable either only reflectively by a DEVS itself as part of a simulation step, or by anybody else when simulation is suspended; for thread safe use see AbstractSimulation>>safelyDo:). 
	Synchronizes DEVS before and inits it after the block evaluation. If the simulation is suspended, then no synchronization nor initialization is needed because it has already been synchronized during simulation stop and it will be initialized during simulation start."

	| v simulationIsRunning |

	self rootSolver notNil ifTrue: [ "self rootSolver accessProtect critical: ["
		simulationIsRunning := self rootSolver notNil and: [ self rootSolver isRunning ].	
		simulationIsRunning ifTrue: [ self receiveMsgSyncTime: self rootSolver time ].
		v := aBlock value.
		simulationIsRunning ifTrue: [ self receiveMsgInitTime: self rootSolver time ] "]" ]
	ifFalse: [ v := aBlock value ].
	^ v

]

{ #category : 'misc' }
DEVSComponent >> simulation [

	^ parent simulation 

]

{ #category : 'simulation' }
DEVSComponent >> timeLast [

	^ timeLast
]

{ #category : 'simulation' }
DEVSComponent >> timeNext [

	^ timeNext
]
