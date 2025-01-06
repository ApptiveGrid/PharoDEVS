Class {
	#name : 'CoupledDEVnDESS',
	#superclass : 'CoupledDEVS',
	#category : 'SmallDEVS-Core-Continuous',
	#package : 'SmallDEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> addInputNPortNamed: n [

	^ self addInputPortOfType: InputNPort named: n
]

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> addOutputNPortNamed: n [

	^ self addOutputPortOfType: OutputNPort named: n
]

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> getSimulator [

	^ (DEVnDESSRootSolver basicNew rootDEVS: self) initialize
]

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> getSimulatorRT [

	^ (DEVnDESSRootSolverRT basicNew rootDEVS: self) initialize
]

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> receiveNMsgStarTime: t step: h [

	| yy xx yetUnevaluatedFunctions toEvaluate |

	"get output from (send '*' to) all blocks with integrators and collect their outputs"
	yy := Dictionary new.	
	(components select: [ :c | (c isKindOf: CoupledDEVnDESS) | (c isKindOf: AtomicDEVnDESS) ]) 
		do: [ :c | (c receiveNMsgStarTime: t step: h) associationsDo: [ :a | yy add: a ] ].

	"evaluate memoryless fast blocks with defined inputs while it is possible 
	 (each block is evaluated max 1 time)"
	yetUnevaluatedFunctions := components select: [ :c | (c isKindOf: InstantaneousFunction) ].
	toEvaluate := OrderedCollection new.
	[ toEvaluate size = yetUnevaluatedFunctions size ] whileFalse: [ 
	  toEvaluate := yetUnevaluatedFunctions copy.
	  toEvaluate do: [ :c | | ready |	
		xx := Dictionary new. ready := true.
		(c inputPorts select: [ :p | p isKindOf: InputNPort]) do: [ :p | p inLines do: [ :pi |	
			(yy keys includes: pi) ifTrue: [ xx at: p put: (yy at: pi) ] ifFalse: [ ready := false ]]].
		ready ifTrue: [ 
			(c receiveNMsgX: xx time: t step: h) associationsDo: [ :a | yy add: a ]. 
			yetUnevaluatedFunctions remove: c ]]].

	"define output of self"
	output := Dictionary new.
	(outputPorts select: [ :p | p isKindOf: OutputNPort]) do: [ :p | p inLines do: [ :pi |
		(yy keys includes: pi) ifTrue: [ output at: p put: (yy at: pi) ]]].

	^ output

]

{ #category : 'as yet unclassified' }
CoupledDEVnDESS >> receiveNMsgX: x time: t step: h [

	| xx yy |

	(timeLast <= t) & (t <= timeNext) ifFalse: [ self error: 'Bad Synchronization' ].

	input := x.

	"collect previously generated outputs from all numeric components, including self's input"
	yy := Dictionary new.
	input associationsDo: [ :a | (a key isKindOf: InputNPort) ifTrue: [ yy add: a ] ].
	(components select: [ :c | (c isKindOf: CoupledDEVnDESS) | (c isKindOf: AtomicDEVnDESS) | 
	   (c isKindOf: InstantaneousFunction) ]) 
		do: [ :c | c output associationsDo: [ :a | 
			(a key isKindOf: OutputNPort) ifTrue: [ yy add: a ] ] ].

	"evaluate all numeric components with appropriate inputs - make integration step"
	(components select: [ :c | (c isKindOf: CoupledDEVnDESS) | (c isKindOf: AtomicDEVnDESS) ]) 
	  do: [ :c |
		xx := Dictionary new.
		(c inputPorts select: [ :p | p isKindOf: InputNPort]) do: [ :p | p inLines do: [ :pi |
			(yy keys includes: pi) ifTrue: [ xx at: p put: (yy at: pi) ]]].
		c receiveNMsgX: xx time: t step: h ].


]
