Class {
	#name : 'DEVSCoupledTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests',
	#package : 'DEVS-Core-Tests'
}

{ #category : 'tests' }
DEVSCoupledTest >> testAddingModel [ 
	| model coupled |
	model := DEVSAtomicComponent new name: #atomic.
	coupled := DEVSTestCoupled new.
	coupled addComponent: model.
	self assert: (coupled componentNamed: #atomic) name equals: model name 
]

{ #category : 'tests' }
DEVSCoupledTest >> testAddingNamedModel [ 
	| model coupled |
	model := DEVSAtomicComponent new.
	coupled := DEVSTestCoupled new.
	coupled addComponent: (model name: #atomic).
	self assert: (coupled componentNamed: #atomic) name equals: model name 
]
