Class {
	#name : #AtomicDEVSTrait,
	#superclass : #Object,
	#category : #'SmallDEVS-Core-Prototypes'
}

{ #category : #'as yet unclassified' }
AtomicDEVSTrait class >> new [
	^ super new initialize
]

{ #category : #'as yet unclassified' }
AtomicDEVSTrait >> initialize [
 	self addDelegate: 'defaultTrait' withValue: AtomicDEVSPrototype defaultTrait.

]

{ #category : #'as yet unclassified' }
AtomicDEVSTrait >> species [
	^ AtomicDEVSTrait
]
