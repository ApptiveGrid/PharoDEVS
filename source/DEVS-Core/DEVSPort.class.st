Class {
	#name : 'DEVSPort',
	#superclass : 'Object',
	#instVars : [
		'name',
		'inLines',
		'outLines',
		'hostDEVS'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
}

{ #category : 'as yet unclassified' }
DEVSPort class >> hostDEVS: host name: n [

	^ self new 
		hostDEVS: host;
		name: n
]

{ #category : 'as yet unclassified' }
DEVSPort >> hostDEVS [

	^ hostDEVS
]

{ #category : 'as yet unclassified' }
DEVSPort >> hostDEVS: host [

	hostDEVS := host
]

{ #category : 'as yet unclassified' }
DEVSPort >> inLines [

	^ inLines
]

{ #category : 'as yet unclassified' }
DEVSPort >> initialize [

	inLines := OrderedCollection new.
	outLines := OrderedCollection new.

]

{ #category : 'as yet unclassified' }
DEVSPort >> name [

	^name
]

{ #category : 'as yet unclassified' }
DEVSPort >> name: n [

	name := n. 
]

{ #category : 'as yet unclassified' }
DEVSPort >> outLines [

	^ outLines
]
