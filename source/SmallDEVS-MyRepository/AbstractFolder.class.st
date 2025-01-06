Class {
	#name : #AbstractFolder,
	#superclass : #Object,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
AbstractFolder >> acceptsFiles [
	"Is it possible to put imported files to me? By default, it is not good idea. Subclasses can decide themselves."

	^ false

]

{ #category : #'as yet unclassified' }
AbstractFolder >> addComponent: c named: n [

	self subclassResponsibility.

]

{ #category : #'as yet unclassified' }
AbstractFolder >> addComponents: associations [

	associations do: [ :a | self addComponent: a value named: a key ].
	(MyRepository root) changed: #hierarchicalList.

]

{ #category : #'as yet unclassified' }
AbstractFolder >> assureComponentName: aName [
	"Checks wheter the a component with the name aName already exists. If yes, it asks for a new name. In case of success, returns the new name otherwise returns nil."

	| str |
	(self componentNames includes: aName)
		ifTrue: [
			str := UIManager default 
				request: 'Name already in use. Specify another one.' 
				initialAnswer: (aName asString).
			str = '' 
				ifTrue: [ ^nil ]
     			ifFalse: [ ^self assureComponentName: (str asSymbol) ] ].
	^ aName.

]

{ #category : #'as yet unclassified' }
AbstractFolder >> componentNamed: n [

	^ self componentNamed: n ifAbsent: [nil]
]

{ #category : #'as yet unclassified' }
AbstractFolder >> componentNames [

	^ Set new
]

{ #category : #'as yet unclassified' }
AbstractFolder >> copyToClipboard [

	MyRepository clipboardObject: self
]

{ #category : #'as yet unclassified' }
AbstractFolder >> cutAction [

	self copyToClipboard.
	self parent removeComponents: (Array with: self name)	

]

{ #category : #'as yet unclassified' }
AbstractFolder >> deleteAction [

	(UIManager default confirm: 'All information contained in the object will be lost! Really DELETE ?')
		ifTrue: [ self parent removeComponents: (Array with: self name) ].
]

{ #category : #'as yet unclassified' }
AbstractFolder >> eq: anObject [

	anObject class = self class ifFalse: [ NonEqDetected signal. ^ false ].

	self name = anObject name ifFalse: [ NonEqDetected signal. ^ false ].

	(self componentNames) do: [ :c | 
		((self componentNamed: c) eq: (anObject componentNamed: c)) ifFalse: [ NonEqDetected signal. ^ false ] ].

	^ true
]

{ #category : #'as yet unclassified' }
AbstractFolder >> fullName [

	^ self name
]

{ #category : #'as yet unclassified' }
AbstractFolder >> isAtom [

	^ self isFolder not
]

{ #category : #'as yet unclassified' }
AbstractFolder >> isFolder [

	^ true
]

{ #category : #'as yet unclassified' }
AbstractFolder >> pasteAction [

	| obj aSymbol |
	obj := MyRepository getClipboardObjectCopy.
	obj ifNotNil: [
		aSymbol := self assureComponentName: (obj name).
		aSymbol ifNotNil: [
   	  		self addComponents: { aSymbol -> obj } ] ].

]

{ #category : #'as yet unclassified' }
AbstractFolder >> pasteAsAction [

	| obj aSymbol str |
	obj := MyRepository getClipboardObjectCopy.
	obj ifNotNil: [
		str := UIManager default request: 'Paste as:' initialAnswer: obj name asString.
		str ~= '' ifTrue: [
			aSymbol := self assureComponentName: str.
			aSymbol ifNotNil: [
				self addComponents: { aSymbol -> obj } ] ] ].

]

{ #category : #'as yet unclassified' }
AbstractFolder >> pathName [
  
	self parent isNil ifTrue: [ ^ '' ] ifFalse: [^ self parent pathName,'/', self name ].
]

{ #category : #'as yet unclassified' }
AbstractFolder >> removeComponentNamed: n [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
AbstractFolder >> removeComponents: compList [

	compList do: [ :x |
		self removeComponentNamed: x ].
	(MyRepository root) changed: #hierarchicalList.

]

{ #category : #'as yet unclassified' }
AbstractFolder >> rename: n1 to: n2 [

	| aComponent |
	(self componentNames includes: n1) ifFalse: [^false].
	(self componentNames  includes: n2) ifTrue: [^false].
	aComponent := self componentNamed: n1.
	self removeComponents: { n1 }.
	self addComponents: { n2 -> aComponent }.
	^true

]

{ #category : #'as yet unclassified' }
AbstractFolder >> renameAction [
	| str |
	str := UIManager default request: 'Rename' initialAnswer: self name asString.
	str > '' ifTrue: [ self renameTo: str ]

]

{ #category : #'as yet unclassified' }
AbstractFolder >> renameComponentNamed: n1 to: n2 [

	^ self rename: n1 to: n2
]

{ #category : #'as yet unclassified' }
AbstractFolder >> renameTo: str [
	"Return true if this is OK."

	| n | 
	n := self parent assureComponentName: str.
	n ifNotNil: [ self parent rename: self name to: str asSymbol ].
	^ n notNil  

]
