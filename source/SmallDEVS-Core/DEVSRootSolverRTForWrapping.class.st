Class {
	#name : 'DEVSRootSolverRTForWrapping',
	#superclass : 'DEVSRootSolverRT',
	#category : 'SmallDEVS-Core-Wrapping',
	#package : 'SmallDEVS-Core',
	#tag : 'Wrapping'
}

{ #category : 'as yet unclassified' }
DEVSRootSolverRTForWrapping >> simulationStep [

	super simulationStep.
	parent signalStateEvent. "Indicate end of step of the wrapper. Its intTransition will react."

]
