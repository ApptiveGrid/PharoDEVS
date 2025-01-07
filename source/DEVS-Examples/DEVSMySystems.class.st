"
DEVS example. All systems coupled together. MyDaemon (part of MySystems) modifies structure of MySystems at runtime
"
Class {
	#name : 'DEVSMySystems',
	#superclass : 'CoupledDEVnDESS',
	#category : 'DEVS-Examples',
	#package : 'DEVS-Examples'
}

{ #category : 'as yet unclassified' }
DEVSMySystems >> initialize [

	super initialize.

	self addComponents: {
		#s1 -> (DEVSMySystem new).
		#s2 -> (DEVSMySystem2 new).
		#c1 -> (DEVSMyContinuousSystem new).
		#c2 -> (DEVSMyContinuousSystem2 new).
		#d	-> (DEVSMyDaemon new)
	}. 

]
