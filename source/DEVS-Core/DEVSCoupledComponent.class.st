Class {
	#name : 'DEVSCoupledComponent',
	#superclass : 'DEVSComponent',
	#instVars : [
		'eventList',
		'components'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSCoupledComponent class >> displayLabel [ 
	^ #coupled
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> addComponent: aComponent [ 
	components 
		at: aComponent name 
		put: (aComponent
			parent: self) 
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> addComponents: compList [

	compList do: [ :assoc |
		self addComponent: (assoc value 
				name: assoc key) ].

]

{ #category : 'modeling2' }
DEVSCoupledComponent >> addCouplings: net [

	"aCoupledDEVS addCouplings: {
		#(model1 port2) -> #(model3 port4). 
		#(model5 port6) -> #(model7 port8). ... }"

	net do: [ :connection |
		self connectComponentNamed: connection key first port: connection key second
			toComponentNamed: connection value first port: connection value second ].


]

{ #category : 'modeling2' }
DEVSCoupledComponent >> componentNamed: n [
 	n == #self ifTrue: [ ^ self ].
	^ components at: n
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> componentNamed: n ifAbsent: aBlock [
 	n == #self ifTrue: [ ^ self ].
	^ components at: n ifAbsent: aBlock
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> componentNames [

	^ components keys
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> connectComponentNamed: c1 port: p1 toComponentNamed: c2 port: p2 [

"	self connectSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 ifFail: 
		[self error: 'Connection is illegal or cannot be created!'].
"
	self connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2

]

{ #category : 'modeling2' }
DEVSCoupledComponent >> connectComponentNamed: c1 port: p1 toComponentNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self 	ifFalse: [ (self componentNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self 	ifFalse: [ (self componentNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].

     ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self connectPort: port1 to: port2.


]

{ #category : 'modeling2' }
DEVSCoupledComponent >> connectInAnyDirectionSubModelNamed: c1 port: p1 toSubModelNamed: c2 port: p2 [

	self connectComponentNamed: c1 port: p1 toComponentNamed: c2 port: p2 ifFail: [
		self connectComponentNamed: c2 port: p2 toComponentNamed: c1 port: p1 ifFail: [
			self error: 'Connection is illegal or cannot be created!']].


]

{ #category : 'modeling' }
DEVSCoupledComponent >> connectPort: p1 to: p2 [

	(p1 outLines includes: p2) & (p2 inLines includes: p1) ifFalse: [
		p1 outLines add: p2.
		p2 inLines add: p1 ].

]

{ #category : 'couplings' }
DEVSCoupledComponent >> couplingExists: aCoupling [

 	^ (self couplings detect: [ :c | c = aCoupling ] ifNone: [ nil ]) notNil
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> couplings [

	"Returns something like this:
	 {	#(model1 port2) -> #(model3 port4). 
		#(model5 port6) -> #(model7 port8). ... } asSet"
	"Unfortunately, ports has not been designed effectively with respect to
	 introspection and reflectivity. So we have to do hard work here."

	| couplingSpecification couplingSpecification2 inconsistencyDetected |

	inconsistencyDetected := false.
	couplingSpecification := OrderedCollection new.
	self inputPorts do: [ :p | p outLines do: [ :l |
		(components values,{self} includes: l hostDEVS) 
			ifFalse: [
				Transcript show: 'Coupling is inconsistent. I will try to correct it.'; cr.
				inconsistencyDetected := true ]
			ifTrue: [
				couplingSpecification add: 
					({#self. p name} -> 
					{l hostDEVS = self ifTrue: [#self] ifFalse: [l hostDEVS name]. l name}) ]]].
	components values do: [ :m | m outputPorts do: [ :p | p outLines do: [ :l |
		(components values ,{self} includes: l hostDEVS)
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
DEVSCoupledComponent >> couplingsOfComponent: aSymbol [

	^ self couplings select: [ :c | ((c key first)=aSymbol) | ((c value first)=aSymbol) ]

]

{ #category : 'couplings' }
DEVSCoupledComponent >> couplingsOfPort: aSymbol [

	^ self couplings select: [ :c |
		(((c key second)=aSymbol) & ((c key first)=#self)) | (((c value second)=aSymbol) & ((c value first)=#self))]
]

{ #category : 'simulation' }
DEVSCoupledComponent >> deepVerbose: truefalse [

	self beVerbose: truefalse.
	components do: [ :c | c deepVerbose: truefalse ].

]

{ #category : 'modeling' }
DEVSCoupledComponent >> initialize [

	super initialize.
	components := OrderedDictionary new.
]

{ #category : 'simulation' }
DEVSCoupledComponent >> receiveMsgInitTime: t [

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
DEVSCoupledComponent >> receiveMsgSETime: t [

	t < timeNext ifTrue: [ 
		timeNext := t.
		eventList := SortedCollection sortBlock: [ :a :b |  (a at: 1) <= (b at: 1) ].
		components do: [ :c | eventList add: { c timeNext. c } ].
		parent receiveMsgSETime: t ].



]

{ #category : 'simulation' }
DEVSCoupledComponent >> receiveMsgStarTime: t [

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
DEVSCoupledComponent >> receiveMsgSyncTime: t [

	components do: [ :c | c receiveMsgSyncTime: t ].

]

{ #category : 'simulation' }
DEVSCoupledComponent >> receiveMsgX: x time: t [

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
DEVSCoupledComponent >> removeAllComponents [

	components := Dictionary new.
]

{ #category : 'modeling' }
DEVSCoupledComponent >> removeAllCouplings [
	| cpl |
	cpl := OrderedCollection new.
	self inputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]].
	components do: [ :m | m outputPorts do: [ :p | p outLines do: [ :l | cpl add: { p. l. } ]]].
	self outputPorts do: [ :p | p inLines do: [ :l | cpl add: { l. p. } ]].	"theoretically redundant"
	cpl do: [ :c | self unconnectPort: c first from: c second ].

]

{ #category : 'modeling' }
DEVSCoupledComponent >> removeComponent: model [

	self safelyDo: [ 
		components removeKeyAtValue: model.
		model parent: nil ].
	^ model


]

{ #category : 'modeling2' }
DEVSCoupledComponent >> removeComponentNamed: n [

	self removeCouplingsOfModel: n.
	^ components removeKey: n
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> removeComponents: aCollection [

	aCollection do: [ :component |
		self removeComponent: component ].
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> removeCouplings: net [

	"aCoupledDEVS removeCouplings: {
		(#model1 #port2) -> (#model3 #port4). 
		(#model5 #port6) -> (#model7 #port8). ... }"

	net do: [ :connection |
		self unconnectComponentNamed: connection key first port: connection key second
			fromComponentNamed: connection value first port: connection value second ].


]

{ #category : 'couplings' }
DEVSCoupledComponent >> removeCouplingsOfModel: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfComponent: n) ].

]

{ #category : 'couplings' }
DEVSCoupledComponent >> removeCouplingsOfPort: n [

	self safelyDo: [ self removeCouplings: (self couplingsOfPort: n) ]
]

{ #category : 'couplings' }
DEVSCoupledComponent >> removeInputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeInputPortNamed: n.
]

{ #category : 'couplings' }
DEVSCoupledComponent >> removeOutputPortNamed: n [

  self removeCouplingsOfPort: n.
  super removeOutputPortNamed: n.
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> rename: n1 to: n2 [
	"returns true if ok"
	(components keys includes: n1) ifFalse: [^false].
	(components keys includes: n2) ifTrue: [^false].
	components at: n2 put: (components removeKey: n1).
	(components at: n2) name: n2.
	^true


]

{ #category : 'simulation' }
DEVSCoupledComponent >> reportStructure [

	super reportStructure.
	components do: [ :c | c reportStructure ].


	
]

{ #category : 'as yet unclassified' }
DEVSCoupledComponent >> reset [

	timeLast = 0. timeNext := Float infinity.
	components do: [ :c | c reset ].
	self initializeModel

]

{ #category : 'modeling' }
DEVSCoupledComponent >> select: immList [

	^ (immList asSortedCollection: [ :c1 :c2 | c1 name <= c2 name ]) first
]

{ #category : 'modeling2' }
DEVSCoupledComponent >> unconnectComponentNamed: c1 port: p1 fromComponentNamed: c2 port: p2 [

	self unconnectComponentNamed: c1 port: p1 fromComponentNamed: c2 port: p2 ifFail: [
		self unconnectComponentNamed: c2 port: p2 fromComponentNamed: c1 port: p1 ifFail: [
			self error: 'Connection does not exist!']].

]

{ #category : 'modeling2' }
DEVSCoupledComponent >> unconnectComponentNamed: c1 port: p1 fromComponentNamed: c2 port: p2 ifFail: aBlock [

	| port1 port2 | 

	port1 := c1 = #self ifFalse: [ (self componentNamed: c1) outputPortNamed: p1 ] 
						ifTrue: [ self inputPortNamed: p1 ].
	port2 := c2 = #self ifFalse: [ (self componentNamed: c2) inputPortNamed: p2 ] 
						ifTrue: [ self outputPortNamed: p2 ].
						
      ((port1 isNil) | (port2 isNil)) ifTrue: [ ^ aBlock value ].

	self unconnectPort: port1 from: port2.
]

{ #category : 'modeling' }
DEVSCoupledComponent >> unconnectPort: p1 from: p2 [

	(p1 outLines includes: p2)  ifTrue: [ p1 outLines remove: p2 ].
	(p2 inLines includes: p1) ifTrue: [ p2 inLines remove: p1 ].

]
