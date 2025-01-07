"
Part of MySystem
"
Class {
	#name : 'DEVSMyJob',
	#superclass : 'DEVSEntity',
	#instVars : [
		'n',
		'size'
	],
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'as yet unclassified' }
DEVSMyJob class >> sizeBetween: sl and: sh [

	^ self new size: (sl to: sh) atRandom.
]

{ #category : 'as yet unclassified' }
DEVSMyJob >> n: num [

	n := num

]

{ #category : 'as yet unclassified' }
DEVSMyJob >> printOn: aStream [

	aStream nextPutAll: 'aJob', (n isNil ifTrue: [''] ifFalse: ['(', n printString, ')']).
]

{ #category : 'as yet unclassified' }
DEVSMyJob >> size [

	^ size
]

{ #category : 'as yet unclassified' }
DEVSMyJob >> size: s [

	size := s

]
