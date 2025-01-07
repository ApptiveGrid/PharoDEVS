Class {
	#name : 'DEVSXYPlotter',
	#superclass : 'DEVSPlotter',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSXYPlotter class >> new [ 

	^ super withInputs: #(x y)
]

{ #category : 'as yet unclassified' }
DEVSXYPlotter class >> withInputs: i [
]

{ #category : 'as yet unclassified' }
DEVSXYPlotter >> intTransition [

	pm series: name addPoint: ((input at: (inputPorts at: #x))) @ ((input at: (inputPorts at: #y))).
	pm title: self printString.	"may change at runtime"
	^ output	

]

{ #category : 'as yet unclassified' }
DEVSXYPlotter >> open [

	pm := PlotMorph new.
	pm position: (World extent x - 250) atRandom @ (World extent y - 250) atRandom.  
	pm extent: 250 @ 250.
	"pm color: (Color black alpha: 0.8)."
	"inputPorts keys do: [ :portName | pm serie: portName color: Color random ]."
	pm openInWorld


]
