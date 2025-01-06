"
I'm a class of auxiliary objects needed by SIXX to serialize/deserialize instances of CoupledDEVS.

TO DO: Use SIXX custom serialization instead of this dirty hack.
"
Class {
	#name : 'CoupledDEVSConstructor',
	#superclass : 'Object',
	#instVars : [
		'class',
		'components',
		'couplings',
		'positions',
		'name',
		'inputPorts',
		'outputPorts',
		'agent',
		'comment'
	],
	#category : 'SmallDEVS-Core-Prototypes',
	#package : 'SmallDEVS-Core',
	#tag : 'Prototypes'
}

{ #category : 'as yet unclassified' }
CoupledDEVSConstructor class >> for: aCoupledDEVS [

	^ self new for: aCoupledDEVS
]

{ #category : 'as yet unclassified' }
CoupledDEVSConstructor >> for: aCoupledDEVS [

	class := "aCoupledDEVS species" CoupledDEVSPrototype.
	name := aCoupledDEVS name.
	inputPorts := aCoupledDEVS inputPortNames.
	outputPorts := aCoupledDEVS outputPortNames.
	components := Dictionary new.
	aCoupledDEVS componentNames do: [ :n | 
		components at: n put: (aCoupledDEVS componentNamed: n) ].
	couplings := aCoupledDEVS couplings.
	positions := aCoupledDEVS positions.
	comment := aCoupledDEVS comment.
	agent := (aCoupledDEVS agent methodNames size > 0) 
		ifTrue: [aCoupledDEVS agent]
		ifFalse: [nil].
	"a little problem with agent: reference to devs is replaced by a symlink (a feature of PrototypeObject serialization (can be modified in subclass - TO DO)). we have to put correct value to the slot 'devs' after loading ... it is done in CoupledDEVSPrototype>>agent: "

]

{ #category : 'as yet unclassified' }
CoupledDEVSConstructor >> sixxInitialize [
	"The method is called after the loading of the receiver"

	|  c n ip op co p a t |
	c := components. n := name. ip := inputPorts. op := outputPorts. co := couplings. p := positions.
	a := agent. t := comment.
	self become: class basicNew.
	self initialize.	"among other things, a default agent is installed"
	self name: n. 
	self addInputPorts: ip.
	self addOutputPorts: op.
	c keysAndValuesDo: [ :k :v | self addSubModel: v named: k ].
	self removeAllCouplings.		"why the heck do we need this to eliminate inconsistency in coupling? todo: make better solution!"
	self addCouplings: co.	
	self positions: p.
	a ifNotNil: [ self agent: a ].
	t ifNotNil: [ self comment: t ].

]
