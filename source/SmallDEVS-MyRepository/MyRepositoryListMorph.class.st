Class {
	#name : #MyRepositoryListMorph,
	#superclass : #SimpleHierarchicalListMorph,
	#instVars : [
		'doubleClickSelector'
	],
	#category : #'SmallDEVS-MyRepository-GUI'
}

{ #category : #'as yet unclassified' }
MyRepositoryListMorph >> doubleClick: event [
	| aMorph |
	doubleClickSelector isNil ifTrue: [^super doubleClick: event].
     aMorph := self itemFromPoint: event position.
	(aMorph notNil and:[aMorph inToggleArea: (aMorph point: event position from: self)])
	ifTrue:
	[
	  ^super doubleClick: event
	].
     aMorph ifNil: [^super doubleClick: event].
	^self model perform: doubleClickSelector
]

{ #category : #'as yet unclassified' }
MyRepositoryListMorph >> doubleClickSelector: aSymbol [
	doubleClickSelector := aSymbol
]

{ #category : #'as yet unclassified' }
MyRepositoryListMorph >> mouseDown: evt [
	| aMorph selectors |
	aMorph := self itemFromPoint: evt position.
	(aMorph notNil and:[aMorph inToggleArea: (aMorph point: evt position from: self)])
		ifTrue:[^self toggleExpandedState: aMorph event: evt]. 
	evt yellowButtonPressed  "First check for option (menu) click"
		ifTrue: 
		[
			(self model perform: getSelectionSelector) 
			ifNil:
			[
				^self
			]
			ifNotNil:
			[
				^ self yellowButtonActivity: evt shiftPressed
			].
		].
	aMorph ifNil:[^super mouseDown: evt].
	aMorph highlightForMouseDown.
	selectors := Array 
		with: #click:
		with: #doubleClick:
		with: nil
		with: (self dragEnabled ifTrue:[#startDrag:] ifFalse:[nil]).
	evt hand waitForClicksOrDrag: self event: evt selectors: selectors threshold: 10 "pixels".

]

{ #category : #'as yet unclassified' }
MyRepositoryListMorph >> yellowButtonActivity: shiftKeyState [
	| menu |
	(menu := self getMenu: shiftKeyState) ifNotNil:
		[menu popUpEvent: self activeHand lastEvent in: self world]
]
