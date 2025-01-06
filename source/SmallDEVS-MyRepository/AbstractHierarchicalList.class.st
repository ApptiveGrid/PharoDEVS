"
Contributed by Bob Arning as part of the ObjectExplorer package.

"
Class {
	#name : #AbstractHierarchicalList,
	#superclass : #Model,
	#instVars : [
		'currentSelection',
		'myBrowser'
	],
	#category : #'SmallDEVS-MyRepository-GUI'
}

{ #category : #'as yet unclassified' }
AbstractHierarchicalList >> genericMenu: aMenu [

	aMenu add: 'no menu yet' target: self selector: #yourself.
	^aMenu
]

{ #category : #'as yet unclassified' }
AbstractHierarchicalList >> getCurrentSelection [

	^currentSelection
]

{ #category : #'as yet unclassified' }
AbstractHierarchicalList >> noteNewSelection: x [

	currentSelection := x.
	self changed: #getCurrentSelection.
	currentSelection ifNil: [^self].
	currentSelection sendSettingMessageTo: self.

]

{ #category : #'as yet unclassified' }
AbstractHierarchicalList >> perform: selector orSendTo: otherTarget [
	"Selector was just chosen from a menu by a user.  If can respond, then
perform it on myself. If not, send it to otherTarget, presumably the
editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ otherTarget perform: selector]
]

{ #category : #'as yet unclassified' }
AbstractHierarchicalList >> update: aSymbol [

	aSymbol == #hierarchicalList ifTrue: [
		^self changed: #getList
	].
	super update: aSymbol
]
