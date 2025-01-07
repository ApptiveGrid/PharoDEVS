Class {
	#name : 'DEVSPlotter',
	#superclass : 'AtomicDEVnDESS',
	#instVars : [
		'pm',
		'pstep'
	],
	#category : 'DEVS-Examples',
	#package : 'DEVS-Examples'
}

{ #category : 'as yet unclassified' }
DEVSPlotter class >> withInputs: inputPortNames [ 

	| p |
	p := super new.
	p addPlotterPorts: inputPortNames.
	^ p
]

{ #category : 'modeling' }
DEVSPlotter >> addPlotterPorts: listOfInputPortNames [

	listOfInputPortNames do: [ :portName |
		inputPorts at: portName put: (DEVSInputNPort hostDEVS: self name: portName) ].

]

{ #category : 'modeling' }
DEVSPlotter >> copy [

	^ super copy open


]

{ #category : 'modeling' }
DEVSPlotter >> initConditions [

	pstep := 0.1
]

{ #category : 'modeling' }
DEVSPlotter >> initialize [

	super initialize.
	self open.

]

{ #category : 'modeling' }
DEVSPlotter >> intTransition [

	inputPorts keys do: [ :portName |
		pm series: portName addPoint: (self rootSolver time) @ ((input at: (inputPorts at: portName))) ].
	pm title: self printString.	"may change at runtime"


]

{ #category : 'modeling' }
DEVSPlotter >> intgStep [
]

{ #category : 'modeling' }
DEVSPlotter >> open [

	pm := PlotMorph new.
	pm position: (World extent x - 250) atRandom @ (World extent y - 250) atRandom.  
	pm extent: 250 @ 250.
	"pm color: (Color black alpha: 0.8)."
	inputPorts keys do: [ :portName | pm serie: portName color: Color random ].
	"pm title: self printString." 	"name will be known later"
	pm openInWorld


]

{ #category : 'modeling' }
DEVSPlotter >> outputFnc [
]

{ #category : 'modeling' }
DEVSPlotter >> outputNFnc [
]

{ #category : 'modeling' }
DEVSPlotter >> plotStep: t [

	pstep := t
]

{ #category : 'modeling' }
DEVSPlotter >> timeAdvance [

	^ pstep
]
