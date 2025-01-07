"
Example - printIt:
| f |
f := InstantaneousFunction withInputs: {#a. #b.} codeBlock: [:a :b | a+b ].
(f receiveNMsgX: (Dictionary newFrom: {#a->1.#b->2}) time: 0 step: 0) inspect.
f inspect.

"
Class {
	#name : 'DEVSInstantaneousFunction',
	#superclass : 'BasicDEVS',
	#instVars : [
		'function',
		'inputPortNames'
	],
	#category : 'DEVS-Core-Continuous',
	#package : 'DEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'as yet unclassified' }
DEVSInstantaneousFunction class >> withInputs: inputPortNames codeBlock: aBlock [

	| function |
	function := self new.
	function function: aBlock.
	function addFunctionPorts: inputPortNames.
	^ function
]

{ #category : 'modeling' }
DEVSInstantaneousFunction >> addFunctionPorts: listOfInputPortNames [


	inputPortNames := listOfInputPortNames. 
	"we need to remember positions of parameter names"

	listOfInputPortNames do: [ :portName |
		inputPorts at: portName put: (DEVSInputNPort hostDEVS: self name: portName) ].

	outputPorts at: #output put: (DEVSOutputNPort hostDEVS: self name: #output).
	
]

{ #category : 'modeling' }
DEVSInstantaneousFunction >> function: aBlock [

	function := aBlock
]

{ #category : 'simulation' }
DEVSInstantaneousFunction >> receiveMsgInitTime: t [

	timeLast := t.
	timeNext := Float infinity.
]

{ #category : 'simulation' }
DEVSInstantaneousFunction >> receiveMsgStarTime: t [

	^ Dictionary new.
]

{ #category : 'simulation' }
DEVSInstantaneousFunction >> receiveNMsgX: x time: t step: h [

	input := x.

	self 
		poke: (function valueWithArguments: 
				(inputPortNames collect: [ :par | input at: (inputPorts at: par) ])) 
		to: #output.

	^ output	

]
