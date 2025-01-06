"
Coupled DEVnDESS example.
"
Class {
	#name : 'MyContinuousSystem1',
	#superclass : 'CoupledDEVnDESS',
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MyContinuousSystem1 >> initialize [

	super initialize.

	self addComponents: {
		#contiblock 	-> (MyContinuousBlock2 new).
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
