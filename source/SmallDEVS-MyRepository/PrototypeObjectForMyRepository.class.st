"
I'm a PrototypeObject which understands to MyRepository protocol.

TO DO: Use explicit parent and name instead of searching in MyRepository.


"
Class {
	#name : #PrototypeObjectForMyRepository,
	#superclass : #SerializablePrototypeObject,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> actionSelector [

	^nil
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> addDelegate: anObject [

	"This method is the exact copy of TraitList>>addDelegate:."
	"TODO: merge methods into common place, maybe PrototypeObjectWithSources?"
	
	self addDelegate: anObject withName: (anObject name asString).
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> addDelegate: anObject withName: aString [

	"This method is the exact copy of TraitList>>addDelegate:withName:."
	"TODO: merge methods into common place, maybe PrototypeObjectWithSources?"

	| aName |

	(self delegateNames includes: (aString asSymbol)) ifFalse:
	[
		self addDelegate: (aString asAlphaNum) withValue: anObject.
	]
	ifTrue:
	[
		aName:=UIManager default request: 'new name?' initialAnswer: aString.
		((aName~='') & (aName notNil)) ifTrue:
		[
			self addDelegate: anObject withName: aName.
		]
	].
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> addExistingDelegate [

	"This method is the exact copy of TraitList>>addExistingDelegate."
	"TODO: merge methods into common place, maybe PrototypeObjectWithSources?"
	
	(MyRepository 
		menuOfAllSimSpacesWithTarget: self 
		selector: #addDelegate: 
		root: (MyRepository at: 'DEVSTraitsAndPrototypes' ifAbsent: [MyRepository root]) 
		classList: PrototypeObjectForMyRepository) 
		popUpInWorld.
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> componentNames [

	^Array new
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> copyToClipboard [

	MyRepository clipboardObject: self
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> cutAction [

	self copyToClipboard.
	self parent removeComponents: (Array with: self name)	

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> deleteAction [

	(UIManager default confirm: 'All information contained in the object will be lost! Really DELETE ?')
		ifTrue: [ self parent removeComponents: (Array with: self name) ].
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> fileOutAction [

	| fileStream |

	fileStream := (StandardFileMenu newFileStreamFrom: FileDirectory default ).
	fileStream ifNil: [^ nil].

	fileStream store: self.
	fileStream close.

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> fullName [

	^ self name
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> getMenu [

  | myMenu |

  myMenu:=MenuMorph new.
  myMenu addTitle: 'Object'.
  myMenu add: 'open' target: self selector: #inspect.
  myMenu addLine.
  myMenu add: 'add existing delegate' target: self selector: #addExistingDelegate.
  myMenu add: 'ref. paste' target: self selector: #pasteDelegate.
  myMenu addLine.
  myMenu add: 'copy' target: self selector: #copyToClipboard.
  myMenu add: 'cut' target: self selector: #cutAction.
  myMenu add: 'rename' target: self selector: #renameAction.
  myMenu add: 'delete' target: self selector: #deleteAction.
  myMenu addLine.
  myMenu add: 'file out ...' target: self selector: #fileOutAction.

  ^myMenu

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> name [

	| n |
	self nameInSimSpace size > 0 
		ifTrue: [ n := self nameInSimSpace ] 
		ifFalse: [ n := 'a Prototype Object' ].
	^ n
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> name: n [

	(self nameInSimSpace size > 0) & (self nameInSimSpace ~= n)
		ifTrue: [ self nameInSimSpace: n ] 

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> nameInSimSpace [

	^ self pathName size > 0 ifTrue: [ (self pathName findTokens: '/') last ] ifFalse: [ '' ]
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> nameInSimSpace: n [

	self parentInSimSpace removeComponents: { self nameInSimSpace }; addComponents: { n -> self }.

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> parent [

	^ self parentInSimSpace

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> parent: p [


]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> parentInSimSpace [

	| delimiter i dirName pathName |
	pathName := self pathName. delimiter := $/.
	(i := pathName findLast: [:c | c = delimiter]) = 0
		ifTrue:
			[dirName := String new]
		ifFalse:
			[dirName := pathName copyFrom: 1 to: (i - 1 max: 1)].

	^ self pathName size > 0 
		ifTrue: [ MyRepository root objectWithPathName: dirName ] 
		ifFalse: [ nil ].


]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> parentInSimSpace: p [


]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> pasteDelegate [

	"This method is the exact copy of TraitList>>pasteDelegate."
	"TODO: merge methods into common place, maybe PrototypeObjectWithSources?"

	| obj |

	"NOTE: it gets a reference on the trait!!!"
	obj:=MyRepository getClipboardObject.
	(obj isKindOf: PrototypeObjectForMyRepository) ifTrue:
	[
		self addDelegate: obj withName: (obj name asString).
	]
	ifFalse:
	[
		self inform: 'The object on the clipboard cannot be used as a delegate.'.
	].
]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> pathName [

	^ MyRepository root pathNameForObject: self

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> renameAction [
  | str n |
  str:=UIManager default request: 'Rename' initialAnswer: self name asString.
  n := self parent assureComponentName: (str asAlphaNum).
  n ifNotNil: [ self parent rename: self name to: n asSymbol ].

]

{ #category : #'as yet unclassified' }
PrototypeObjectForMyRepository >> species [

	^ PrototypeObjectForMyRepository
]
