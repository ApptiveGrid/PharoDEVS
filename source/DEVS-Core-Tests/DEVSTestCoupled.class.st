Class {
	#name : 'DEVSTestCoupled',
	#superclass : 'DEVSCoupled',
	#category : 'DEVS-Core-Tests',
	#package : 'DEVS-Core-Tests'
}

{ #category : 'printing' }
DEVSTestCoupled >> printOn: aStream [
self halt.
	(parent isKindOf: DEVSModel) ifTrue: [ 
		parent printOn: aStream. 
		aStream nextPutAll: '/' ].
	name 
		ifNotNil: [ aStream << name asString ]
		ifNil: [ "super printOn: aStream" ]

]
