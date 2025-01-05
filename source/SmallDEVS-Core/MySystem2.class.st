"
DEVS example. A demonstartion of another way of coupled model specification. See initialize. Log goes to Transcript.

Example:
MySystem2 getSimulator simulate: 100.


"
Class {
	#name : #MySystem2,
	#superclass : #CoupledDEVS,
	#category : #'SmallDEVS-Core-Examples'
}

{ #category : #'as yet unclassified' }
MySystem2 >> initialize [

	super initialize.

	self addOutputPorts: {
		#out.
		#discard.
	}.

	self addComponents: {
		#generator -> (MyGenerator ia: 2 ib: 7 sa: 5 sb: 10).
		#processor -> (MyProcessor withQueueSize: 5).
	}. 

	self addCouplings: { 
		#(generator out) 	-> #(processor in).
		#(processor out) 	-> #(self out).
		#(processor discard) -> #(self discard).
	}.




]
