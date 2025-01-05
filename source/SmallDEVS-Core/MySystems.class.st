"
DEVS example. All systems coupled together. MyDaemon (part of MySystems) modifies structure of MySystems at runtime
"
Class {
	#name : #MySystems,
	#superclass : #CoupledDEVnDESS,
	#category : #'SmallDEVS-Core-Examples'
}

{ #category : #'as yet unclassified' }
MySystems >> initialize [

	super initialize.

	self addComponents: {
		#s1 -> (MySystem new).
		#s2 -> (MySystem2 new).
		#c1 -> (MyContinuousSystem new).
		#c2 -> (MyContinuousSystem2 new).
		#d	-> (MyDaemon new)
	}. 

]
