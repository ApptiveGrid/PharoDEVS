"
I represent output port of atomic or coupled DEVS component.
"
Class {
	#name : 'DEVSOutputPort',
	#superclass : 'DEVSPort',
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'printing' }
DEVSOutputPort >> direction [
	^ #output
]
