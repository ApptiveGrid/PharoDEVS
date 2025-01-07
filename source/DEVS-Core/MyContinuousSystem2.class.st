"
Coupled DEVnDESS example.
"
Class {
	#name : 'MyContinuousSystem2',
	#superclass : 'CoupledDEVnDESS',
	#category : 'DEVS-Core-Examples',
	#package : 'DEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MyContinuousSystem2 >> initialize [

	super initialize.


	self addComponents: {
		#intg1 	-> (Integrator newWithInitialCondition: -2.0).
		#intg2 	-> (Integrator newWithInitialCondition: 2.0).
		#f 		-> (InstantaneousFunction withInputs: {#i1. #i2.} codeBlock: [:i1 :i2 | 
					1.0 * (1.0 - i1 squared) * i2 - i1 ]).
		#plotter -> (Plotter withInputs: {#i1. #i2.}).
	}. 

	self addCouplings: { 
		#(intg1 output)	-> #(f i1).
		#(intg2 output) 	-> #(f i2).
		#(f output) 		-> #(intg2 input).
		#(intg2 output) 	-> #(intg1 input).
		#(intg1 output) 	-> #(plotter i1).
		#(intg2 output)	-> #(plotter i2).
	}.


]
