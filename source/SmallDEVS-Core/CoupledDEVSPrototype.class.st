"
Clonable and editable version of CoupledDEVS for classless model construction.
Uses PrototypeObject from Squeak Prototype package.


"
Class {
	#name : 'CoupledDEVSPrototype',
	#superclass : 'CoupledDEVS',
	#instVars : [
		'agent',
		'comment',
		'positions'
	],
	#category : 'SmallDEVS-Core-Prototypes',
	#package : 'SmallDEVS-Core',
	#tag : 'Prototypes'
}

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> agent [
	^ agent
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> agent: a [
	agent := a.
	a devs: self
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> balloonText [
	| text |
	text := self workspace findTokens: String cr.
	text isEmpty ifFalse: [ ^ text first ].
	^ nil
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> comment [
	^ comment
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> comment: aString [
	comment := aString.
]

{ #category : 'copying' }
CoupledDEVSPrototype >> copy [

	| aCopy |
	aCopy := super copy.	 "ports, compnents, couplings"
	aCopy comment: comment copy.
	aCopy agent: agent copy.
	"and now deepcopy of agent slots:"
	(aCopy agent slotNames difference: #(devs)) do: [ :slot | 
		aCopy agent perform: (slot,':') asSymbol with: (agent perform: slot asSymbol) deepCopy ]. 
	aCopy positions: positions copy.
	^  aCopy

]

{ #category : 'copying' }
CoupledDEVSPrototype >> couplingsStoreString [
	"a more readable version of self coupling storeString"

	| aStream |
	aStream := String new writeStream.
	aStream nextPutAll: '{'; nextPutAll: String cr.
	self couplings do: [ :coupling | 
		aStream nextPutAll: String tab; nextPutAll: '{'; 
			store: coupling key first; nextPutAll: '. '; store: coupling key second; nextPutAll: '} -> {'; 
			store: coupling value first; nextPutAll: '. '; store: coupling value second; nextPutAll: '}.'; 
			nextPutAll: String cr ].
	aStream nextPutAll: ' } asSet  '.

	^ aStream contents 

]

{ #category : 'copying' }
CoupledDEVSPrototype >> eq: anObject [

	anObject class = self class ifFalse: [ NonEqDetected signal. ^ false ].

	"ports"
	self inputPortNames asSortedCollection = anObject inputPortNames asSortedCollection ifFalse: [ NonEqDetected signal. ^ false ].
	self outputPortNames asSortedCollection = anObject outputPortNames asSortedCollection ifFalse: [ NonEqDetected signal. ^ false ].	

	"components"
	self componentNames asSortedCollection = anObject componentNames asSortedCollection ifFalse: [ NonEqDetected signal. ^ false ].	
	(self componentNames) do: [ :c | 
		((self componentNamed: c) eq: (anObject componentNamed: c)) ifFalse: [ NonEqDetected signal. ^ false ] ].

	"couplings"
	self couplings = anObject couplings  ifFalse: [ NonEqDetected signal. ^ false ].	

	^ true


]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> initialize [
	super initialize.
	
	agent ifNil: [ agent := (PrototypeObjectWithSharedCoupledBehavior new 
			"Reference to the coupled DEVS."
			addSlot: 'devs' withValue: self;
			yourself) ].

	"we save the models workspace in sources"
	"self saveWorkspace: String new." "?????????????????????"


]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> positions [
	^positions
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> positions: aDictionary [
	positions:=aDictionary
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> renameTo: aString [

	^self parent rename: self name to: aString asSymbol

]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> select: immList [

	^ (agent respondsTo: #select:) 
		ifTrue: [ agent perform: #select: withArguments: {immList} ] 
		ifFalse: [ super select: immList ]
]

{ #category : 'copying' }
CoupledDEVSPrototype >> storeOn: aStream [
	
	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' new'.		"initialized instance"
	aStream nextPutAll: ' name: '; store: self name; nextPut: $;; cr. 

	"ports"
	inputPorts keysAndValuesDo: [ :k :v | 
		aStream 
			nextPutAll: ' addInputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $;; 
			nextPutAll: String cr ].	
	outputPorts keysAndValuesDo: [ :k :v | 
		aStream 
			nextPutAll: ' addOutputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $;; 
			nextPutAll: String cr ].	

	"components"
	(components difference: namedComponents values) do: [ :c |
		aStream nextPutAll: 'addSubModel: '; store: c; nextPut: $; ; nextPutAll: String cr ].
	namedComponents keysAndValuesDo: [ :k :v |
		aStream nextPutAll: 'addSubModel: '; store: v; nextPutAll: ' named: '; store: k; nextPut: $;; nextPutAll: String cr ].

	"couplings"
	aStream nextPutAll: ' addCouplings: '.
	aStream nextPutAll: self couplingsStoreString; nextPut: $;; nextPutAll: String cr. 

	"positions"
	aStream nextPutAll: ' positions: '; store: self positions; nextPut: $;; cr. 

	"comment"
	aStream nextPutAll: ' comment: '; store: self comment asString; nextPut: $;; cr. 

	"agent - this is not good solution; it would be better to hide agent and add slots and methods via self - TO DO ?"
	(agent methodNames size > 0) ifTrue: [
		aStream nextPutAll: ' agent: '; store: self agent; nextPut: $;; cr ]. 

	aStream nextPutAll: ' yourself)'; nextPutAll: String cr
]

{ #category : 'as yet unclassified' }
CoupledDEVSPrototype >> workspace [
	^ comment
]
