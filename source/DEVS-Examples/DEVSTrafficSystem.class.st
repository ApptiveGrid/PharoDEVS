Class {
	#name : 'DEVSTrafficSystem',
	#superclass : 'DEVSCoupled',
	#category : 'DEVS-Examples-traffic-system',
	#package : 'DEVS-Examples',
	#tag : 'traffic-system'
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
