Class {
	#name : 'DEVSCoupledTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests',
	#package : 'DEVS-Core-Tests'
}

{ #category : 'tests' }
DEVSCoupledTest >> testAddingModel [ 
	| model coupled |
	model := DEVSAtomic new name: #atomic.
	coupled := DEVSTestCoupled new.
	coupled addSubModel: model.
	self assert: (coupled componentNamed: #atomic) name equals: model name 
]

{ #category : 'tests' }
DEVSCoupledTest >> testAddingNamedModel [ 
	| model coupled |
	model := DEVSAtomic new.
	coupled := DEVSTestCoupled new.
	coupled addSubModel: model named: #atomic.
	self assert: (coupled componentNamed: #atomic) name equals: model name 
]
