Class {
	#name : 'DEVSTrafficLight',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'state',
		'changedState'
	],
	#category : 'DEVS-Examples-traffic-system',
	#package : 'DEVS-Examples',
	#tag : 'traffic-system'
}

{ #category : 'modeling' }
DEVSTrafficLight >> externalTransition [
	self internalTransition 
]

{ #category : 'modeling' }
DEVSTrafficLight >> initialize [
	super initialize.
	state := #green.
	self addInputPortNamed: #in
]

{ #category : 'modeling' }
DEVSTrafficLight >> internalTransition [
	| inputState oldState |
	oldState := state.
	inputState := self peekFrom: #in.
	(inputState ifNil: [^ self ]).
	(inputState beginsWith: name) 
		ifTrue: [ 
			(state = #red) ifTrue: [ state := #green ] ]
		ifFalse: [
			(state = #yellow) ifTrue: [ state := #red ].
			(state = #green) ifTrue: [ state := #yellow ] ].
	(state = oldState) ifFalse: [ 
		changedState := { #state -> ( oldState -> state ) } asDictionary ]
]

{ #category : 'as yet unclassified' }
DEVSTrafficLight >> logOutgoing [
	self emitEvent: (DEVSInternalTransitionEvent new 
		component: self;
		outgoing: self outgoingValues;
		stateChanges: changedState;
		timeNext: timeNext
		).
]

{ #category : 'modeling' }
DEVSTrafficLight >> outputFunction [
	
]

{ #category : 'modeling' }
DEVSTrafficLight >> prepareToStart [ 
	state := #red 
]

{ #category : 'modeling' }
DEVSTrafficLight >> timeAdvance [

	state caseOf: {
		[ #green ] 		-> [ ^ 57 ].
		[ #yellow ] 	-> [ ^ 3 ].
		[ #red ] 		-> [ ^ 60 ].
	} otherwise: [ self error ].

]
