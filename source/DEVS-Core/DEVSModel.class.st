Class {
	#name : 'DEVSModel',
	#superclass : 'Object',
	#instVars : [
		'parent',
		'inputPorts',
		'outputPorts',
		'input',
		'output',
		'timeLast',
		'timeNext',
		'verbose',
		'name'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
}

{ #category : 'as yet unclassified' }
DEVSModel class >> getSimulator [

	^ self new getSimulator

]

{ #category : 'as yet unclassified' }
DEVSModel class >> getSimulatorRT [

	^ self new getSimulatorRT

]

{ #category : 'as yet unclassified' }
DEVSModel class >> new [

	^ self basicNew initialize	"not needed in 3.7+"
]

{ #category : 'modeling' }
DEVSModel >> addInputPortNamed: n [

	^ self 
		addInputPortOfType: DEVSInputPort 
		named: n
]

{ #category : 'private' }
DEVSModel >> addInputPortOfType: inputPortClass named: aString [

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
DEVSModel >> addInputPorts: aCollection [

	aCollection do: [ :p | self addInputPortNamed: p ].

]

{ #category : 'modeling' }
DEVSModel >> addOutputPortNamed: n [

	^ self addOutputPortOfType: DEVSOutputPort named: n
]

{ #category : 'private' }
DEVSModel >> addOutputPortOfType: portClass named: n [

	| port |
	port := portClass hostDEVS: self name: n.
	outputPorts at: n put: port.
	^ port
]

{ #category : 'modeling2' }
DEVSModel >> addOutputPorts: list [

	list do: [ :p | self addOutputPortNamed: p ].

]

{ #category : 'simulation' }
DEVSModel >> beVerbose: truefalse [

	verbose := truefalse.


]

{ #category : 'modeling2' }
DEVSModel >> componentNames [
  ^Array new
]

{ #category : 'simulation' }
DEVSModel >> deepVerbose: truefalse [

	self beVerbose: truefalse.


]

{ #category : 'simulation' }
DEVSModel >> getSimulator [

	^ (DEVSRootSolver basicNew rootDEVS: self) initialize
]

{ #category : 'simulation' }
DEVSModel >> getSimulatorRT [

	^ (DEVSRootSolverRT basicNew rootDEVS: self) initialize
]

{ #category : 'misc' }
DEVSModel >> initModel [

	^ self
]

{ #category : 'modeling' }
DEVSModel >> initialize [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.
	input := Dictionary new.
	output := Dictionary new.

	timeLast := 0.
	timeNext := Float infinity.

	verbose := true.



]

{ #category : 'misc' }
DEVSModel >> input [
	^input
]

{ #category : 'misc' }
DEVSModel >> input: i [
	input := i
]

{ #category : 'modeling' }
DEVSModel >> inputPortNamed: n [
	
	^  inputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
DEVSModel >> inputPortNames [
  ^self inputPorts collect: [:ip | ip name]
]

{ #category : 'modeling' }
DEVSModel >> inputPorts [

	^ inputPorts values

]

{ #category : 'misc' }
DEVSModel >> isRootDEVS [
	^ parent isKindOf: DEVSRootSolver

]

{ #category : 'as yet unclassified' }
DEVSModel >> name [

	^ name
]

{ #category : 'as yet unclassified' }
DEVSModel >> name: n [

	name := n. 
]

{ #category : 'misc' }
DEVSModel >> output [
	^output
]

{ #category : 'misc' }
DEVSModel >> output: o [
	output := o
]

{ #category : 'modeling' }
DEVSModel >> outputPortNamed: n [

	^  outputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
DEVSModel >> outputPortNames [
  ^self outputPorts collect: [:op | op name]
]

{ #category : 'modeling' }
DEVSModel >> outputPorts [

	^ outputPorts values

]

{ #category : 'modeling' }
DEVSModel >> parent [

	^ parent

]

{ #category : 'modeling' }
DEVSModel >> parent: p [

	parent := p

]

{ #category : 'misc' }
DEVSModel >> pathName [
	parent isNil ifTrue: [^''].
	self isRootDEVS 
		ifTrue: [^(parent pathName)]	"is the same as rootDEVS pathName"
		ifFalse: [^(parent pathName),'/',name]

]

{ #category : 'port accessing' }
DEVSModel >> peekFrom: p [
	| port |
	(port := (self inputPortNamed: p)) ifNil: [self error: 'port not found'].
	^ input at: port ifAbsent: [ nil ]
]

{ #category : 'port accessing' }
DEVSModel >> poke: x to: p [
	| port |
	(port := (self outputPortNamed: p)) ifNil: [self error: 'port not found'].
	output at: port  put: x
]

{ #category : 'printing' }
DEVSModel >> printOn: aStream [

	(parent isKindOf: DEVSModel) ifTrue: [ parent printOn: aStream. aStream nextPutAll: '/' ].
	super printOn: aStream.


]

{ #category : 'simulation' }
DEVSModel >> receiveMsgSyncTime: t [

	"See subclasses. MsgSync prepares atomic models to receive MsgInit safely during simulation. It updates elapsed time of atomic models. This is used before cloning, removing, and adding submodels during simulation. MsgInit uses saved value if timeAdvance for sure (it eases random generation of timeAdvance because timeAdvenace is not invocated more then once at a time).

(Things like this were not mentioned neither in [Uhrmacher:JAMES] nor [Kim&Kim] both dealing with dynamic modification of a model during simulation. JAMES initalizes only new components (model migration is not explicitly dealt with), Kim uses message Query, no Init (?), so elapsed time is not maintained (?). Theoretically it is possible to modify Kim's approach (MsgQuery) to deal with elapsed time instead of introducing MsgSync (?).)"



]

{ #category : 'modeling' }
DEVSModel >> removeAllPorts [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.

]

{ #category : 'modeling' }
DEVSModel >> removeInputPortNamed: n [

	inputPorts removeKey: n.

]

{ #category : 'modeling2' }
DEVSModel >> removeInputPorts: list [

	list do: [ :p | self removeInputPortNamed: p ].

]

{ #category : 'modeling' }
DEVSModel >> removeOutputPortNamed: n [

	outputPorts removeKey: n.

]

{ #category : 'modeling2' }
DEVSModel >> removeOutputPorts: list [

	list do: [ :p | self removeOutputPortNamed: p ].

]

{ #category : 'modeling2' }
DEVSModel >> renameInputPort: n1 to: n2 [
	"returns true if ok"
	(inputPorts keys includes: n1) ifFalse: [^false].
	(inputPorts keys includes: n2) ifTrue: [^false].
	inputPorts at: n2 put: (inputPorts removeKey: n1).
	(inputPorts at: n2) name: n2.
	^true

]

{ #category : 'modeling2' }
DEVSModel >> renameOutputPort: n1 to: n2 [
	"returns true if ok"
	(outputPorts keys includes: n1) ifFalse: [^false].
	(outputPorts keys includes: n2) ifTrue: [^false].
	outputPorts at: n2 put: (outputPorts removeKey: n1).
	(outputPorts at: n2) name: n2.
	^true

]

{ #category : 'printing' }
DEVSModel >> reportInputPortConfig [

	inputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ':', String tab, (input at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'printing' }
DEVSModel >> reportOutputPortConfig [

	outputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ': ', String tab, (output at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'simulation' }
DEVSModel >> reportStream [

	^ self rootSolver reportStream

]

{ #category : 'printing' }
DEVSModel >> reportStructure [

	| prefix |
	prefix := (String cr), (String new: (self printString findTokens: '/') size withAll: Character tab).
	self reportStream nextPutAll: prefix, (name isNil ifTrue: [''] ifFalse: [name]), ' (', self class printString, ')'.
	self reportStream nextPutAll: ' ('.
	inputPorts do: [ :p | self reportStream nextPutAll: ' ', p name ].
	self reportStream nextPutAll: ' ) ('.
	outputPorts do: [ :p | self reportStream nextPutAll: ' ', p name ].
	self reportStream nextPutAll: ' )'.
	inputPorts do: [ :p | p outLines do: [ :l |
		self reportStream nextPutAll: prefix, String tab, p name, ' -> ', l hostDEVS name, ' ', l name ]].
	outputPorts do: [ :p | p outLines do: [ :l |
		self reportStream nextPutAll: prefix, String tab, p name, ' -> ', l hostDEVS name, ' ', l name ]].

]

{ #category : 'misc' }
DEVSModel >> reset [

	timeLast = 0. timeNext := Float infinity.
	self initModel
]

{ #category : 'misc' }
DEVSModel >> rootSolver [

	(parent isKindOf: DEVSRootSolver) ifTrue: [ ^parent ].
	(parent isKindOf: DEVSModel) ifTrue: [ ^parent rootSolver ].
	^nil

]

{ #category : 'private' }
DEVSModel >> safelyDo: aBlock [
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

{ #category : 'simulation' }
DEVSModel >> timeLast [

	^ timeLast
]

{ #category : 'simulation' }
DEVSModel >> timeNext [

	^ timeNext
]

{ #category : 'simulation' }
DEVSModel >> verbose [

	^ verbose 


]
