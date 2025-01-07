Class {
	#name : 'Plotter',
	#superclass : 'AtomicDEVnDESS',
	#instVars : [
		'pm',
		'pstep'
	],
	#category : 'DEVS-Examples',
	#package : 'DEVS-Examples'
}

{ #category : 'as yet unclassified' }
Plotter class >> withInputs: inputPortNames [ 

	| p |
	p := super new.
	p addPlotterPorts: inputPortNames.
	^ p
]

{ #category : 'modeling' }
Plotter >> addPlotterPorts: listOfInputPortNames [

	listOfInputPortNames do: [ :portName |
		inputPorts at: portName put: (InputNPort hostDEVS: self name: portName) ].

]

{ #category : 'modeling' }
Plotter >> copy [

	^ super copy open


]

{ #category : 'modeling' }
Plotter >> initConditions [

	pstep := 0.1
]

{ #category : 'modeling' }
Plotter >> initialize [

	super initialize.
	self open.

]

{ #category : 'modeling' }
Plotter >> intTransition [

	inputPorts keys do: [ :portName |
		pm series: portName addPoint: (self rootSolver time) @ ((input at: (inputPorts at: portName))) ].
	pm title: self printString.	"may change at runtime"


]

{ #category : 'modeling' }
Plotter >> intgStep [
]

{ #category : 'modeling' }
Plotter >> open [

	pm := PlotMorph new.
	pm position: (World extent x - 250) atRandom @ (World extent y - 250) atRandom.  
	pm extent: 250 @ 250.
	"pm color: (Color black alpha: 0.8)."
	inputPorts keys do: [ :portName | pm serie: portName color: Color random ].
	"pm title: self printString." 	"name will be known later"
	pm openInWorld


]

{ #category : 'modeling' }
Plotter >> outputFnc [
]

{ #category : 'modeling' }
Plotter >> outputNFnc [
]

{ #category : 'modeling' }
Plotter >> plotStep: t [

	pstep := t
]

{ #category : 'modeling' }
Plotter >> timeAdvance [

	^ pstep
]
