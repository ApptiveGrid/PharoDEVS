"
Coupled DEVnDESS example.
"
Class {
	#name : 'DEVSMyContinuousSystem1',
	#superclass : 'CoupledDEVnDESS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyContinuousSystem1 >> initialize [

	super initialize.

	self addComponents: {
		#contiblock 	-> (DEVSMyContinuousBlock2 new).
		#plotter 	-> (DEVSPlotter withInputs: {#i1. #i2.}).
		#plotter2	-> (DEVSXYPlotter new)
	}. 

	self addCouplings: { 
		#(contiblock o1) -> #(plotter i1).
		#(contiblock o2) -> #(plotter i2).
		#(contiblock o1) -> #(plotter2 x).
		#(contiblock o2) -> #(plotter2 y).
	}.

]
