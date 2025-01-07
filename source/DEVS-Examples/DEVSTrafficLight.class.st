Class {
	#name : 'DEVSTrafficLight',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'state'
	],
	#category : 'DEVS-Examples-traffic-system',
	#package : 'DEVS-Examples',
	#tag : 'traffic-system'
}

{ #category : 'modeling' }
DEVSTrafficLight >> externalTransition [
	| inputState |
	inputState := self peekFrom: #in.
	(inputState ifNil: [^ self ]).
	(inputState beginsWith: name) 
		ifTrue: [ 
			(state = #red) ifTrue: [ state := #green ] ]
		ifFalse: [
			(state = #yellow) ifTrue: [ state := #red ].
			(state = #green) ifTrue: [ state := #yellow ] ] .
	self reportStream nextPutAll: '----> ', name ,' state is now ', state, String cr.

]

{ #category : 'modeling' }
DEVSTrafficLight >> initialize [
	super initialize.
	state := #green.
	self addInputPortNamed: #in
]

{ #category : 'modeling' }
DEVSTrafficLight >> internalTransition [
	self externalTransition 
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
