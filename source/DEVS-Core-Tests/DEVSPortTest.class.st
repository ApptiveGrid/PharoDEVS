"
A DEVSPortTest is a test class for testing the behavior of DEVSPort
"
Class {
	#name : 'DEVSPortTest',
	#superclass : 'TestCase',
	#category : 'DEVS-Core-Tests-Basic',
	#package : 'DEVS-Core-Tests',
	#tag : 'Basic'
}

{ #category : 'tests' }
DEVSPortTest >> testDirection [

	self should: [ DEVSPort new direction ] raise: SubclassResponsibility.
]

{ #category : 'tests' }
DEVSPortTest >> testInLinesOutLines [

	|aPort|
	aPort := DEVSPort new.
	self assert: aPort inLines isEmpty.
	self assert: aPort outLines isEmpty.
]

{ #category : 'tests' }
DEVSPortTest >> testPrintOn [
	
	|aPort aString|
	
	aPort := DEVSInputPort 
		hostDEVS: DEVSComponent new
		name: 'my Port'.
	aString := String streamContents: [:aStream |  	
	aPort printOn: aStream].

	self assert: aString equals: 'input port: my Port'.
]

{ #category : 'tests' }
DEVSPortTest >> testhostDEVSname [

	|aPort|
	aPort := DEVSPort 
		hostDEVS: DEVSComponent new
		name: 'my Port'.
		
	self assert: aPort name equals: 'my Port'.
	self assert: aPort hostDEVS isNotNil.
]
