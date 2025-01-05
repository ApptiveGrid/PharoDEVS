Class {
	#name : #CoupledDEVS,
	#superclass : #BaseDEVS,
	#instVars : [
		'components',
		'namedComponents',
		'eventList'
	],
	#category : #'SmallDEVS-Core'
}

{ #category : #modeling2 }
CoupledDEVS >> addComponent: model named: n [
	^ self addSubModel: model named: n

]

{ #category : #modeling2 }
CoupledDEVS >> addComponents: compList [

	compList do: [ :assoc |
		self addComponent: (assoc value) named: (assoc key) ].
	(MyRepository root) changed: #hierarchicalList.

]

{ #category : #modeling2 }
CoupledDEVS >> addCouplings: net [

	"aCoupledDEVS addCouplings: {
		#(model1 port2) -> #(model3 port4). 
		#(model5 port6) -> #(model7 port8). ... }"

	net do: [ :connection |
		self connectSubModelNamed: connection key first port: connection key second
			toSubModelNamed: connection value first port: connection value second ].


]

{ #category : #modeling }
CoupledDEVS >> addSubModel: model [

	self safelyDo: [
		components add: model.
		model parent: self ].
	^ model
]

{ #category : #modeling2 }
CoupledDEVS >> addSubModel: model named: n [

	(namedComponents keys includes: n) ifTrue: [ self error: 'Coulpled DEVS: Name of new component collides.' ].
	model name: n.
	self addSubModel: model.
	namedComponents at: n put: model.	"namedComponents for easier model construction"

	^ model.
]

{ #category : #modeling2 }
CoupledDEVS >> componentNamed: n [
  ^self subModelNamed: n.
]

{ #category : #modeling2 }
CoupledDEVS >> componentNamed: n ifAbsent: aBlock [
  ^self subModelNamed: n ifAbsent: aBlock.
]

{ #category : #modeling2 }
CoupledDEVS >> componentNames [

	^ namedComponents keys
]

{ #category : #modeling2 }
CoupledDEVS >> connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 [

	self connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: [
		self connectSubModelNamed: c2 port: p2 toSubModelNamed: c1 port: p1 ifFail: [
			self error: 'Connection is illegal or cannot be created!']].


]

{ #category : #modeling }
CoupledDEVS >> connectPort: p1 to: p2 [

	(p1 outLines includes: p2) & (p2 inLines includes: p1) ifFalse: [
		p1 outLines add: p2.
		p2 inLines add: p1 ].

]

{ #category : #modeling2 }
CoupledDEVS >> connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 [

"	self connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: 
		[self error: 'Connection is illegal or cannot be created!'].
"
	self connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2

]

{ #category : #modeling2 }
CoupledDEVS >> connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self 	ifFalse: [ (self subModelNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self 	ifFalse: [ (self subModelNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].

     ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self connectPort: port1 to: port2.


]

{ #category : #copying }
CoupledDEVS >> copy [

	| aCopy |
	aCopy := super copy.	 "ports were replaced by new ones, without links (w/o couplings)"
	aCopy removeAllSubModels.
	(components difference: namedComponents values) do: [ :c |
		aCopy addSubModel: c copy ].
	namedComponents keysAndValuesDo: [ :k :v |
		aCopy addSubModel: v copy named: k ].
	aCopy addCouplings: self couplings.	
	^  aCopy
]

{ #category : #couplings }
CoupledDEVS >> couplingExists: aCoupling [

 	^ (self couplings detect: [ :c | c = aCoupling ] ifNone: [ nil ]) notNil
]

{ #category : #modeling2 }
CoupledDEVS >> couplings [

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

{ #category : #couplings }
CoupledDEVS >> couplingsOfModel: aSymbol [

	^ self couplings select: [ :c | ((c key first)=aSymbol) | ((c value first)=aSymbol) ]

]

{ #category : #couplings }
CoupledDEVS >> couplingsOfPort: aSymbol [

	^ self couplings select: [ :c |
		(((c key second)=aSymbol) & ((c key first)=#self)) | (((c value second)=aSymbol) & ((c value first)=#self))]
]

{ #category : #simulation }
CoupledDEVS >> deepVerbose: truefalse [

	self beVerbose: truefalse.
	components do: [ :c | c deepVerbose: truefalse ].

]

{ #category : #simulation }
CoupledDEVS >> finalize [

	components do: [ :c | c finalize ]
]

{ #category : #modeling }
CoupledDEVS >> initialize [

	super initialize.
	components := OrderedCollection new.
	namedComponents := Dictionary new.
]

{ #category : #simulation }
CoupledDEVS >> receiveMsgInitTime: t [

	timeLast := 0.
	timeNext := Float infinity.
	eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
	components do: [ :c |
		c receiveMsgInitTime: t.
		eventList add: { c timeNext. c }.
		timeNext := timeNext min: c timeNext.
		timeLast := timeLast max: c timeLast ].

]

{ #category : #simulation }
CoupledDEVS >> receiveMsgSETime: t [

	t < timeNext ifTrue: [ 
		timeNext := t.
		eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
		components do: [ :c | eventList add: { c timeNext. c } ].
		parent receiveMsgSETime: t ].



]

{ #category : #simulation }
CoupledDEVS >> receiveMsgStarTime: t [

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

{ #category : #simulation }
CoupledDEVS >> receiveMsgSyncTime: t [

	components do: [ :c | c receiveMsgSyncTime: t ].

]

{ #category : #simulation }
CoupledDEVS >> receiveMsgX: x time: t [

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

{ #category : #modeling }
CoupledDEVS >> removeAllCouplings [
	| cpl |
	cpl := OrderedCollection new.
	self inputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]].
	components do: [ :m | m outputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]]].
	self outputPorts do: [ :p | p inLines do: [ :l | cpl add: { l. p. } ]].	"theoretically redundant"
	cpl do: [ :c | self unconnectPort: c first from: c second ].

]

{ #category : #modeling }
CoupledDEVS >> removeAllSubModels [

	components := OrderedCollection new.
	namedComponents := Dictionary new.
]

{ #category : #modeling2 }
CoupledDEVS >> removeComponentNamed: n [
	^ self removeSubModelNamed: n

]

{ #category : #modeling2 }
CoupledDEVS >> removeComponents: compList [

	compList do: [ :x |
		self removeComponentNamed: x ].
	(MyRepository root) changed: #hierarchicalList.

]

{ #category : #modeling2 }
CoupledDEVS >> removeCouplings: net [

	"aCoupledDEVS removeCouplings: {
		(#model1 #port2) -> (#model3 #port4). 
		(#model5 #port6) -> (#model7 #port8). ... }"

	net do: [ :connection |
		self unconnectSubModelNamed: connection key first port: connection key second
			fromSubModelNamed: connection value first port: connection value second ].


]

{ #category : #couplings }
CoupledDEVS >> removeCouplingsOfModel: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfModel: n) ].

]

{ #category : #couplings }
CoupledDEVS >> removeCouplingsOfPort: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfPort: n) ]
]

{ #category : #couplings }
CoupledDEVS >> removeInputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeInputPortNamed: n.
]

{ #category : #couplings }
CoupledDEVS >> removeOutputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeOutputPortNamed: n.
]

{ #category : #modeling }
CoupledDEVS >> removeSubModel: model [

	self safelyDo: [ 
		components remove: model.
		model parent: nil ].
	^ model


]

{ #category : #modeling2 }
CoupledDEVS >> removeSubModelNamed: n [
	| model |

	self removeCouplingsOfModel: n.

	model := namedComponents removeKey: n.
	self removeSubModel: model.
	^model
]

{ #category : #modeling2 }
CoupledDEVS >> rename: n1 to: n2 [
	"returns true if ok"
	(namedComponents keys includes: n1) ifFalse: [^false].
	(namedComponents keys includes: n2) ifTrue: [^false].
	namedComponents at: n2 put: (namedComponents removeKey: n1).
	(namedComponents at: n2) name: n2.
	^true


]

{ #category : #simulation }
CoupledDEVS >> reportStructure [

	super reportStructure.
	components do: [ :c | c reportStructure ].


	
]

{ #category : #'as yet unclassified' }
CoupledDEVS >> reset [

	timeLast = 0. timeNext := Float infinity.
	components do: [ :c | c reset ].
	self initModel

]

{ #category : #modeling }
CoupledDEVS >> select: immList [

	^ (immList asSortedCollection: [ :c1 :c2 | c1 name <= c2 name ]) first
]

{ #category : #modeling2 }
CoupledDEVS >> subModelNamed: n [

	n == #self ifTrue: [ ^ self ].
	^ namedComponents at: n
]

{ #category : #modeling2 }
CoupledDEVS >> subModelNamed: n ifAbsent: aBlock [

	n == #self ifTrue: [ ^ self ].
	^ namedComponents at: n ifAbsent: aBlock
]

{ #category : #modeling }
CoupledDEVS >> unconnectPort: p1 from: p2 [

	(p1 outLines includes: p2)  ifTrue: [ p1 outLines remove: p2 ].
	(p2 inLines includes: p1) ifTrue: [ p2 inLines remove: p1 ].

]

{ #category : #modeling2 }
CoupledDEVS >> unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 [

	self unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 ifFail: [
		self unconnectSubModelNamed: c2 port: p2 fromSubModelNamed: c1 port: p1 ifFail: [
			self error: 'Connection does not exist!']].

]

{ #category : #modeling2 }
CoupledDEVS >> unconnectSubModelNamed: c1 port: p1 fromSubModelNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self ifFalse: [ (self subModelNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self ifFalse: [ (self subModelNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].
						
      ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self unconnectPort: port1 from: port2.
]
