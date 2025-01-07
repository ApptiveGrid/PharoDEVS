"
DEVS example. A demonstartion of another way of coupled model specification. See initialize. Log goes to Transcript.

Example:
MySystem2 getSimulator simulate: 100.


"
Class {
	#name : 'DEVSMySystem2',
	#superclass : 'CoupledDEVS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMySystem2 >> initialize [

	super initialize.

	self addOutputPorts: {
		#out.
		#discard.
	}.

	self addComponents: {
		#generator -> (DEVSMyGenerator ia: 2 ib: 7 sa: 5 sb: 10).
		#processor -> (DEVSMyProcessor withQueueSize: 5).
	}. 

	self addCouplings: { 
		#(generator out) 	-> #(processor in).
		#(processor out) 	-> #(self out).
		#(processor discard) -> #(self discard).
	}.




]
