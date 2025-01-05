Class {
	#name : #Port,
	#superclass : #Object,
	#instVars : [
		'name',
		'inLines',
		'outLines',
		'hostDEVS'
	],
	#category : #'SmallDEVS-Core'
}

{ #category : #'as yet unclassified' }
Port class >> hostDEVS: host name: n [

	^ (super new initialize hostDEVS: host) name: n
]

{ #category : #'as yet unclassified' }
Port >> hostDEVS [

	^ hostDEVS
]

{ #category : #'as yet unclassified' }
Port >> hostDEVS: host [

	hostDEVS := host
]

{ #category : #'as yet unclassified' }
Port >> inLines [

	^ inLines
]

{ #category : #'as yet unclassified' }
Port >> initialize [

	inLines := OrderedCollection new.
	outLines := OrderedCollection new.

]

{ #category : #'as yet unclassified' }
Port >> name [

	^name
]

{ #category : #'as yet unclassified' }
Port >> name: n [

	name := n. 
]

{ #category : #'as yet unclassified' }
Port >> outLines [

	^ outLines
]
