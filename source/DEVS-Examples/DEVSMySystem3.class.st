"
DEVS example. A demonstartion of realtime simulation.

Example:
| s |
[ s := MySystem3 getSimulatorRT. s simulate: 10. ] forkAt: Processor userBackgroundPriority.
(Delay forSeconds: 3) wait.
s inject: #aaaa to: #in

"
Class {
	#name : 'DEVSMySystem3',
	#superclass : 'DEVSMySystem2',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMySystem3 >> initialize [

	super initialize.

	self addInputPorts: {
		#in.
	}.


]
