"
Part of MySystem
"
Class {
	#name : 'DEVSMyGenerator',
	#superclass : 'DEVSAtomicComponent',
	#instVars : [
		'ia',
		'ib',
		'sa',
		'sb',
		'first',
		'n'
	],
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyGenerator class >> ia: a ib: b sa: c sb: d [

	^ self new ia: a ib: b sa: c sb: d

]

{ #category : 'as yet unclassified' }
DEVSMyGenerator >> ia: a ib: b sa: c sb: d [

	ia := a.	"interval min"
	ib := b.	"interval max"
	sa := c.	"job size min"
	sb := d.	"job size max"


]

{ #category : 'as yet unclassified' }
DEVSMyGenerator >> initialize [

	super initialize.

	first := true.
	n := 0.	"number of jobs generated"

	self addOutputPortNamed: #out

]

{ #category : 'as yet unclassified' }
DEVSMyGenerator >> internalTransition [

	first := false.

]

{ #category : 'as yet unclassified' }
DEVSMyGenerator >> outputFunction [

	n := n+1.
	self poke: ((DEVSMyJob sizeBetween: sa and: sb) n: n) to: #out.
]

{ #category : 'as yet unclassified' }
DEVSMyGenerator >> timeAdvance [

	^ first ifTrue: [ 0 ] ifFalse: [ (ia to: ib) atRandom ]
]
