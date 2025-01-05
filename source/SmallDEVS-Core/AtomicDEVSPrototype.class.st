"
Clonable and editable version of AtomicDEVS for classless model construction.
Uses PrototypeObject from Squeak Prototype package.


"
Class {
	#name : #AtomicDEVSPrototype,
	#superclass : #AtomicDEVS,
	#instVars : [
		'model',
		'comment'
	],
	#classVars : [
		'AtomicDEVSDefaultTrait'
	],
	#category : #'SmallDEVS-Core-Prototypes'
}

{ #category : #'as yet unclassified' }
AtomicDEVSPrototype class >> defaultTrait [

	(Smalltalk at: #MyRepository ifAbsent: [nil]) notNil 
	& AtomicDEVSDefaultTrait isNil ifTrue: [
		AtomicDEVSDefaultTrait := (Smalltalk at: #MyRepository) at: 'DEVSTraitsAndPrototypes/AtomicDEVSDefaultTrait' ].

	AtomicDEVSDefaultTrait ifNil: [ 
		AtomicDEVSDefaultTrait := PrototypeObjectForMyRepository new 
			addMethod: 'prepareToStart';
			addMethod: 'prepareToStop';
			addMethod: 'intTransition';
			addMethod: 'extTransition';
			addMethod: 'outputFnc';
			addMethod: 'timeAdvance
	^(Float infinity)';
			addMethod: 'initModel';
			yourself ].
	
	"DefaultTrait should reside somewhere in MyRepository. 
	If not, put it there (on default place) if MyRepository exists."
	(Smalltalk at: #MyRepository ifAbsent: [nil]) ifNotNil: [
		(Smalltalk at: #MyRepository) 
			at: 'DEVSTraitsAndPrototypes/AtomicDEVSDefaultTrait' 
			ifAbsent: [
				(Smalltalk at: #MyRepository) 
					at: 'DEVSTraitsAndPrototypes/AtomicDEVSDefaultTrait' 
					put: AtomicDEVSDefaultTrait ]].
	^ AtomicDEVSDefaultTrait

]

{ #category : #examples }
AtomicDEVSPrototype class >> example1 [
	"(AtomicDEVSPrototype example1 getSimulatorRT deepVerbose: true) simulate: 30"
	"An example of classless construction of a DEVS model."
	| system generator processor jobPrototype |

	jobPrototype := PrototypeObject new. 	
	jobPrototype addSlots: { 'n' -> 0.  'size' -> 0.  'name' -> 'aJob'. }.
	jobPrototype addMethod: 'setSizeBetween: sl and: sh       
		self size: (sl to: sh) atRandom'.
	
	generator := AtomicDEVSPrototype new.
	generator addSlots: {
		'jobPrototype' -> jobPrototype.
		'ia' -> 2.			'ib' -> 7. 
		'sa' -> 5. 		'sb' 	-> 10.
		'first' ->	true.	'n' -> 0. }.	"n is number of jobs generated"
	generator intTransition: 'self first: false'.
	generator outputFnc:	'self n: self n +1. self poke: (	
		(self jobPrototype setSizeBetween: self sa and: self sb) clone n: self n; yourself) to: #out'.		
	generator timeAdvance: '^ self first ifTrue: [ 0 ] ifFalse: [ (self ia to: self ib) atRandom ]'.
	generator addOutputPortNamed: #out.

	processor := AtomicDEVSPrototype new.
	processor addSlots: { 
		'queue' -> OrderedCollection new.
		'queueSize' -> 5.
		'processorStatus' ->  #idle.
		'currentJob' ->  nil.
		'timeSpent' -> 0 }.
	processor addInputPortNamed: #in.
	processor addOutputPortNamed: #out.
	processor addOutputPortNamed: #discard.
	processor intTransition: '		
	  self processorStatus caseOf: {
		[ #busy ] -> [
			self queue size > 0 
				ifTrue: [ 
					self currentJob: (self queue removeFirst) ]
				ifFalse: [ 
					self processorStatus: #idle.
					self currentJob: nil ].
			self timeSpent: 0 ].
		[ #discard ] -> [
			self queue removeFirst.
			self queue size <= self queueSize ifTrue: [
				self processorStatus: #busy ]].
		[ #idle ] -> [ "nothing" ] } '.
	processor extTransition: '
	  self queue add: (self peekFrom: #in).		
  	  self processorStatus caseOf: {
		[ #idle ] -> [
			self processorStatus: #busy.
			self currentJob: (self queue removeFirst) ].
		[ #busy ] -> [
			self timeSpent: self timeSpent + self elapsed.
			self queue size > self queueSize ifTrue: [ self processorStatus: #discard ]].
		[ #discard ] -> [ "nothing" ] } '.
	processor outputFnc:	'
	  self processorStatus caseOf: {
		[ #busy ] -> [ self poke: self currentJob to: #out ].
		[ #discard ] -> [ self poke: (self queue last) to: #discard ].
		[ #idle ] -> [ "nothing" ] } '.		
	processor timeAdvance: '
	  self processorStatus caseOf: {
		[ #busy ] 	-> [ ^ self currentJob size - self timeSpent ].
		[ #discard ] 	-> [ ^ 0 ].
		[ #idle ] 		-> [ ^ Float infinity ] } '.

	system := CoupledDEVSPrototype new.
	system name: 'Generator and Processor'.
	system addOutputPorts: {
		#out.
		#discard }.
	system addComponents: {
		#generator -> generator.
		#processor -> processor }. 
	system addCouplings: { 
		#(generator out) 	-> #(processor in).
		#(processor out) 	-> #(self out).
		#(processor discard) -> #(self discard) }.

	^ system 


]

{ #category : #examples }
AtomicDEVSPrototype class >> example2 [
	"(AtomicDEVSPrototype example2 getSimulator deepVerbose: true) simulate: 500"
	"An example of classless construction of a DEVS model."
	"3 processors are clones of a processor prototype. Deep copies. No shared information."
	| system generator processor jobPrototype previousPort newProcessor newProcessorName |

	jobPrototype := PrototypeObject new. 	
	jobPrototype addSlots: { 'n' -> 0.  'size' -> 0.  'name' -> 'aJob'. }.
	jobPrototype addMethod: 'setSizeBetween: sl and: sh       
		self size: (sl to: sh) atRandom'.
	
	generator := AtomicDEVSPrototype new.
	generator addSlots: {
		'jobPrototype' -> jobPrototype.
		'ia' -> 2. "interval min"		'ib' -> 7. "interval max"
		'sa' -> 5. "job size min"		'sb' -> 10. "job size max"
		'first' -> true.		'n' -> 0. }.	"n is number of jobs generated"
	generator intTransition: 'self first: false'.
	generator outputFnc:	'self n: self n +1. self poke: (	
		(self jobPrototype setSizeBetween: self sa and: self sb) clone n: self n; yourself) to: #out'.		
	generator timeAdvance: '^ self first ifTrue: [ 0 ] ifFalse: [ (self ia to: self ib) atRandom ]'.
	generator addOutputPortNamed: #out.

	processor := AtomicDEVSPrototype new.
	processor addSlots: { 
		'queue' -> OrderedCollection new.
		'queueSize' -> 5.
		'processorStatus' ->  #idle.
		'currentJob' ->  nil.
		'timeSpent' -> 0 }.
	processor addInputPorts: {#in}.
	processor addOutputPorts: {#out. #discard}.
	processor intTransition: '		
	  self processorStatus caseOf: {
		[ #busy ] -> [
			self queue size > 0 
				ifTrue: [ 
					self currentJob: (self queue removeFirst) ]
				ifFalse: [ 
					self processorStatus: #idle.
					self currentJob: nil ].
			self timeSpent: 0 ].
		[ #discard ] -> [
			self queue removeFirst.
			self queue size <= self queueSize ifTrue: [
				self processorStatus: #busy ]].
		[ #idle ] -> [ "nothing" ] } '.
	processor extTransition: '
	  self queue add: (self peekFrom: #in).		
  	  self processorStatus caseOf: {
		[ #idle ] -> [
			self processorStatus: #busy.
			self currentJob: (self queue removeFirst) ].
		[ #busy ] -> [
			self timeSpent: self timeSpent + self elapsed.
			self queue size > self queueSize ifTrue: [ self processorStatus: #discard ]].
		[ #discard ] -> [ "nothing" ] } '.
	processor outputFnc:	'
	  self processorStatus caseOf: {
		[ #busy ] -> [ self poke: self currentJob to: #out ].
		[ #discard ] -> [ self poke: (self queue last) to: #discard ].
		[ #idle ] -> [ "nothing" ] } '.		
	processor timeAdvance: '
	  self processorStatus caseOf: {
		[ #busy ] 	-> [ ^ self currentJob size - self timeSpent ].
		[ #discard ] 	-> [ ^ 0 ].
		[ #idle ] 		-> [ ^ Float infinity ] } '.

	system := CoupledDEVSPrototype new.
	system name: 'Generator and 3 Processors'.
	system addOutputPorts: { #out. #discard }.
	system addComponents: { #generator -> generator }. 
	previousPort := {#generator. #out}.
	1 to: 3 do: [ :i | 
		newProcessor := processor copy.
		newProcessorName := (#processor, i printString) asSymbol.
		system addComponents: { newProcessorName -> newProcessor }. 
		system addCouplings: { 
			previousPort 	-> {newProcessorName. #in}.
			{newProcessorName. #out} 	-> {#self. #out} }.
		previousPort := {newProcessorName. #discard} 
	].
	system addCouplings: { 
		{newProcessorName. #discard} -> {#self. #discard} }.

	^ system 


]

{ #category : #examples }
AtomicDEVSPrototype class >> example3 [
	"(AtomicDEVSPrototype example3 getSimulator deepVerbose: true) simulate: 500"
	"An example of classless construction of a DEVS model."
	"3 processors are clones of a processor prototype. Shared behavior and data are in a trait."
	| system generator processorPrototype jobPrototype previousPort newProcessor newProcessorName processorTrait |

	jobPrototype := PrototypeObject new. 	
	jobPrototype addSlots: { 'n' -> 0.  'size' -> 0.  'name' -> 'aJob'. }.
	jobPrototype addMethod: 'setSizeBetween: sl and: sh       
		self size: (sl to: sh) atRandom'.
	
	generator := AtomicDEVSPrototype new.
	generator addSlots: {
		'jobPrototype' -> jobPrototype.
		'ia' -> 2. "interval min"		'ib' -> 7. "interval max"
		'sa' -> 5. "job size min"		'sb' -> 10. "job size max"
		'first' -> true.		'n' -> 0. }.	"n is number of jobs generated"
	generator intTransition: 'self first: false'.
	generator outputFnc:	'self n: self n +1. self poke: (	
		(self jobPrototype setSizeBetween: self sa and: self sb) clone n: self n; yourself) to: #out'.		
	generator timeAdvance: '^ self first ifTrue: [ 0 ] ifFalse: [ (self ia to: self ib) atRandom ]'.
	generator addOutputPorts: {#out}.

	processorTrait := AtomicDEVSTrait new.
	"For sharing even after serialization and copying, it's a good idea to store it in MyRepository: "
	MyRepository 
		at: 'DEVSTraitsAndPrototypes/GeneratorProcessor/ProcessorTrait' 
		put: processorTrait.
	processorTrait addMethod: 'intTransition		
	  self processorStatus caseOf: {
		[ #busy ] -> [
			self queue size > 0 
				ifTrue: [ 
					self currentJob: (self queue removeFirst) ]
				ifFalse: [ 
					self processorStatus: #idle.
					self currentJob: nil ].
			self timeSpent: 0 ].
		[ #discard ] -> [
			self queue removeFirst.
			self queue size <= self queueSize ifTrue: [
				self processorStatus: #busy ]].
		[ #idle ] -> [  ] } '.
	processorTrait addMethod: ' extTransition
	  self queue add: (self peekFrom: #in).		
  	  self processorStatus caseOf: {
		[ #idle ] -> [
			self processorStatus: #busy.
			self currentJob: (self queue removeFirst) ].
		[ #busy ] -> [
			self timeSpent: self timeSpent + self elapsed.
			self queue size > self queueSize ifTrue: [ self processorStatus: #discard ]].
		[ #discard ] -> [  ] } '.
	processorTrait addMethod: ' outputFnc	
	  self processorStatus caseOf: {
		[ #busy ] -> [ self poke: self currentJob to: #out ].
		[ #discard ] -> [ self poke: (self queue last) to: #discard ].
		[ #idle ] -> [  ] } '.		
	processorTrait addMethod: ' timeAdvance 
	  self processorStatus caseOf: {
		[ #busy ] 	-> [ ^ self currentJob size - self timeSpent ].
		[ #discard ] 	-> [ ^ 0 ].
		[ #idle ] 		-> [ ^ Float infinity ] } '.

	processorPrototype := AtomicDEVSPrototype new.
	processorPrototype addSlots: { 
		'queue' -> OrderedCollection new.
		'queueSize' -> 5.
		'processorStatus' ->  #idle.
		'currentJob' ->  nil.
		'timeSpent' -> 0 }.
	processorPrototype addInputPorts: {#in}.
	processorPrototype addOutputPorts: {#out. #discard}.
	processorPrototype addDelegate: 'defaultTrait' withValue: processorTrait.

	system := CoupledDEVSPrototype new.
	system name: 'Generator and 3 Processors with Shared Behavior'.
	system addOutputPorts: { #out. #discard }.
	system addComponents: { #generator -> generator }. 
	previousPort := {#generator. #out}.
	1 to: 3 do: [ :i | 
		newProcessor := processorPrototype copy.
		newProcessorName := (#processor, i printString) asSymbol.
		system addComponents: { newProcessorName -> newProcessor }. 
		system addCouplings: { 
			previousPort 	-> {newProcessorName. #in}.
			{newProcessorName. #out} 	-> {#self. #out} }.
		previousPort := {newProcessorName. #discard} 
	].
	system addCouplings: { 
		{newProcessorName. #discard} -> {#self. #discard} }.

	^ system 


]

{ #category : #'as yet unclassified' }
AtomicDEVSPrototype class >> resetTrait [
	AtomicDEVSDefaultTrait := nil
]

{ #category : #modeling }
AtomicDEVSPrototype >> addDelegate: slotName withValue: value [

	model addDelegate: slotName withValue: value
]

{ #category : #modeling }
AtomicDEVSPrototype >> addMethod: code [

	^ model addMethod: code
]

{ #category : #modeling }
AtomicDEVSPrototype >> addSlot: slotName [

	model addSlot: slotName
]

{ #category : #modeling }
AtomicDEVSPrototype >> addSlot: slotName withValue: value [

	model addSlot: slotName withValue: value
]

{ #category : #modeling }
AtomicDEVSPrototype >> addSlots: slots [

	slots do: [ :assoc | model addSlot: assoc key withValue: assoc value ].

]

{ #category : #modeling }
AtomicDEVSPrototype >> comment [
	^comment
]

{ #category : #modeling }
AtomicDEVSPrototype >> comment: aString [
	comment := aString.
]

{ #category : #initialization }
AtomicDEVSPrototype >> defaultTrait [
	^ self class defaultTrait
]

{ #category : #modeling }
AtomicDEVSPrototype >> delegateAt: aName [
  ^model perform: (aName asSymbol).
]

{ #category : #modeling }
AtomicDEVSPrototype >> delegateNames [

	^ model delegateNames
]

{ #category : #copying }
AtomicDEVSPrototype >> eq: anObject [

	| model2 |
	anObject class = self class ifFalse: [ NonEqDetected signal. ^ false ].

	model2 := anObject instVarNamed: 'model'.

	"ports"
	(self inputPortNames asSortedCollection = anObject inputPortNames asSortedCollection) ifFalse: [ NonEqDetected signal. ^ false ].
	(self outputPortNames asSortedCollection = anObject outputPortNames asSortedCollection) ifFalse: [ NonEqDetected signal. ^ false ].	

	"slots"
	(model slotNames difference: {'parent'. 'atomic'}) do: [ :slot | 
		((model perform: slot asSymbol) eq: (model2 perform: slot asSymbol)) ifFalse: [ NonEqDetected signal. ^ false ] ].

	"delegates"
	(model delegateNames) do: [ :slot | 	
		((model perform: slot asSymbol) eq: (model2 perform: slot asSymbol)) ifFalse: [ NonEqDetected signal. ^ false ] ].

	"methods"
	(model methodNames) do: [ :n | 
		((model methodSourceAt: n) eq: (model2 methodSourceAt: n)) ifFalse: [ NonEqDetected signal. ^ false ] ].

	^ true


]

{ #category : #private }
AtomicDEVSPrototype >> extTransition [

	^ model extTransition

]

{ #category : #modeling }
AtomicDEVSPrototype >> extTransition: code [
	^ self addMethod: 'extTransition ',code.


]

{ #category : #private }
AtomicDEVSPrototype >> finalize [
	super finalize.
	[ model finalize ] on: Error do: [].

]

{ #category : #modeling }
AtomicDEVSPrototype >> finalize: code [
	^ self addMethod: 'finalize ', code.

]

{ #category : #private }
AtomicDEVSPrototype >> initModel [

	model initModel.
]

{ #category : #initialization }
AtomicDEVSPrototype >> initialize [
	super initialize.
	
	"Model is implemented by nested prototype object"
	model ifNil: [ model := (PrototypeObjectWithSharedAtomicBehavior new 
			"Reference to the atomic DEVS."
			addSlot: 'atomic' withValue: self;
			"Shared behavior"	
			addDelegate: 'defaultTrait' withValue: self defaultTrait;
			yourself) ].

	self comment: String new.


]

{ #category : #private }
AtomicDEVSPrototype >> intTransition [

	^ model intTransition
]

{ #category : #modeling }
AtomicDEVSPrototype >> intTransition: code [
	^ self addMethod: 'intTransition ', code.

]

{ #category : #private }
AtomicDEVSPrototype >> longPrintOn: aStream [
	"Prints DEVS state, i.e. some slots of the model."

	(model slotNames difference: #(atomic sources)) do: [ :title |
			aStream nextPutAll: '        ';
			 nextPutAll: title;
			 nextPut: $:;
			 space;
			 tab;
			 print: (model perform: title asSymbol);
			cr].





]

{ #category : #modeling }
AtomicDEVSPrototype >> methodExists: aString [
  ^self model methodNames includes: aString asSymbol
]

{ #category : #private }
AtomicDEVSPrototype >> methodNames [
  ^(model methodNames asArray) collect: [ :e | e asString ].
]

{ #category : #modeling }
AtomicDEVSPrototype >> methodSourceAt: aName [
	^model methodSourceAt: aName asSymbol.

]

{ #category : #private }
AtomicDEVSPrototype >> model [
  ^model
]

{ #category : #private }
AtomicDEVSPrototype >> outputFnc [

	^ model outputFnc


]

{ #category : #modeling }
AtomicDEVSPrototype >> outputFnc: code [
	^ self addMethod: 'outputFnc ', code.

]

{ #category : #copying }
AtomicDEVSPrototype >> postCopy [
	"Makes shalow copy of model and then makes deepcopy of all its slots which are not pointing to well known shareable objects residing in MyRepository. Delegates are considered allways to be shared (i.e. not copied) even if the are not well known (note that it is not good idea to have such delegates)."
	
	| shared |
	shared := model slotNames select: [ :s || o | "objects in MyRepository"
		o := (model perform: s asSymbol). (MyRepository pathNameForObject: o) size > 0 ].
	"Searching for shared objects is slooooooow. It would be better to add parent inst. var. to PrototypeObjectForMyrRepository - TO DO as part of next big refactoring of AtomicDEVSPrototype !!!!"
	model := model clone. 
	(model slotNames difference: #(atomic sources), shared) do: [ :slot | 
		model perform: (slot,':') asSymbol with: 
			"(model perform: slot asSymbol) deepCopy"
			(Object readSixxFrom: (model perform: slot asSymbol) sixxString) "slow, but robust deepCopy"
			"but wouldn't be better to do all copying this way????'" ]. 
	model atomic: self.
	model parent: nil.


]

{ #category : #private }
AtomicDEVSPrototype >> prepareToStart [

	model prepareToStart

]

{ #category : #modeling }
AtomicDEVSPrototype >> prepareToStart: code [
	^ self addMethod: 'prepareToStart ', code.


]

{ #category : #private }
AtomicDEVSPrototype >> prepareToStop [

	model prepareToStop.

]

{ #category : #modeling }
AtomicDEVSPrototype >> prepareToStop: code [
	^ self addMethod: 'prepareToStop ', code.

]

{ #category : #modeling }
AtomicDEVSPrototype >> removeDelegate: aString [

	model removeDelegate: aString
]

{ #category : #modeling }
AtomicDEVSPrototype >> removeMethod: aString [
	model removeMethod: (aString asSymbol).
]

{ #category : #modeling }
AtomicDEVSPrototype >> removeSlot: aString [
  model removeSlot: aString
]

{ #category : #private }
AtomicDEVSPrototype >> slotNames [
  ^(model slotNames asArray) collect: [ :e | e asString ].
]

{ #category : #modeling }
AtomicDEVSPrototype >> slotValueAt: aName [
  ^model perform: (aName asSymbol).
]

{ #category : #private }
AtomicDEVSPrototype >> sources [
  ^ model sources
]

{ #category : #copying }
AtomicDEVSPrototype >> storeOn: aStream [

	"Note: #storeOn: is dangerous if objects pointed by slots can not store themselves correctly (without infinite looping) !!!"

	aStream nextPut: $(; nextPutAll: self class name, ' new'.
	aStream nextPutAll: ' name: '; store: self name; nextPut: $;; cr. 

	"selected inst vars"
	{"'timeLast'. 'timeNext'." 'elapsed'. 'savedTimeAdvance' } do: [:n |
		aStream nextPutAll: ' instVarNamed: ';
			store: n;
			nextPutAll: ' put: ';
			store: (self instVarNamed: n);
			nextPut: $;; cr ].

	"ports"
	aStream nextPutAll: ' removeAllPorts;'; nextPutAll: String cr. 	"empty port dictionary installed"
	inputPorts keysAndValuesDo: [ :k :v | 
		aStream 
			nextPutAll: ' addInputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $;; cr ].	
	outputPorts keysAndValuesDo: [ :k :v | 
		aStream 
			nextPutAll: ' addOutputPortOfType: '; store: v species; nextPutAll: ' named: '; store: k; nextPut: $;; cr ].	

	"slots"
	(model slotNames difference: #(atomic sources)) do: [ :slot | 
		aStream 
			nextPutAll: 'addSlot: '; store: slot; 
			nextPutAll: ' withValue: '; 
			store: ((model excludedSlots includes: slot) ifTrue: [nil] ifFalse:[
				(TemporarySymlink toObject: (model perform: slot asSymbol))]); 
			nextPut: $;; cr].

	"delegates"
	aStream nextPutAll: 'removeDelegate: ''defaultTrait'';'; cr.	"defaultTrait has to be removed !"
	(self delegateNames) do: [ :slot | 
		aStream 
			nextPutAll: 'addDelegate: '; store: slot; 
			nextPutAll: ' withValue: '; 
			store: (TemporarySymlink toObject: (model perform: slot asSymbol)); 
			nextPut: $;; cr].

	"methods"
	(model methodNames difference: #(DoIt)) do: [ :slot | 
		aStream 
			nextPutAll: 'addMethod: '; store: (self sources at: slot); nextPut: $;; cr ].

	"comment/workspace"
	(self sources ifNotNil: [ self sources at: #workspace ifAbsent: ['']] ifNil: ['']) size > 0 ifTrue: [
		aStream 
			nextPutAll: 'comment: '; store: self comment; nextPut: $;; cr ].

	aStream nextPutAll: ' yourself)'; cr

]

{ #category : #private }
AtomicDEVSPrototype >> timeAdvance [

	^ model timeAdvance

]

{ #category : #modeling }
AtomicDEVSPrototype >> timeAdvance: code [
	^ self addMethod: 'timeAdvance ', code.

]
