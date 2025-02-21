Extension { #name : 'DEVSTestNetwork' }

{ #category : '*DEVS-Examples' }
DEVSTestNetwork class >> example [

	<example>
   "discrete event time simulation of network of UDP servers and network node sending UDP packets (messages)"
   DEVSSimulation new 
		model: (self new name: 'UDP network simulation');
		coordinator: DEVSRootSolver new;
		runTo: 10;
		logger
]
