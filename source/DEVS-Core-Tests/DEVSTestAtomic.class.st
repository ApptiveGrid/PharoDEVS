Class {
	#name : 'DEVSTestAtomic',
	#superclass : 'DEVSAtomic',
	#instVars : [
		'timeAdvance'
	],
	#category : 'DEVS-Core-Tests',
	#package : 'DEVS-Core-Tests'
}

{ #category : 'modeling' }
DEVSTestAtomic >> timeAdvance [

	^ timeAdvance ifNil: [ 
		timeAdvance := self infinityTime  ] 
]

{ #category : 'accessing' }
DEVSTestAtomic >> timeAdvance: anInteger [ 
	timeAdvance := anInteger
]
