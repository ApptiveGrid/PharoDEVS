Class {
	#name : #MyRepositoryList,
	#superclass : #AbstractHierarchicalList,
	#instVars : [
		'rootObject',
		'lm'
	],
	#category : #'SmallDEVS-MyRepository-GUI'
}

{ #category : #'as yet unclassified' }
MyRepositoryList >> createList: anObject [

  | list |

  rootObject:=anObject.
  list:=MyRepositoryListMorph
		on: self
		list: #getList
		selected: #getCurrentSelection
		changeSelected: #noteNewSelection:
		menu: #genericMenu:
		keystroke: nil.
  list doubleClickSelector: #defaultAction.
  lm:=list.
  (MyRepository root) addDependent: self.
  ^list.
]

{ #category : #'as yet unclassified' }
MyRepositoryList >> defaultAction [

  | obj |
  (self getCurrentSelection) ifNotNil:
  [
    obj:=self getCurrentSelection item.
    (obj class canUnderstand: #open)
    ifFalse: [obj explore]
    ifTrue: [obj open].
  ].
]

{ #category : #'as yet unclassified' }
MyRepositoryList >> genericMenu: aMenu [
  ^(self getCurrentSelection item) getMenu.
]

{ #category : #'as yet unclassified' }
MyRepositoryList >> getList [
  ^Array with: (MyRepositoryWrapper with: rootObject)
]

{ #category : #'as yet unclassified' }
MyRepositoryList >> list [
  ^lm
]

{ #category : #'as yet unclassified' }
MyRepositoryList >> update: aSymbol [

	WorldState addDeferredUIMessage: [ super update: aSymbol ]
]
