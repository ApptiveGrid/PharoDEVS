"
I represent input or output port of DEVS model, which is defined by one of my subclasses. I keep reference about:
- input ports collection (inLines) pointing to me
- ouput ports collection (outLines) that I'm pointing to
- host DEVS model (hostDEVS)
- direction (input or output) defined in my subclasses

I also keep name about me.
"
Class {
	#name : 'DEVSPort',
	#superclass : 'Object',
	#instVars : [
		'name',
		'inLines',
		'outLines',
		'hostDEVS'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSPort class >> hostDEVS: host name: n [

	^ self new 
		hostDEVS: host;
		name: n
]

{ #category : 'accessing - model' }
DEVSPort >> direction [
	self subclassResponsibility 
]

{ #category : 'accessing - model' }
DEVSPort >> hostDEVS [

	^ hostDEVS
]

{ #category : 'accessing - model' }
DEVSPort >> hostDEVS: host [

	hostDEVS := host
]

{ #category : 'accessing - model' }
DEVSPort >> inLines [

	^ inLines
]

{ #category : 'initialization' }
DEVSPort >> initialize [

	super initialize.
	inLines := OrderedCollection new.
	outLines := OrderedCollection new.

]

{ #category : 'accessing - model' }
DEVSPort >> name [

	^name
]

{ #category : 'accessing - model' }
DEVSPort >> name: n [

	name := n. 
]

{ #category : 'accessing - model' }
DEVSPort >> outLines [

	^ outLines
]

{ #category : 'printing' }
DEVSPort >> printOn: aStream [ 
	aStream << self direction << ' port: ' << name
]
