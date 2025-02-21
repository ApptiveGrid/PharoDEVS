"
A DEVSInputPortTest is a test class for testing the behavior of DEVSInputPort
"
Class {
	#name : 'DEVSInputPortTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests-Basic',
	#package : 'DEVS-Core-Tests',
	#tag : 'Basic'
}

{ #category : 'tests' }
DEVSInputPortTest >> testDirection [

	self assert: DEVSInputPort new direction equals: #input.
]
