Class {
	#name : #MyRepositoryBrowser,
	#superclass : #SystemWindow,
	#instVars : [
		'list'
	],
	#category : #'SmallDEVS-MyRepository-GUI'
}

{ #category : #'as yet unclassified' }
MyRepositoryBrowser >> buildWindowMenu [

	| m |
	m := super buildWindowMenu.
	m addLine.
	self isStepping 
		ifFalse: [ m add: 'start stepping' translated action: #startStepping ]
		ifTrue: [ m add: 'stop stepping' translated action: #stopStepping ].
	^m
]

{ #category : #'as yet unclassified' }
MyRepositoryBrowser >> initialize [

  | l |

  super initialize.
  self setLabel: 'MyRepository'.
  list := MyRepositoryList new.
  l := list createList: (MyRepository root).
  self addMorph: l frame: (0@0 extent: 1@1).
  self extent: 250@430.
  self paneColor: (Color lightGray).
]

{ #category : #'as yet unclassified' }
MyRepositoryBrowser >> newInstance [
  ^self class new
]

{ #category : #'as yet unclassified' }
MyRepositoryBrowser >> step [
	"Fast process structure changes can not be monitored using observer pattern (changes-update mechanism).
	The view can update itself periodically using steping mechanism."

	self update: #hierarchicalList

]

{ #category : #'as yet unclassified' }
MyRepositoryBrowser >> stepTime [

	^ 2000
]
