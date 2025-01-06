"
Part of MySystem
"
Class {
	#name : 'MyProcessor',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'queue',
		'queueSize',
		'processorStatus',
		'currentJob',
		'timeSpent'
	],
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MyProcessor class >> withQueueSize: n [

	^ super new initialize queueSize: n
]

{ #category : 'as yet unclassified' }
MyProcessor >> extTransition [

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
MyProcessor >> initialize [

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
MyProcessor >> intTransition [

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
MyProcessor >> outputFnc [

	processorStatus caseOf: {
		[ #busy ] -> [
			self poke: currentJob to: #out ].

		[ #discard ] -> [
			self poke: (queue last) to: #discard ].

		[ #idle ] -> [ "nothing" ].
	}


]

{ #category : 'as yet unclassified' }
MyProcessor >> queueSize: n [

	queueSize := n
]

{ #category : 'as yet unclassified' }
MyProcessor >> timeAdvance [

	processorStatus caseOf: {
		[ #busy ] 		-> [ ^ currentJob size - timeSpent ].
		[ #discard ] 	-> [ ^ 0 ].
		[ #idle ] 		-> [ ^ Float infinity ].
	} otherwise: [ self error ].

]
