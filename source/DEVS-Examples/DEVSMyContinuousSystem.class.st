"
Coupled DEVnDESS example.
"
Class {
	#name : 'DEVSMyContinuousSystem',
	#superclass : 'DEVSCoupledDESS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyContinuousSystem >> initialize [

	super initialize.

	self addComponents: {
		#contiblock 	-> (DEVSMyContinuousBlock new).
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
