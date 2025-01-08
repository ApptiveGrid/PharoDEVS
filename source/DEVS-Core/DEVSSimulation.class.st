Class {
	#name : 'DEVSSimulation',
	#superclass : 'Object',
	#instVars : [
		'model',
		'coordinator'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
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

{ #category : 'accessing' }
DEVSSimulation >> model [

	^ model
]

{ #category : 'accessing' }
DEVSSimulation >> model: anObject [
	anObject parent: self.
	model := anObject
]

{ #category : 'printing' }
DEVSSimulation >> printPathOn: aStream [ 
	aStream << '<' << self class name << '> '.
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
