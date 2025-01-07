Class {
	#name : 'DEVSCoupled',
	#superclass : 'DEVSModel',
	#instVars : [
		'components',
		'namedComponents',
		'eventList'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'modeling2' }
DEVSCoupled >> addComponent: model named: n [
	^ self addSubModel: model named: n

]

{ #category : 'modeling2' }
DEVSCoupled >> addComponents: compList [

	compList do: [ :assoc |
		self addComponent: (assoc value) named: (assoc key) ].

]

{ #category : 'modeling2' }
DEVSCoupled >> addCouplings: net [

	"aCoupledDEVS addCouplings: {
		#(model1 port2) -> #(model3 port4). 
		#(model5 port6) -> #(model7 port8). ... }"

	net do: [ :connection |
		self connectSubModelNamed: connection key first port: connection key second
			toSubModelNamed: connection value first port: connection value second ].


]

{ #category : 'modeling' }
DEVSCoupled >> addSubModel: model [

	self safelyDo: [
		components add: model.
		model parent: self ].
	^ model
]

{ #category : 'modeling2' }
DEVSCoupled >> addSubModel: model named: n [

	(namedComponents keys includes: n) ifTrue: [ self error: 'Coupled DEVS: Name of new component collides.' ].
	model name: n.
	self addSubModel: model.
	namedComponents at: n put: model.	"namedComponents for easier model construction"

	^ model.
]

{ #category : 'modeling2' }
DEVSCoupled >> componentNamed: n [
  ^self subModelNamed: n.
]

{ #category : 'modeling2' }
DEVSCoupled >> componentNamed: n ifAbsent: aBlock [
  ^self subModelNamed: n ifAbsent: aBlock.
]

{ #category : 'modeling2' }
DEVSCoupled >> componentNames [

	^ namedComponents keys
]

{ #category : 'modeling2' }
DEVSCoupled >> connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 [

	self connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: [
		self connectSubModelNamed: c2 port: p2 toSubModelNamed: c1 port: p1 ifFail: [
			self error: 'Connection is illegal or cannot be created!']].


]

{ #category : 'modeling' }
DEVSCoupled >> connectPort: p1 to: p2 [

	(p1 outLines includes: p2) & (p2 inLines includes: p1) ifFalse: [
		p1 outLines add: p2.
		p2 inLines add: p1 ].

]

{ #category : 'modeling2' }
DEVSCoupled >> connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 [

"	self connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: 
		[self error: 'Connection is illegal or cannot be created!'].
"
	self connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2

]

{ #category : 'modeling2' }
DEVSCoupled >> connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self 	ifFalse: [ (self subModelNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self 	ifFalse: [ (self subModelNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].

     ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self connectPort: port1 to: port2.


]

{ #category : 'couplings' }
DEVSCoupled >> couplingExists: aCoupling [

 	^ (self couplings detect: [ :c | c = aCoupling ] ifNone: [ nil ]) notNil
]

{ #category : 'modeling2' }
DEVSCoupled >> couplings [

	"Returns something like this:
	 {	#(model1 port2) -> #(model3 port4). 
		#(model5 port6) -> #(model7 port8). ... } asSet"
	"Unfortunately, ports has not been designed effectively with respect to
	 introspection and reflectivity. So we have to do hard work here."

	| couplingSpecification couplingSpecification2 inconsistencyDetected |

	inconsistencyDetected := false.
	couplingSpecification := OrderedCollection new.
	self inputPorts do: [ :p | p outLines do: [ :l |
		(components,{self} includes: l hostDEVS) 
			ifFalse: [
				Transcript show: 'Coupling is inconsistent. I will try to correct it.'; cr.
				inconsistencyDetected := true ]
			ifTrue: [
				couplingSpecification add: 
					({#self. p name} -> 
					{l hostDEVS = self ifTrue: [#self] ifFalse: [l hostDEVS name]. l name}) ]]].
	components do: [ :m | m outputPorts do: [ :p | p outLines do: [ :l |
		(components,{self} includes: l hostDEVS)
			ifFalse: [
				Transcript show:  'Coupling is inconsistent. I will try to correct it.'; cr.
				inconsistencyDetected := true ]
			ifTrue: [
				couplingSpecification add: 
					({m name. p name} -> 
					{l hostDEVS = self ifTrue: [#self] ifFalse: [l hostDEVS name]. l name}) ]]]].

	(couplingSpecification select: [ :c | 
		((self componentNames, {#self} includes: c first first ) & 
		 (self componentNames, {#self} includes: c second first)) not ]) do: [:c |
			self error: 'This shouldn''t happen. Coupling is seriously corrupted.' ].

	couplingSpecification2 := couplingSpecification asSet.
	(couplingSpecification size ~= couplingSpecification2 size) | inconsistencyDetected ifTrue: [ 
		self inform: 'Coupling inconsistence detected. I will try to correct it.'.
		self removeAllCouplings.
		self addCouplings: couplingSpecification2.
		^ self couplings  ].

	^ couplingSpecification2 

]

{ #category : 'couplings' }
DEVSCoupled >> couplingsOfModel: aSymbol [

	^ self couplings select: [ :c | ((c key first)=aSymbol) | ((c value first)=aSymbol) ]

]

{ #category : 'couplings' }
DEVSCoupled >> couplingsOfPort: aSymbol [

	^ self couplings select: [ :c |
		(((c key second)=aSymbol) & ((c key first)=#self)) | (((c value second)=aSymbol) & ((c value first)=#self))]
]

{ #category : 'simulation' }
DEVSCoupled >> deepVerbose: truefalse [

	self beVerbose: truefalse.
	components do: [ :c | c deepVerbose: truefalse ].

]

{ #category : 'simulation' }
DEVSCoupled >> finalize [

	components do: [ :c | c finalize ]
]

{ #category : 'modeling' }
DEVSCoupled >> initialize [

	super initialize.
	components := OrderedCollection new.
	namedComponents := Dictionary new.
]

{ #category : 'simulation' }
DEVSCoupled >> receiveMsgInitTime: t [

	timeLast := 0.
	timeNext := Float infinity.
	eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
	components do: [ :c |
		c receiveMsgInitTime: t.
		eventList add: { c timeNext. c }.
		timeNext := timeNext min: c timeNext.
		timeLast := timeLast max: c timeLast ].

]

{ #category : 'simulation' }
DEVSCoupled >> receiveMsgSETime: t [

	t < timeNext ifTrue: [ 
		timeNext := t.
		eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
		components do: [ :c | eventList add: { c timeNext. c } ].
		parent receiveMsgSETime: t ].



]

{ #category : 'simulation' }
DEVSCoupled >> receiveMsgStarTime: t [

	| immChildren selected yy xx |

	self assert: [ (t - timeNext) closeTo: 0 ].

	immChildren := OrderedCollection new.
	eventList do: [ :ev |
		(((ev at: 1) - t) closeTo: 0) ifTrue: [ immChildren add: (ev at: 2) ]].
	immChildren size = 1 
		ifTrue: [ selected := immChildren at: 1 ].
	immChildren size > 1 
		ifTrue: [ selected := self select: immChildren.
				"verbose" true ifTrue: [
					self reportStream nextPutAll: '* Collision occured in ', self printString, ', involving: ', 
						immChildren printString, String cr.
					self reportStream nextPutAll: '        select chooses: ', selected printString, String cr] ].

	selected 
		ifNil: [ "model is empty" yy := Dictionary new ]
		ifNotNil: [ yy := selected receiveMsgStarTime: t ].

	timeLast := t.
	timeNext := Float infinity.
	eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
	components do: [ :c | 
		xx := Dictionary new.
		c inputPorts do: [ :p | p inLines do: [ :pi |	
			(yy keys includes: pi) ifTrue: [ xx at: p put: (yy at: pi) ]]].
		xx isEmpty ifFalse: [ c receiveMsgX: xx time: t ].
		eventList add: { c timeNext. c. }.
		timeNext := timeNext min: (c timeNext) ].

	output := Dictionary new.
	outputPorts do: [ :p | p inLines do: [ :pi |
		(yy keys includes: pi) ifTrue: [ output at: p put: (yy at: pi) ]]].

	^ output


]

{ #category : 'simulation' }
DEVSCoupled >> receiveMsgSyncTime: t [

	components do: [ :c | c receiveMsgSyncTime: t ].

]

{ #category : 'simulation' }
DEVSCoupled >> receiveMsgX: x time: t [

	| xx |
	self assert: [ (timeLast <= t) & (t <= timeNext) ].
	input := x.
	timeLast := t.
	timeNext := Float infinity.
	eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
	components do: [ :c |
		xx := Dictionary new.
		c inputPorts do: [ :p | p inLines do: [ :pi |
			(input keys includes: pi) ifTrue: [ xx at: p put: (input at: pi) ]]].
		xx isEmpty ifFalse: [ c receiveMsgX: xx time: t ].
		eventList add: { c timeNext. c. }.
		timeNext := timeNext min: (c timeNext) ].



]

{ #category : 'modeling' }
DEVSCoupled >> removeAllCouplings [
	| cpl |
	cpl := OrderedCollection new.
	self inputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]].
	components do: [ :m | m outputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]]].
	self outputPorts do: [ :p | p inLines do: [ :l | cpl add: { l. p. } ]].	"theoretically redundant"
	cpl do: [ :c | self unconnectPort: c first from: c second ].

]

{ #category : 'modeling' }
DEVSCoupled >> removeAllSubModels [

	components := OrderedCollection new.
	namedComponents := Dictionary new.
]

{ #category : 'modeling2' }
DEVSCoupled >> removeComponentNamed: n [
	^ self removeSubModelNamed: n

]

{ #category : 'modeling2' }
DEVSCoupled >> removeComponents: compList [

	compList do: [ :x |
		self removeComponentNamed: x ].
]

{ #category : 'modeling2' }
DEVSCoupled >> removeCouplings: net [

	"aCoupledDEVS removeCouplings: {
		(#model1 #port2) -> (#model3 #port4). 
		(#model5 #port6) -> (#model7 #port8). ... }"

	net do: [ :connection |
		self unconnectSubModelNamed: connection key first port: connection key second
			fromSubModelNamed: connection value first port: connection value second ].


]

{ #category : 'couplings' }
DEVSCoupled >> removeCouplingsOfModel: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfModel: n) ].

]

{ #category : 'couplings' }
DEVSCoupled >> removeCouplingsOfPort: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfPort: n) ]
]

{ #category : 'couplings' }
DEVSCoupled >> removeInputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeInputPortNamed: n.
]

{ #category : 'couplings' }
DEVSCoupled >> removeOutputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeOutputPortNamed: n.
]

{ #category : 'modeling' }
DEVSCoupled >> removeSubModel: model [

	self safelyDo: [ 
		components remove: model.
		model parent: nil ].
	^ model


]

{ #category : 'modeling2' }
DEVSCoupled >> removeSubModelNamed: n [
	| model |

	self removeCouplingsOfModel: n.

	model := namedComponents removeKey: n.
	self removeSubModel: model.
	^model
]

{ #category : 'modeling2' }
DEVSCoupled >> rename: n1 to: n2 [
	"returns true if ok"
	(namedComponents keys includes: n1) ifFalse: [^false].
	(namedComponents keys includes: n2) ifTrue: [^false].
	namedComponents at: n2 put: (namedComponents removeKey: n1).
	(namedComponents at: n2) name: n2.
	^true


]

{ #category : 'simulation' }
DEVSCoupled >> reportStructure [

	super reportStructure.
	components do: [ :c | c reportStructure ].


	
]

{ #category : 'as yet unclassified' }
DEVSCoupled >> reset [

	timeLast = 0. timeNext := Float infinity.
	components do: [ :c | c reset ].
	self initModel

]

{ #category : 'modeling' }
DEVSCoupled >> select: immList [

	^ (immList asSortedCollection: [ :c1 :c2 | c1 name <= c2 name ]) first
]

{ #category : 'modeling2' }
DEVSCoupled >> subModelNamed: n [

	n == #self ifTrue: [ ^ self ].
	^ namedComponents at: n
]

{ #category : 'modeling2' }
DEVSCoupled >> subModelNamed: n ifAbsent: aBlock [

	n == #self ifTrue: [ ^ self ].
	^ namedComponents at: n ifAbsent: aBlock
]

{ #category : 'modeling' }
DEVSCoupled >> unconnectPort: p1 from: p2 [

	(p1 outLines includes: p2)  ifTrue: [ p1 outLines remove: p2 ].
	(p2 inLines includes: p1) ifTrue: [ p2 inLines remove: p1 ].

]

{ #category : 'modeling2' }
DEVSCoupled >> unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 [

	self unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 ifFail: [
		self unconnectSubModelNamed: c2 port: p2 fromSubModelNamed: c1 port: p1 ifFail: [
			self error: 'Connection does not exist!']].

]

{ #category : 'modeling2' }
DEVSCoupled >> unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self ifFalse: [ (self subModelNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self ifFalse: [ (self subModelNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].
						
      ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self unconnectPort: port1 from: port2.
]
