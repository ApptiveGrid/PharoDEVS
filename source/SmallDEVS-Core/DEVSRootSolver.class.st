Class {
	#name : 'DEVSRootSolver',
	#superclass : 'AbstractSimulation',
	#instVars : [
		'rootDEVS'
	],
	#category : 'SmallDEVS-Core',
	#package : 'SmallDEVS-Core'
}

{ #category : 'modeling' }
DEVSRootSolver >> addComponent: c Named: n [
	^ rootDEVS addComponent: c named: n

]

{ #category : 'modeling' }
DEVSRootSolver >> addComponents: compList [
	^ rootDEVS addComponents: compList

]

{ #category : 'modeling' }
DEVSRootSolver >> assureComponentName: aName [
     	^rootDEVS assureComponentName: aName.

]

{ #category : 'simulation' }
DEVSRootSolver >> asyncReportStream: s [

	self asyncSafelyDo: [ reportStream := s ]


]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> beVerbose: truefalse [

	verbose := truefalse.
	rootDEVS beVerbose: truefalse.


]

{ #category : 'modeling' }
DEVSRootSolver >> componentNamed: n [
  ^self rootDEVS componentNamed: n
]

{ #category : 'modeling' }
DEVSRootSolver >> componentNamed: n ifAbsent: aBlock [
  ^self rootDEVS componentNamed: n ifAbsent: aBlock
]

{ #category : 'modeling' }
DEVSRootSolver >> componentNames [
  ^self rootDEVS componentNames
]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> deepVerbose: truefalse [

	verbose := truefalse.
	rootDEVS deepVerbose: truefalse.


]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> doSteps: n [

	| tmp |
	tmp := self rtFactor.
	self rtFactor: 0.
	super doSteps: n.
	self rtFactor: tmp.

]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> finalize [

	"who needs this?????"
	"super finalize ???"
	rootDEVS finalize
]

{ #category : 'modeling' }
DEVSRootSolver >> initModel [

	"let's initialize the model"
	rootDEVS reset.	

	"let's initilalize simulation as well"
	clock := 0. stopTime := Float infinity.
	rootDEVS receiveMsgInitTime: clock.	"it also starts processes in atomic devses"
	rootDEVS receiveMsgSyncTime: clock.				"here we stop them"

	

]

{ #category : 'as yet unclassified' }
DEVSRootSolver >> initialize [

	super initialize.
	"rootDEVS receiveMsgInitTime: clock. ..... not here but in prepareToStart vj 7/18/2005 00:50"

]

{ #category : 'modeling' }
DEVSRootSolver >> model [

	^ rootDEVS



]

{ #category : 'modeling' }
DEVSRootSolver >> name [

	^ rootDEVS ifNotNil: [ rootDEVS name ] ifNil: [ name ]

]

{ #category : 'modeling' }
DEVSRootSolver >> name: n [

	name := n.
	rootDEVS ifNotNil: [ rootDEVS name: n ]
]

{ #category : 'copying' }
DEVSRootSolver >> postCopy [
	self rootDEVS: self rootDEVS copy.
	^ self

]

{ #category : 'simulation' }
DEVSRootSolver >> prepareToStart [

	rootDEVS receiveMsgInitTime: clock.

]

{ #category : 'simulation' }
DEVSRootSolver >> prepareToStop [

	rootDEVS receiveMsgSyncTime: clock.

]

{ #category : 'modeling' }
DEVSRootSolver >> removeComponentNamed: n [
	^ rootDEVS removeComponentNamed: n

]

{ #category : 'modeling' }
DEVSRootSolver >> renameComponentNamed: n1 to: n2 [
	^ rootDEVS renameComponentNamed: n1 to: n2

]

{ #category : 'simulation' }
DEVSRootSolver >> reportStream: s [

	self safelyDo: [ reportStream := s ]

]

{ #category : 'simulation' }
DEVSRootSolver >> reset [

	super reset.
	self initModel.
]

{ #category : 'modeling' }
DEVSRootSolver >> rootDEVS [

	^ rootDEVS



]

{ #category : 'modeling' }
DEVSRootSolver >> rootDEVS: d [

	rootDEVS := d.
	rootDEVS parent: self.



]

{ #category : 'modeling' }
DEVSRootSolver >> rootSolver [

	^ self
]

{ #category : 'simulation' }
DEVSRootSolver >> simulationStep [

	clock := rootDEVS timeNext.
	clock isInfinite ifTrue: [^self].
	reportStream nextPutAll: '****************** time: ', clock printString, String cr.
	rootDEVS receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
	verbose ifTrue: [
		reportStream nextPutAll: '* Root DEVS Output Port Configuration: ', String cr.
	 	rootDEVS reportOutputPortConfig ].
	reportStream flush.
	clock := rootDEVS timeLast.



]

{ #category : 'sixx' }
DEVSRootSolver >> sixxInitialize [
	super sixxInitialize.
	rootDEVS parent: self.
]

{ #category : 'testing' }
DEVSRootSolver >> sixxcopy [
	"experimental alternative to copy - usefull for testing purposes only"
	^Object readSixxFrom: self sixxString
]

{ #category : 'testing' }
DEVSRootSolver >> sscopy [
	"experimental alternative to copy - usefull for testing purposes only"
	^Object readFrom: self storeString
]

{ #category : 'copying' }
DEVSRootSolver >> storeOn: aStream [

	aStream nextPut: $(.
	super storeOn: aStream.
	aStream nextPutAll: 'rootDEVS: '; store: rootDEVS; nextPut: $;.
	aStream nextPutAll: 'beVerbose: '; store: verbose; nextPut: $;.
	aStream nextPutAll: ' yourself)'; nextPutAll: String cr


]

{ #category : 'simulation' }
DEVSRootSolver >> time [

	^ clock

]
