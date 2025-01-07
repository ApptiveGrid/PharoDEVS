"
Coupled DEVnDESS example.
"
Class {
	#name : 'MyContinuousSystem',
	#superclass : 'CoupledDEVnDESS',
	#category : 'DEVS-Examples',
	#package : 'DEVS-Examples'
}

{ #category : 'as yet unclassified' }
MyContinuousSystem >> initialize [

	super initialize.

	self addComponents: {
		#contiblock 	-> (MyContinuousBlock new).
		#plotter 	-> (Plotter withInputs: {#i1. #i2.}).
		#plotter2	-> (XYPlotter new)
	}. 

	self addCouplings: { 
		#(contiblock o1) -> #(plotter i1).
		#(contiblock o2) -> #(plotter i2).
		#(contiblock o1) -> #(plotter2 x).
		#(contiblock o2) -> #(plotter2 y).
	}.

]
