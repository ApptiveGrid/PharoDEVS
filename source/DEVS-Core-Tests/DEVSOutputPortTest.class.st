"
A DEVSOutputPortTest is a test class for testing the behavior of DEVSOutputPort
"
Class {
	#name : 'DEVSOutputPortTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests-Basic',
	#package : 'DEVS-Core-Tests',
	#tag : 'Basic'
}

{ #category : 'tests' }
DEVSOutputPortTest >> testDirection [

	self assert: DEVSOutputPort new direction equals: #output.
]
