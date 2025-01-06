Class {
	#name : 'DEVnDESSRootSolver',
	#superclass : 'DEVSRootSolver',
	#instVars : [
		'tn',
		'h',
		'dh',
		'seDetected'
	],
	#category : 'SmallDEVS-Core-Continuous',
	#package : 'SmallDEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'OBSOLETE ???' }
DEVnDESSRootSolver >> bigStep [

		tn := rootDEVS timeNext. 

		[ (clock < tn) & (clock < stopTime) ] whileTrue: [ 
			self numericStep ].
		rootDEVS reportStream nextPutAll: String cr.

		tn <= stopTime ifTrue: [ 
			clock := tn.
			rootDEVS reportStream nextPutAll: 
				'****************** time: ', clock printString, String cr.
			rootDEVS receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
			rootDEVS verbose ifTrue: [
				rootDEVS reportStream nextPutAll: 
					'* Root DEVS Output Port Configuration: ', String cr.
		 		rootDEVS reportOutputPortConfig ]].


]

{ #category : 'simulation' }
DEVnDESSRootSolver >> initialize [

	super initialize.
	h := 0.01.

]

{ #category : 'simulation' }
DEVnDESSRootSolver >> numericStep [

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

{ #category : 'simulation' }
DEVnDESSRootSolver >> receiveMsgSETime: tnc [

	seDetected := true.
	tnc < tn ifTrue: [ tn := tnc ] ifFalse: [ ((tnc - tn) closeTo: 0) ifFalse: [ self error: 'Bad sync !'] ]


]

{ #category : 'OBSOLETE ???' }
DEVnDESSRootSolver >> simulateB: t [

	stopTime := t.

	[ clock < stopTime ] whileTrue: [ 
		self bigStep ].

	rootDEVS reportStream flush.


]

{ #category : 'simulation' }
DEVnDESSRootSolver >> simulationStep [

	"Numeric step:"
	tn := rootDEVS timeNext. 
	(clock < tn) & (clock < stopTime) ifTrue: [ ^ self numericStep ].

	"Discrete step:"
	reportStream nextPutAll: String cr.
	tn <= stopTime ifTrue: [ 
		clock := tn.
		reportStream nextPutAll: '****************** time: ', clock printString, String cr.
		rootDEVS receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
		verbose ifTrue: [
			reportStream nextPutAll: '* Root DEVS Output Port Configuration: ', String cr.
	 		rootDEVS reportOutputPortConfig ]].


]
