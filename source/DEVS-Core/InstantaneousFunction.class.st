"
Example - printIt:
| f |
f := InstantaneousFunction withInputs: {#a. #b.} codeBlock: [:a :b | a+b ].
(f receiveNMsgX: (Dictionary newFrom: {#a->1.#b->2}) time: 0 step: 0) inspect.
f inspect.

"
Class {
	#name : 'InstantaneousFunction',
	#superclass : 'BaseDEVS',
	#instVars : [
		'function',
		'inputPortNames'
	],
	#category : 'DEVS-Core-Continuous',
	#package : 'DEVS-Core',
	#tag : 'Continuous'
}

{ #category : 'as yet unclassified' }
InstantaneousFunction class >> withInputs: inputPortNames codeBlock: aBlock [

	| function |
	function := self new.
	function function: aBlock.
	function addFunctionPorts: inputPortNames.
	^ function
]

{ #category : 'modeling' }
InstantaneousFunction >> addFunctionPorts: listOfInputPortNames [


	inputPortNames := listOfInputPortNames. 
	"we need to remember positions of parameter names"

	listOfInputPortNames do: [ :portName |
		inputPorts at: portName put: (InputNPort hostDEVS: self name: portName) ].

	outputPorts at: #output put: (OutputNPort hostDEVS: self name: #output).
	
]

{ #category : 'modeling' }
InstantaneousFunction >> function: aBlock [

	function := aBlock
]

{ #category : 'simulation' }
InstantaneousFunction >> receiveMsgInitTime: t [

	timeLast := t.
	timeNext := Float infinity.
]

{ #category : 'simulation' }
InstantaneousFunction >> receiveMsgStarTime: t [

	^ Dictionary new.
]

{ #category : 'simulation' }
InstantaneousFunction >> receiveNMsgX: x time: t step: h [

	input := x.

	self 
		poke: (function valueWithArguments: 
				(inputPortNames collect: [ :par | input at: (inputPorts at: par) ])) 
		to: #output.

	^ output	

]
