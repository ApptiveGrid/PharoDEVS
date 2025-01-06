Class {
	#name : 'DEVnDESSRootSolverRT',
	#superclass : 'DEVSRootSolverRT',
	#instVars : [
		'tn',
		'h',
		'dh',
		'seDetected'
	],
	#category : 'SmallDEVS-Core-RT',
	#package : 'SmallDEVS-Core',
	#tag : 'RT'
}

{ #category : 'as yet unclassified' }
DEVnDESSRootSolverRT >> initialize [
	"a pure copy of the same method form non-RT  DEVnDESSRootSolver"

	super initialize.
	h := 0.01.

]

{ #category : 'as yet unclassified' }
DEVnDESSRootSolverRT >> numericStep [
	"a pure copy of the same method from non-RT  DEVnDESSRootSolver"

	clock + h < tn ifTrue: [ dh := h ] ifFalse: [ dh := tn - clock ].
	seDetected := false.
	rootDEVS receiveNMsgStarTime: clock step: dh.		"send (*, t, h) to root DEVS"
	rootDEVS receiveNMsgX: {} time: clock step: dh.		"send (x, t, h) to root DEVS"
	reportStream nextPutAll: '.'.
	seDetected ifTrue: [ 	| dhmin dhmax | dhmin := 0. dhmax := dh.
		[ seDetected & ((dhmax - dhmin) < 0.001) ] whileFalse: [ 
			reportStream nextPutAll: ':'.
			seDetected ifTrue: [ dhmax := dh ] ifFalse: [ dhmin := dh ].
			dh := (dhmax + dhmin)/2.
			seDetected := false.
			rootDEVS receiveNMsgStarTime: clock step: dh.		
			rootDEVS receiveNMsgX: {} time: clock step: dh.
				"Note: rootDEVS and consequently an AtomicDEVnDESS is repeatedly called 
				 for the same time. It is supposed that it remembers state and time 
				 from which last step was made. It must check time for which it is called
				 and either revert to previous state or save current state before making a
				 step." ] ].
	clock := clock + dh

]

{ #category : 'as yet unclassified' }
DEVnDESSRootSolverRT >> receiveMsgSETime: tnc [
	"a pure copy of the same method form non-RT  DEVnDESSRootSolver"

	seDetected := true.
	tnc < tn ifTrue: [ tn := tnc ] ifFalse: [ ((tnc - tn) closeTo: 0) ifFalse: [ self error: 'Bad sync !'] ]


]

{ #category : 'as yet unclassified' }
DEVnDESSRootSolverRT >> simulationStep [
	"Probably full of bugs."

	| inputOccured input msg  aSubModel interruptTime |

	rtFactor = 0 ifTrue: [ ^ self nonRTStep ].

	"Synchronize clock with real time"
	rtTimer := Timer at: ((startTime + ((clock min: stopTime) / rtFactor * 1000)) min: SmallInteger maxVal) rounded.
	rtTimer wait.		"Waiting can be interrupted by asynchronous internal or external event."

	"Accept potential interrupts"
	interruptTime := self realTime min: clock. 
	inputOccured := false.
	input := Dictionary new.
	[ (msg := inputQueue nextOrNil) == nil ] whileFalse: [ 
			input at: (rootDEVS inputPortNamed: msg first) put: msg second.
			inputOccured := true ].
	[ (aSubModel := seQueue nextOrNil) == nil ] whileFalse: [ 
			aSubModel sendMsgSETime: interruptTime ].
	inputOccured  ifTrue: [
			rootDEVS receiveMsgX: input time: interruptTime.	 "... put input & update event lists"
			verbose ifTrue: [
				reportStream nextPutAll: '* Root DEVS Input Port Configuration: ', String cr.			
				rootDEVS reportInputPortConfig ]].

	"Numeric step:"
	tn := rootDEVS timeNext. 
	(clock < tn) & (clock < stopTime) ifTrue: [ ^ self numericStep ].	"Note: We do not consider numeric input."

	self assert: [ clock = tn ].

	"Discrete step:"
	reportStream nextPutAll: '****************** simulation time, real time: ', 
		clock asFloat printString, ', ', self realTime asFloat printString, String cr.
	tn <= stopTime ifTrue: [ 
		rootDEVS receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
		verbose ifTrue: [
			reportStream nextPutAll: '* Root DEVS Output Port Configuration: ', String cr.
	 		rootDEVS reportOutputPortConfig ]].

]
