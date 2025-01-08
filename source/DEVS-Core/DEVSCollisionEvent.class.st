Class {
	#name : 'DEVSCollisionEvent',
	#superclass : 'DEVSEvent',
	#instVars : [
		'events',
		'selected'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSCollisionEvent class >> displayLabel [
	^ #collision
]

{ #category : 'accessing' }
DEVSCollisionEvent >> component [
	^ selected 
]

{ #category : 'as yet unclassified' }
DEVSCollisionEvent >> events: aCollection [ 
	events := aCollection 
]

{ #category : 'accessing' }
DEVSCollisionEvent >> payload [
	^ String streamContents: [ :s | 
		s << 'selected from ' << ($, join: events) ]
]

{ #category : 'accessing' }
DEVSCollisionEvent >> selected: anEvent [  
	selected := anEvent 
]
