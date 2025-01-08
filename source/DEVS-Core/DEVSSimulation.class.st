Class {
	#name : 'DEVSSimulation',
	#superclass : 'Object',
	#instVars : [
		'model',
		'coordinator',
		'logger'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'accessing' }
DEVSSimulation >> coordinator [

	^ coordinator
]

{ #category : 'accessing' }
DEVSSimulation >> coordinator: anObject [

	coordinator := anObject
]

{ #category : 'as yet unclassified' }
DEVSSimulation >> defaultSimulationTime [
	^ 100 
]

{ #category : 'announcer' }
DEVSSimulation >> emitEvent: anEvent [ 
	self logger addEvent: (
		anEvent
			time: coordinator time;
			yourself)
]

{ #category : 'accessing' }
DEVSSimulation >> logger [ 
	^ logger ifNil: [ 
		logger := self newDefaultLogger ] 
]

{ #category : 'accessing' }
DEVSSimulation >> model [

	^ model
]

{ #category : 'accessing' }
DEVSSimulation >> model: anObject [
	anObject parent: self.
	model := anObject
]

{ #category : 'instance creation' }
DEVSSimulation >> newDefaultLogger [
	^ DEVSLogger new 
]

{ #category : 'printing' }
DEVSSimulation >> printPathOn: aStream [ 

]

{ #category : 'misc' }
DEVSSimulation >> rootSolver [
	^ self coordinator 
]

{ #category : 'running' }
DEVSSimulation >> run [ 
	self runTo: self defaultSimulationTime 
]

{ #category : 'running' }
DEVSSimulation >> runTo: aTime [ 
	self coordinator 
		component: self model;
		simulate: aTime 
]

{ #category : 'misc' }
DEVSSimulation >> simulation [ 
	
	^ self
]
