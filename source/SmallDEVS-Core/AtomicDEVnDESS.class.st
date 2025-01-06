Class {
	#name : 'AtomicDEVnDESS',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'time',
		'step',
		'intg',
		'intgTmp',
		'savedIntg',
		'conditions',
		'savedConditionValues',
		'sePolarity',
		'seConditionIndex'
	],
	#category : 'SmallDEVS-Core-Continuous',
	#package : 'SmallDEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> addInputNPortNamed: n [

	^ self addInputPortOfType: InputNPort named: n
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> addOutputNPortNamed: n [

	^ self addOutputPortOfType: OutputNPort named: n
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> addSECondition: aBlock [

	conditions add: aBlock.
	savedConditionValues := nil. "it will be lazily generated later"


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> allocateIntegrators: n [

	intg := Array new: n.
	intgTmp := Array new: n.


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> getSimulator [

	^ (DEVnDESSRootSolver basicNew rootDEVS: self) initialize
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> getSimulatorRT [

	^ (DEVnDESSRootSolverRT basicNew rootDEVS: self) initialize
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> initConditions [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> initialize [

	super initialize.
	conditions := OrderedCollection new.
	time := step := 0.
	"self allocateIntegrators: 0."

	self initConditions.		"subclass responsibility"

	self saveState.


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> intg: n integrate: block [ 

	"Euler integration. To be replaced by RK4 or something else in future."

	intgTmp at: n put: ((intg at: n) + (block value * step)).

]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> intgPostStep [

	intg := intgTmp copy.

]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> receiveMsgInitTime: t [

	super receiveMsgInitTime: t.
	time := t.
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> receiveNMsgStarTime: t step: h [

	(t = time) "no #closeTo: because step restart is initated by exatly the same argument (?)"
		ifTrue: [ 
			self revertToPrevState ]
		ifFalse: [ 
			((time + step - t) closeTo: 0) ifFalse: [ self error: 'Bad sync !!!']. 
			self saveState ].

	"generate output"
	time := t.
	step := h.
	output := Dictionary new.
	self outputNFnc.
	^ output


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> receiveNMsgX: x time: t step: h [

	 | s1 s2 | 

	"integration step"
	input := x.
	time := t.
	step := h.
	self intgStep.
	self intgPostStep.

	"check conditions"	
	seConditionIndex := (1 to: conditions size) detect: [ :i |
		s1 := (conditions at: i) value sign.
		s2 := (savedConditionValues at: i) sign. 
		s1 ~= s2 ] ifNone: [ nil ].
	seConditionIndex isNil ifFalse: [ 
		sePolarity := s1. 
		self sendMsgSETime: t + h ]


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> removeSEConditionNo: index [

	conditions remove: (conditions at: index).
	savedConditionValues := nil. "it will be lazily generated later"


]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> revertToPrevState [

	intg := savedIntg copy.
]

{ #category : 'as yet unclassified' }
AtomicDEVnDESS >> saveState [

	savedIntg := intg copy.

	savedConditionValues isNil ifTrue: [ savedConditionValues := Array new: conditions size ].
	1 to: conditions size do: [ :i | savedConditionValues at: i put: (conditions at: i) value ].
]
