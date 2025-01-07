"
Coupled DEVnDESS example.
"
Class {
	#name : 'DEVSMyContinuousSystem3',
	#superclass : 'CoupledDEVnDESS',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyContinuousSystem3 >> initialize [

	super initialize.


	self addComponents: {
		#intg1 	-> (DEVSIntegrator newWithInitialCondition: -0.5).
		#intg2 	-> (DEVSIntegrator newWithInitialCondition: 0.5).
		#intg3 	-> (DEVSIntegrator newWithInitialCondition: 0.3).
		#f1 	-> (DEVSInstantaneousFunction withInputs: {#i1. #i2.} codeBlock: [:i1 :i2 | 
					("a" 0.2 * i1) + i2 ]).
		#f2 	-> (DEVSInstantaneousFunction withInputs: {#i1. #i2.} codeBlock: [:i1 :i2 | 
					0 - i1 - i2 ]).
		#f3 	-> (DEVSInstantaneousFunction withInputs: {#i1. #i2.} codeBlock: [:i1 :i2 | 
					0.5 + (i1 - 0.3) * i2 ]).
		#plotter -> (DEVSPlotter withInputs: {#i1. #i2. #i3}).
	}. 

	self addCouplings: { 
		#(f1 output) 	-> #(intg1 input).
		#(f2 output) 	-> #(intg2 input).
		#(f3 output) 	-> #(intg3 input).
		#(intg1 output)	-> #(f1 i1).
		#(intg1 output)	-> #(f2 i1).
		#(intg2 output) 	-> #(f1 i2).
		#(intg2 output) 	-> #(f3 i1).
		#(intg3 output) 	-> #(f2 i2).
		#(intg3 output) 	-> #(f3 i2).
		#(intg1 output) 	-> #(plotter i1).
		#(intg2 output)	-> #(plotter i2).
		#(intg3 output)	-> #(plotter i3).
	}.


]
