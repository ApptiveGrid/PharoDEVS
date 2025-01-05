"
Common behavior of DEVS components. To be replaced by a subclass of MyRepository (?). 
"
Class {
	#name : #DEVSEntity,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'SmallDEVS-Core'
}

{ #category : #'as yet unclassified' }
DEVSEntity >> fullName [

	^name
]

{ #category : #'as yet unclassified' }
DEVSEntity >> name [

	^name
]

{ #category : #'as yet unclassified' }
DEVSEntity >> name: n [

	name := n. 
]

{ #category : #'as yet unclassified' }
DEVSEntity >> printOn: aStream [

	name isNil 
		ifTrue: [ 	| title |
			title := self class name.
			aStream
				nextPutAll: (title first isVowel ifTrue: ['an'] ifFalse: ['a']); "without space"
				nextPutAll: title ]
		ifFalse: [ aStream nextPutAll: name asString ]

]

{ #category : #'as yet unclassified' }
DEVSEntity >> sixxType [
	^self species name
]
