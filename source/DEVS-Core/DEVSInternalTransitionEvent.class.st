Class {
	#name : 'DEVSInternalTransitionEvent',
	#superclass : 'DEVSComponentEvent',
	#instVars : [
		'outgoing'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSInternalTransitionEvent class >> displayLabel [
	^ #internal
]

{ #category : 'as yet unclassified' }
DEVSInternalTransitionEvent >> outgoing: aCollection [ 
	outgoing := aCollection 
]

{ #category : 'accessing' }
DEVSInternalTransitionEvent >> payload [
	^ String streamContents: [:s |
		stateChanges 
			ifNotNil: [ s << 'state: ' << ($, join: stateChanges associations)  ]
			ifNil: [ 'N/A' ].
		s << 'outgoing: ' << ($, join: outgoing associations) ]
]
