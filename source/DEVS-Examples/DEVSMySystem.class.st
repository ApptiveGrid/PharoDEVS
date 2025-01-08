"
DEVS example. Log goes to Transcript.

Example:
(MySystem getSimulator deepVerbose: true) simulate: 100.


"
Class {
	#name : 'DEVSMySystem',
	#superclass : 'DEVSCoupledComponent',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMySystem >> initialize [

	| out discard generator prevPort tmp |
	super initialize.

	out := self addOutputPortNamed: #out.
	discard := self addOutputPortNamed: #discard.

	generator := self addComponent: ((DEVSMyGenerator ia: 2 ib: 7 sa: 5 sb: 10) name: #generator).

	prevPort := generator outputPortNamed: #out.
	1 to: 3 do: [ :i |
		tmp := self addComponent: ((DEVSMyProcessor withQueueSize: 5) name: 
										(#processor, i printString) asSymbol).
		self connectPort: prevPort to: (tmp inputPortNamed: #in).
		self connectPort: (tmp outputPortNamed: #out) to: out.
		prevPort := tmp outputPortNamed: #discard ].
	self connectPort: prevPort to: discard.




]
