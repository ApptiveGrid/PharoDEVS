Class {
	#name : 'DEVnDESSRootSolver',
	#superclass : 'DEVSRootSolver',
	#instVars : [
		'tn',
		'h',
		'dh',
		'seDetected'
	],
	#category : 'DEVS-Core-Continuous',
	#package : 'DEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'simulation' }
DEVnDESSRootSolver >> initialize [

	super initialize.
	h := 0.01.

]

{ #category : 'simulation' }
DEVnDESSRootSolver >> numericStep [

	clock + h < tn ifTrue: [ dh := h ] ifFalse: [ dh := tn - clock ].
	seDetected := false.
	component receiveNMsgStarTime: clock step: dh.		"send (*, t, h) to root DEVS"
	component receiveNMsgX: {} time: clock step: dh.		"send (x, t, h) to root DEVS"
	seDetected ifTrue: [ 	| dhmin dhmax | dhmin := 0. dhmax := dh.
		[ seDetected & ((dhmax - dhmin) < 0.001) ] whileFalse: [ 
			seDetected ifTrue: [ dhmax := dh ] ifFalse: [ dhmin := dh ].
			dh := (dhmax + dhmin)/2.
			seDetected := false.
			component receiveNMsgStarTime: clock step: dh.		
			component receiveNMsgX: {} time: clock step: dh.
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

{ #category : 'simulation' }
DEVnDESSRootSolver >> simulationStep [

	"Numeric step:"
	tn := component timeNext. 
	(clock < tn) & (clock < stopTime) ifTrue: [ ^ self numericStep ].

	"Discrete step:"
	tn <= stopTime ifTrue: [ 
		clock := tn.
		component receiveMsgStarTime: clock. 				"send (*, t) to root DEVS"
	component logOutgoing ]
]
