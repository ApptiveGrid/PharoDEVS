"
Similar to MySystems2. Uses MyGenerator2 instead of MyGenerator. Bulilt for RT simulation.

Example:
[ s := MySystem3b getSimulatorRT. s simulate: 20. ] forkAt: Processor timingPriority.


"
Class {
	#name : 'MySystem3b',
	#superclass : 'CoupledDEVS',
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MySystem3b >> initialize [

	super initialize.

	self addOutputPorts: {
		#out.
		#discard.
	}.

	self addComponents: {
		#generator -> (MyGenerator2 ia: 2 ib: 7 sa: 5 sb: 10).		"! RT !"
		#processor -> (MyProcessor withQueueSize: 5).
	}. 

	self addCouplings: { 
		#(generator out) -> #(processor in).
		#(processor out) -> #(self out).
		#(processor discard) -> #(self discard).
	}.




]
