"
I represent input port of atomic or coupled DEVS component.
"
Class {
	#name : 'DEVSInputPort',
	#superclass : 'DEVSPort',
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'printing' }
DEVSInputPort >> direction [
	^ #input
]
