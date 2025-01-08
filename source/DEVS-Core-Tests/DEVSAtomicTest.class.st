Class {
	#name : 'DEVSAtomicTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests',
	#package : 'DEVS-Core-Tests'
}

{ #category : 'tests' }
DEVSAtomicTest >> testTimeAdvance [ 
	| atomic |
	atomic := DEVSTestAtomic new timeAdvance: 15.
	atomic receiveMsgInitTime: 0.
	
	self assert: atomic timeLast equals: 0.
	self assert: atomic timeNext equals: 15
]
