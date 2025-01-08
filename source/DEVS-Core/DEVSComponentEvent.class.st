Class {
	#name : 'DEVSComponentEvent',
	#superclass : 'DEVSEvent',
	#instVars : [
		'component',
		'timeNext',
		'stateChanges'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'accessing' }
DEVSComponentEvent >> component [

	^ component
]

{ #category : 'accessing' }
DEVSComponentEvent >> component: anObject [

	component := anObject
]

{ #category : 'as yet unclassified' }
DEVSComponentEvent >> stateChanges: anObject [ 
	stateChanges := anObject 
]

{ #category : 'as yet unclassified' }
DEVSComponentEvent >> timeNext: anInteger [ 
	timeNext := anInteger 
]
