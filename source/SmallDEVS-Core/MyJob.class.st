"
Part of MySystem
"
Class {
	#name : #MyJob,
	#superclass : #DEVSEntity,
	#instVars : [
		'n',
		'size'
	],
	#category : #'SmallDEVS-Core-Examples'
}

{ #category : #'as yet unclassified' }
MyJob class >> sizeBetween: sl and: sh [

	^ self new size: (sl to: sh) atRandom.
]

{ #category : #'as yet unclassified' }
MyJob >> n: num [

	n := num

]

{ #category : #'as yet unclassified' }
MyJob >> printOn: aStream [

	aStream nextPutAll: 'aJob', (n isNil ifTrue: [''] ifFalse: ['(', n printString, ')']).
]

{ #category : #'as yet unclassified' }
MyJob >> size [

	^ size
]

{ #category : #'as yet unclassified' }
MyJob >> size: s [

	size := s

]
