"
Part of MySystem3b. Built fo RT.
"
Class {
	#name : 'DEVSMyGenerator2',
	#superclass : 'DEVSMyGenerator',
	#instVars : [
		'process'
	],
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyGenerator2 >> finalize [

	process isNil ifFalse: [ process terminate. process := nil ]


]

{ #category : 'as yet unclassified' }
DEVSMyGenerator2 >> initialize [

	super initialize.

	process := [ 
		[ true ] whileTrue: [
			(Delay forSeconds: 5) wait. 
			self rootSolver stateEventIn: self ].	"force root solver to send (*, t) to self"
	] newProcess.
	process priority: Processor userBackgroundPriority.	
	
]

{ #category : 'as yet unclassified' }
DEVSMyGenerator2 >> prepareToStart [

	process isNil ifTrue: [ self initialize ].
	process resume.
	
]

{ #category : 'as yet unclassified' }
DEVSMyGenerator2 >> prepareToStop [

	process suspend.
	
]

{ #category : 'as yet unclassified' }
DEVSMyGenerator2 >> timeAdvance [

	^ Float infinity	
]
