Class {
	#name : 'DEVSTrafficSystem',
	#superclass : 'CoupledDEVS',
	#category : 'DEVS-Examples-crossing',
	#package : 'DEVS-Examples',
	#tag : 'crossing'
}

{ #category : 'modeling' }
DEVSTrafficSystem >> initialize [
	super initialize.

	self addComponents: {
		#northSouth 	-> (DEVSTrafficLight new).
		#eastWest 	-> (DEVSTrafficLight new).
		#controller -> (DEVSTrafficController new )
	}. 

	self addCouplings: { 
		#(controller out) -> #(northSouth in).
		#(controller out) -> #(eastWest in)
	}.

]
