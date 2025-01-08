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
		'verbose',
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

{ #category : 'simulation' }
DEVSComponent >> beVerbose: truefalse [

	verbose := truefalse.


]

{ #category : 'as yet unclassified' }
DEVSComponent >> buildName [
	^ UUID new asString36 
]

{ #category : 'modeling2' }
DEVSComponent >> componentNames [
  ^Array new
]

{ #category : 'simulation' }
DEVSComponent >> deepVerbose: truefalse [

	self beVerbose: truefalse.


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

	verbose := true.



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
DEVSComponent >> isRootDEVS [
	^ parent isKindOf: DEVSRootSolver

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

{ #category : 'misc' }
DEVSComponent >> pathName [
	parent isNil ifTrue: [^''].
	self isRootDEVS 
		ifTrue: [^(parent pathName)]	"is the same as rootDEVS pathName"
		ifFalse: [^(parent pathName),'/', self name]

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
	aStream << '[' << self class displayLabel << '] '.
	self printPathOn: aStream 
]

{ #category : 'printing' }
DEVSComponent >> printPathOn: aStream [ 
	(parent isKindOf: DEVSComponent) ifTrue: [ 
		parent printPathOn: aStream. 
		aStream nextPutAll: '/' ].
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

{ #category : 'printing' }
DEVSComponent >> reportInputPortConfig [

	inputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ':', String tab, (input at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'printing' }
DEVSComponent >> reportOutputPortConfig [

	outputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ': ', String tab, (output at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'simulation' }
DEVSComponent >> reportStream [

	^ self rootSolver reportStream

]

{ #category : 'printing' }
DEVSComponent >> reportStructure [

	| prefix |
	prefix := (String cr), (String new: (self printString findTokens: '/') size withAll: Character tab).
	self reportStream nextPutAll: prefix, (self name isNil ifTrue: [''] ifFalse: [self name]), ' (', self class printString, ')'.
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
DEVSComponent >> reset [

	timeLast = 0. timeNext := Float infinity.
	self initializeModel
]

{ #category : 'misc' }
DEVSComponent >> rootSolver [

	(parent isKindOf: DEVSRootSolver) ifTrue: [ ^parent ].
	(parent isKindOf: DEVSComponent) ifTrue: [ ^parent rootSolver ].
	^nil

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

{ #category : 'simulation' }
DEVSComponent >> timeLast [

	^ timeLast
]

{ #category : 'simulation' }
DEVSComponent >> timeNext [

	^ timeNext
]

{ #category : 'simulation' }
DEVSComponent >> verbose [

	^ verbose 


]
