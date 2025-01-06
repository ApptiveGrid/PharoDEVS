"
DEVS example. A demonstartion of realtime simulation.

Example:
| s |
[ s := MySystem3 getSimulatorRT. s simulate: 10. ] forkAt: Processor userBackgroundPriority.
(Delay forSeconds: 3) wait.
s inject: #aaaa to: #in

"
Class {
	#name : 'MySystem3',
	#superclass : 'MySystem2',
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MySystem3 >> initialize [

	super initialize.

	self addInputPorts: {
		#in.
	}.


]
