"
Part of MySystem
"
Class {
	#name : 'DEVSMyProcessor',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'queue',
		'queueSize',
		'processorStatus',
		'currentJob',
		'timeSpent'
	],
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyProcessor class >> withQueueSize: n [

	^ super new initialize queueSize: n
]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> extTransition [

	| job |

	job := self peekFrom: #in.
	queue add: job.

	processorStatus caseOf: {
		[ #idle ] -> [
			processorStatus := #busy.
			currentJob := queue removeFirst ].

		[ #busy ] -> [
			timeSpent := timeSpent + elapsed.
			queue size > queueSize ifTrue: [ processorStatus := #discard ]].

		[ #discard ] -> [ "nothing" ]
	}


]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> initialize [

	super initialize.

	queue := OrderedCollection new.
	queueSize := 0.
	processorStatus := #idle.
	currentJob := nil.
	timeSpent := 0.
	self addInputPortNamed: #in.
	self addOutputPortNamed: #out.
	self addOutputPortNamed: #discard.


]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> intTransition [

	processorStatus caseOf: {
		[ #busy ] -> [
			queue size > 0 
				ifTrue: [ 
					currentJob := queue removeFirst ]
				ifFalse: [ 
					processorStatus := #idle.
					currentJob := nil ].
			timeSpent := 0 ].

		[ #discard ] -> [
			queue removeFirst.
			queue size <= queueSize ifTrue: [
				processorStatus := #busy ]].

		[ #idle ] -> [ "nothing" ].
	}


]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> outputFnc [

	processorStatus caseOf: {
		[ #busy ] -> [
			self poke: currentJob to: #out ].

		[ #discard ] -> [
			self poke: (queue last) to: #discard ].

		[ #idle ] -> [ "nothing" ].
	}


]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> queueSize: n [

	queueSize := n
]

{ #category : 'as yet unclassified' }
DEVSMyProcessor >> timeAdvance [

	processorStatus caseOf: {
		[ #busy ] 		-> [ ^ currentJob size - timeSpent ].
		[ #discard ] 	-> [ ^ 0 ].
		[ #idle ] 		-> [ ^ Float infinity ].
	} otherwise: [ self error ].

]
