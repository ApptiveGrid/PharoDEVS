"
Part of MySystem
"
Class {
	#name : #MyGenerator,
	#superclass : #AtomicDEVS,
	#instVars : [
		'ia',
		'ib',
		'sa',
		'sb',
		'first',
		'n'
	],
	#category : #'SmallDEVS-Core-Examples'
}

{ #category : #'as yet unclassified' }
MyGenerator class >> ia: a ib: b sa: c sb: d [

	^ self new ia: a ib: b sa: c sb: d

]

{ #category : #'as yet unclassified' }
MyGenerator >> ia: a ib: b sa: c sb: d [

	ia := a.	"interval min"
	ib := b.	"interval max"
	sa := c.	"job size min"
	sb := d.	"job size max"


]

{ #category : #'as yet unclassified' }
MyGenerator >> initialize [

	super initialize.

	first := true.
	n := 0.	"number of jobs generated"

	self addOutputPortNamed: #out

]

{ #category : #'as yet unclassified' }
MyGenerator >> intTransition [

	first := false.

]

{ #category : #'as yet unclassified' }
MyGenerator >> outputFnc [

	n := n+1.
	self poke: ((MyJob sizeBetween: sa and: sb) n: n) to: #out.
]

{ #category : #'as yet unclassified' }
MyGenerator >> timeAdvance [

	^ first ifTrue: [ 0 ] ifFalse: [ (ia to: ib) atRandom ]
]
