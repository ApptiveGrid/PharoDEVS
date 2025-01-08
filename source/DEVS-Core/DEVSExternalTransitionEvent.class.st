Class {
	#name : 'DEVSExternalTransitionEvent',
	#superclass : 'DEVSComponentEvent',
	#instVars : [
		'incoming'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSExternalTransitionEvent class >> displayLabel [
	^ #external
]

{ #category : 'as yet unclassified' }
DEVSExternalTransitionEvent >> incoming: aCollection [ 
	incoming := aCollection
]

{ #category : 'accessing' }
DEVSExternalTransitionEvent >> payload [
	^ String streamContents: [:s |
		s << 'incoming: ' << ($, join: incoming associations) ]
]
