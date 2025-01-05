"
This wrapper wraps a simulator with independent time. Simulation can be controlled by events on input ports.

TO DO: eventsOut
"
Class {
	#name : #DEVSToDEVSWrapper,
	#superclass : #DEVSWrapper,
	#instVars : [
		'rootSolver',
		'phase',
		'request',
		'eventsOut',
		'reportOut'
	],
	#category : #'SmallDEVS-Core-Wrapping'
}

{ #category : #wrapper }
DEVSToDEVSWrapper >> balloonText [

	^ 'Nested simulation'
]

{ #category : #wrapper }
DEVSToDEVSWrapper >> componentNames [
  ^ rootSolver rootDEVS componentNames
]

{ #category : #wrapper }
DEVSToDEVSWrapper >> doesNotUnderstand: message [
	"delegate the other messages to the nested rootSolver"
	"Transcript show: 'WRAPPER: Delegating to root DEVS: ', message printString; cr."
	^ rootSolver perform: message selector withArguments: message arguments.


]

{ #category : #devs }
DEVSToDEVSWrapper >> extTransition [

	(self peekFrom: #start) ifNotNil: [ rootSolver start. phase := #running ].
	(self peekFrom: #stop) ifNotNil: [ rootSolver stop. phase := #stopped ].
	(self peekFrom: #stoptime) ifNotNil: [ rootSolver stopTime: (self peekFrom: #stoptime) ].
	(self peekFrom: #reset) ifNotNil: [ rootSolver reset ].
	(self peekFrom: #modelIn) ifNotNil: [ rootSolver rootDEVS: (self peekFrom: #modelIn) ].
	(self peekFrom: #getModel) ifNotNil: [ request := #modelOut ].
	(self peekFrom: #getStatus) ifNotNil: [ request := #statusOut ].

]

{ #category : #wrapper }
DEVSToDEVSWrapper >> fullName [
	^ rootSolver name, ' [', (rootSolver isRunning ifTrue: ['R'] ifFalse: ['S']) , ']'
]

{ #category : #initialization }
DEVSToDEVSWrapper >> initialize [

	super initialize.
	self addInputPorts: #(start stop stoptime reset modelIn getModel getStatus). 
	self addOutputPorts: #(modelOut justStarted justStopped statusOut eventsOut reportOut).
	rootSolver := DEVSRootSolverRTForWrapping new.
	rootSolver parent: self.
	rootSolver rootDEVS: CoupledDEVSPrototype new.
	rootSolver reportStream: SharedQueue new.
	rootSolver rootDEVS name: self name.
	"TODO: rootSolver rootDEVS eventStream: SharedQueue new."
	phase := #stopped.

]

{ #category : #devs }
DEVSToDEVSWrapper >> intTransition [

	request := nil.
	[ reportOut := rootSolver reportStream getContentsOrNilAndFlush ]  "must be SharedQueue"
		on: MessageNotUnderstood do: [ reportOut := nil].
	reportOut ifNotNil: [ reportOut := String newFrom: reportOut ].
	
	"TO DO:
	[ eventsOut := rootSolver eventStream getContentsOrNilAndFlush ]  
		on: MessageNotUnderstood do: [ eventsOut := nil].	"

]

{ #category : #wrapper }
DEVSToDEVSWrapper >> name [
  ^ rootSolver rootDEVS name
]

{ #category : #wrapper }
DEVSToDEVSWrapper >> name: n [
	name := n.
	rootSolver name: n.
	^ rootSolver rootDEVS name: n
]

{ #category : #devs }
DEVSToDEVSWrapper >> outputFnc [

	request caseOf: {
		[nil] -> [].
		[#modelOut] -> [self poke: rootSolver rootDEVS to: #modelOut].
		[#statusOut] -> [self poke: phase to: #statusOut] }.
	eventsOut ifNotNil: [self poke: eventsOut to: #eventsOut].
	reportOut ifNotNil: [self poke: reportOut to: #reportOut].

]

{ #category : #wrapper }
DEVSToDEVSWrapper >> parent [
  ^ rootSolver rootDEVS parent
]

{ #category : #wrapper }
DEVSToDEVSWrapper >> parent: p [
	parent := p.
"	rootSolver parent: p. "

]

{ #category : #devs }
DEVSToDEVSWrapper >> prepareToStart [

	phase = #running ifTrue: [ rootSolver start ].
]

{ #category : #devs }
DEVSToDEVSWrapper >> prepareToStop [

	rootSolver isRunning ifTrue: [ phase := #running. rootSolver stop ].

]

{ #category : #devs }
DEVSToDEVSWrapper >> timeAdvance [

	^ ((request ifNil: [Float infinity] ifNotNil: [0])
	 	min: (eventsOut ifNil: [Float infinity] ifNotNil: [0]))
			min: (reportOut ifNil: [Float infinity] ifNotNil: [0])
	
]
