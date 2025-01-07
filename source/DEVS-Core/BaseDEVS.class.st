Class {
	#name : 'BaseDEVS',
	#superclass : 'DEVSEntity',
	#instVars : [
		'parent',
		'inputPorts',
		'outputPorts',
		'input',
		'output',
		'timeLast',
		'timeNext',
		'verbose'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
}

{ #category : 'as yet unclassified' }
BaseDEVS class >> getSimulator [

	^ self new getSimulator

]

{ #category : 'as yet unclassified' }
BaseDEVS class >> getSimulatorRT [

	^ self new getSimulatorRT

]

{ #category : 'as yet unclassified' }
BaseDEVS class >> new [

	^ self basicNew initialize	"not needed in 3.7+"
]

{ #category : 'modeling' }
BaseDEVS >> addInputPortNamed: n [

	^ self addInputPortOfType: InputPort named: n
]

{ #category : 'private' }
BaseDEVS >> addInputPortOfType: portClass named: n [

	| port |
	port := portClass hostDEVS: self name: n.
	inputPorts at: n put: port.
	^ port
]

{ #category : 'modeling2' }
BaseDEVS >> addInputPorts: list [

	list do: [ :p | self addInputPortNamed: p ].

]

{ #category : 'modeling' }
BaseDEVS >> addOutputPortNamed: n [

	^ self addOutputPortOfType: OutputPort named: n
]

{ #category : 'private' }
BaseDEVS >> addOutputPortOfType: portClass named: n [

	| port |
	port := portClass hostDEVS: self name: n.
	outputPorts at: n put: port.
	^ port
]

{ #category : 'modeling2' }
BaseDEVS >> addOutputPorts: list [

	list do: [ :p | self addOutputPortNamed: p ].

]

{ #category : 'simulation' }
BaseDEVS >> beVerbose: truefalse [

	verbose := truefalse.


]

{ #category : 'modeling2' }
BaseDEVS >> componentNames [
  ^Array new
]

{ #category : 'copying' }
BaseDEVS >> copy [

	| aCopy |
	aCopy := self shallowCopy.
	aCopy parent: nil.
	"Original ports are to be replaced by new ones. Input and output (contents of ports) are copied
	 (although it is not necessary - their initialization should be sufficient - as in #storeOn:; 
	shallow copy is not problem here - hopefully) - REMOVE ????. Consult with DEVS theory!!!"
	aCopy removeAllPorts.
	aCopy input: Dictionary new.
	aCopy output: Dictionary new.
	inputPorts keysAndValuesDo: [ :n :p || np | 
		np := aCopy addInputPortOfType: p species named: n.
		(input keys includes: p) ifTrue: [ aCopy input at: np put: (input at: p) copy ]].	
	outputPorts keysAndValuesDo: [ :n :p || np |
		np := aCopy addOutputPortOfType: p species named: n.
		(output keys includes: p) ifTrue: [ aCopy output at: np put: (output at: p) copy ]].
	^ aCopy postCopy
	

]

{ #category : 'simulation' }
BaseDEVS >> deepVerbose: truefalse [

	self beVerbose: truefalse.


]

{ #category : 'sixx' }
BaseDEVS >> doNotStore [
	"Returns array of inst variables which have not to be stored."
	^ Array new.
]

{ #category : 'simulation' }
BaseDEVS >> getSimulator [

	^ (DEVSRootSolver basicNew rootDEVS: self) initialize
]

{ #category : 'simulation' }
BaseDEVS >> getSimulatorRT [

	^ (DEVSRootSolverRT basicNew rootDEVS: self) initialize
]

{ #category : 'misc' }
BaseDEVS >> initModel [

	^ self
]

{ #category : 'modeling' }
BaseDEVS >> initialize [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.
	input := Dictionary new.
	output := Dictionary new.

	timeLast := 0.
	timeNext := Float infinity.

	verbose := true.



]

{ #category : 'misc' }
BaseDEVS >> input [
	^input
]

{ #category : 'misc' }
BaseDEVS >> input: i [
	input := i
]

{ #category : 'modeling' }
BaseDEVS >> inputPortNamed: n [
	
	^  inputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
BaseDEVS >> inputPortNames [
  ^self inputPorts collect: [:ip | ip name]
]

{ #category : 'modeling' }
BaseDEVS >> inputPorts [

	^ inputPorts values

]

{ #category : 'misc' }
BaseDEVS >> isRootDEVS [
	^ parent isKindOf: DEVSRootSolver

]

{ #category : 'misc' }
BaseDEVS >> output [
	^output
]

{ #category : 'misc' }
BaseDEVS >> output: o [
	output := o
]

{ #category : 'modeling' }
BaseDEVS >> outputPortNamed: n [

	^  outputPorts at: n ifAbsent: [nil]
]

{ #category : 'modeling2' }
BaseDEVS >> outputPortNames [
  ^self outputPorts collect: [:op | op name]
]

{ #category : 'modeling' }
BaseDEVS >> outputPorts [

	^ outputPorts values

]

{ #category : 'modeling' }
BaseDEVS >> parent [

	^ parent

]

{ #category : 'modeling' }
BaseDEVS >> parent: p [

	parent := p

]

{ #category : 'misc' }
BaseDEVS >> pathName [
	parent isNil ifTrue: [^''].
	self isRootDEVS 
		ifTrue: [^(parent pathName)]	"is the same as rootDEVS pathName"
		ifFalse: [^(parent pathName),'/',name]

]

{ #category : 'port accessing' }
BaseDEVS >> peekFrom: p [
	| port |
	(port := (self inputPortNamed: p)) ifNil: [self error: 'port not found'].
	^ input at: port ifAbsent: [ nil ]
]

{ #category : 'port accessing' }
BaseDEVS >> poke: x to: p [
	| port |
	(port := (self outputPortNamed: p)) ifNil: [self error: 'port not found'].
	output at: port  put: x
]

{ #category : 'printing' }
BaseDEVS >> printOn: aStream [

	(parent isKindOf: BaseDEVS) ifTrue: [ parent printOn: aStream. aStream nextPutAll: '/' ].
	super printOn: aStream.


]

{ #category : 'simulation' }
BaseDEVS >> receiveMsgSyncTime: t [

	"See subclasses. MsgSync prepares atomic models to receive MsgInit safely during simulation. It updates elapsed time of atomic models. This is used before cloning, removing, and adding submodels during simulation. MsgInit uses saved value if timeAdvance for sure (it eases random generation of timeAdvance because timeAdvenace is not invocated more then once at a time).

(Things like this were not mentioned neither in [Uhrmacher:JAMES] nor [Kim&Kim] both dealing with dynamic modification of a model during simulation. JAMES initalizes only new components (model migration is not explicitly dealt with), Kim uses message Query, no Init (?), so elapsed time is not maintained (?). Theoretically it is possible to modify Kim's approach (MsgQuery) to deal with elapsed time instead of introducing MsgSync (?).)"



]

{ #category : 'modeling' }
BaseDEVS >> removeAllPorts [

	inputPorts := Dictionary new.
	outputPorts := Dictionary new.

]

{ #category : 'modeling' }
BaseDEVS >> removeInputPortNamed: n [

	inputPorts removeKey: n.

]

{ #category : 'modeling2' }
BaseDEVS >> removeInputPorts: list [

	list do: [ :p | self removeInputPortNamed: p ].

]

{ #category : 'modeling' }
BaseDEVS >> removeOutputPortNamed: n [

	outputPorts removeKey: n.

]

{ #category : 'modeling2' }
BaseDEVS >> removeOutputPorts: list [

	list do: [ :p | self removeOutputPortNamed: p ].

]

{ #category : 'modeling2' }
BaseDEVS >> renameInputPort: n1 to: n2 [
	"returns true if ok"
	(inputPorts keys includes: n1) ifFalse: [^false].
	(inputPorts keys includes: n2) ifTrue: [^false].
	inputPorts at: n2 put: (inputPorts removeKey: n1).
	(inputPorts at: n2) name: n2.
	^true

]

{ #category : 'modeling2' }
BaseDEVS >> renameOutputPort: n1 to: n2 [
	"returns true if ok"
	(outputPorts keys includes: n1) ifFalse: [^false].
	(outputPorts keys includes: n2) ifTrue: [^false].
	outputPorts at: n2 put: (outputPorts removeKey: n1).
	(outputPorts at: n2) name: n2.
	^true

]

{ #category : 'printing' }
BaseDEVS >> reportInputPortConfig [

	inputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ':', String tab, (input at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'printing' }
BaseDEVS >> reportOutputPortConfig [

	outputPorts associationsDo: [ :assoc |
		self reportStream nextPutAll: '        ', assoc key asString, ': ', String tab, (output at: assoc value ifAbsent: [nil]) printString, String cr ].
]

{ #category : 'simulation' }
BaseDEVS >> reportStream [

	^ self rootSolver reportStream

]

{ #category : 'printing' }
BaseDEVS >> reportStructure [

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
BaseDEVS >> reset [

	timeLast = 0. timeNext := Float infinity.
	self initModel
]

{ #category : 'misc' }
BaseDEVS >> rootSolver [

	(parent isKindOf: DEVSRootSolver) ifTrue: [ ^parent ].
	(parent isKindOf: BaseDEVS) ifTrue: [ ^parent rootSolver ].
	^nil

]

{ #category : 'copying' }
BaseDEVS >> safeCopy [

	| aCopy |
	self rootSolver 
		ifNotNil: [ self rootSolver safelyDo: [ aCopy := self copy ] ]
		ifNil: [ aCopy := self copy ].
	^ aCopy
]

{ #category : 'private' }
BaseDEVS >> safelyDo: aBlock [
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
BaseDEVS >> simulate: t [

	"obsolete! Use getSimulator simulate: t "

	| clock |
	self receiveMsgInitTime: 0.
	clock := timeNext.
	[ clock <= t ] whileTrue: [ 
		self reportStream nextPutAll: '****************** time: ', clock printString, String cr.
		self receiveMsgStarTime: clock. 
		verbose ifTrue: [
			self reportStream nextPutAll: '* Root DEVS Output Port Configuration: ', String cr.
		 	self reportOutputPortConfig ].
		clock := self timeNext ].
	self reportStream flush.



]

{ #category : 'copying' }
BaseDEVS >> sscopy [
	"experimental alternative to copy - usefull for testing purposes only"
	^Object readFrom: self storeString
]

{ #category : 'copying' }
BaseDEVS >> storeOn: aStream [

	"NOT USED. Remove ???" self halt. "for sure"


	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' new'.		"initialized instance"
	(self class allInstVarNames difference: {'parent'. 'inputPorts'. 'outputPorts'. 'input'. 'output'.
		'reportStream'. 'components'. 'namedComponents'. 'eventList'}) do:
		[:n |
		aStream nextPutAll: ' instVarNamed: ';
			store: n;
			nextPutAll: ' put: ';
			store: (self instVarNamed: n);
			nextPut: $;].

	"ports"
	inputPorts keysAndValuesDo: [ :k :v | 
		aStream nextPutAll: ' addInputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $; ].	
	outputPorts keysAndValuesDo: [ :k :v | 
		aStream nextPutAll: ' addOutputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $; ].	

	aStream nextPutAll: ' yourself)'



]

{ #category : 'simulation' }
BaseDEVS >> timeLast [

	^ timeLast
]

{ #category : 'simulation' }
BaseDEVS >> timeNext [

	^ timeNext
]

{ #category : 'simulation' }
BaseDEVS >> verbose [

	^ verbose 


]
