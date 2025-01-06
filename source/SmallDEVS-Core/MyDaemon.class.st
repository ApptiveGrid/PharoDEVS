"
Part of coupled model MySystems. intTransition modifies structure of MySystems at runtime.
 
"
Class {
	#name : 'MyDaemon',
	#superclass : 'AtomicDEVS',
	#instVars : [
		'done'
	],
	#category : 'SmallDEVS-Core-Examples',
	#package : 'SmallDEVS-Core',
	#tag : 'Examples'
}

{ #category : 'as yet unclassified' }
MyDaemon >> initialize [

	super initialize.

	done := false.


]

{ #category : 'as yet unclassified' }
MyDaemon >> intTransition [
	"This is an example of dynamic self-modication of a model."

	| newsystem newsolver |

	done ifTrue: [ self error: 'This shouldn''t occur'. ^self ].
	done := true.

	"Add new components"
	newsystem := MyContinuousSystem new.
	self rootSolver rootDEVS addComponents: { #ns -> newsystem }.

	"Add empty model and fill it by components ..."
	"note that all newly created models has to be initated with actual time"
	newsystem := CoupledDEVnDESS new.	
	self rootSolver rootDEVS addComponents: { #ns2 -> newsystem }.
	newsystem addComponents: {
		#contiblock 	-> (MyContinuousBlock new).
		#plotter 	-> (Plotter withInputs: {#i1. #i2.}).
	}. 
	newsystem addCouplings: { 
		#(contiblock o1) -> #(plotter i1).
		#(contiblock o2) -> #(plotter i2).
	}.

	"Investigate actual model structure ..."
	"to be implemented: model structure accessing, state of atomic models accessing, ..."


	"Remove components"
	self rootSolver rootDEVS removeComponents: { #s1. #s2 }.

	"TO DO:"
	"It is possible to remove couplings, remove a model from some coupled model 
	 and add it to another coupled model"
	"It is also possible to compile new classes on the fly and use them here ..."
	"It would be interesting to create classes without names for that purpose ..."
	"... or rather self-contained objects a la Self ..."

	"Clone submodels ..."	
"	newsystem := (self rootSolver rootDEVS subModelNamed: #c1) copy.
	self rootSolver rootDEVS addComponents: { #clone1 -> newsystem }.
"	newsystem := (self rootSolver rootDEVS subModelNamed: #c2) copy.
	self rootSolver rootDEVS addComponents: { #clone2 -> newsystem }.

	"Clone the whole model ..."	
	newsystem := self rootSolver rootDEVS copy.
	newsystem removeSubModelNamed: #d.
	self rootSolver rootDEVS addComponents: { #clone -> newsystem }.

	"Make nested simulation of a clone (with independent simulation time)" 		
	newsystem := self rootSolver rootDEVS copy.
	newsolver := self rootSolver copy rootDEVS: newsystem.
	newsystem name: #nestedSimulation.
	newsystem removeSubModelNamed: #d.
	newsolver simulate: 35. 			"starting at actual sim. time (25)"

	"Show actual model structure"
	self reportStream nextPutAll: String cr, '* Model structure changed:'.
	self rootSolver rootDEVS reportStructure. 
	self reportStream cr.


]

{ #category : 'as yet unclassified' }
MyDaemon >> outputFnc [


]

{ #category : 'as yet unclassified' }
MyDaemon >> timeAdvance [

	^ done ifTrue: [ Float infinity ] ifFalse: [ 25 ]
]
