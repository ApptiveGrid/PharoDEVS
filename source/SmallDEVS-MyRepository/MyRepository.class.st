"
MyRepository is a folder which contains named components. Each component must understand to the same accessing protocol as MyRepository.

MyRepository root (stored in a class instance variable) represents a root of a hierarchy of objects. Each component (storeable object) in the hierarchy is globally identifiable by its pathname. Originally, as part of SmallDEVS package, it was designed to contain models and simulations. Now it is used more generally. 

Simulations are supposed to be subclasses of AbstractSimulation. An exampe of a simulation is a CoupledDevs wrapped by DEVSRootSolver (see SM package SmallDEVS). The CoupledDEVS is also a folder - it contains named components. 

Other kinds of storeable objects are Document and LaTeXDocument.


Example:

MyRepository Initialize.
MyRepository root explore.
MyRepository openBrowser.
(MyRepository root componentNamed: 'Prototypes') explore.

Further development leads towards an in-image ""filesystem"".

To do: Protocol for editing ordering of components.


"
Class {
	#name : #MyRepository,
	#superclass : #AbstractFolder,
	#instVars : [
		'parent',
		'name',
		'namedComponents'
	],
	#classInstVars : [
		'Root',
		'ClipboardObject',
		'AccessProtect',
		'SimulationsToWakeUpAtStart'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
MyRepository class >> Initialize [
	"MyRepository Initialize"

	Root isNil ifFalse: [ 
		(UIManager default confirm: 'Going to delete whole MyRepository hierrachy !' orCancel: [^'Nevermind'])
			ifFalse: [ ^self ]]. 

	Root := MyRepository new. Root name: 'Root'.

	Root addComponents: { 
		'Documents' -> MyRepository new. 
		'DEVSTraitsAndPrototypes' -> MyRepository new. 
		'Simulations' -> MyRepository new. 
		'TMP' -> MyRepository new }.
	ClipboardObject := nil.

	self register


]

{ #category : #'as yet unclassified' }
MyRepository class >> Root: obj [

	(UIManager default confirm: 'Going to replace whole MyRepository hierrachy !' orCancel: [^'Nevermind'])
			ifFalse: [ ^self ]. 
	Root become: obj.
	(MyRepository root) changed: #hierarchicalList.

]

{ #category : #'as yet unclassified' }
MyRepository class >> accessProtect [
	AccessProtect ifNil: [ AccessProtect := Semaphore forMutualExclusion ].
	^ AccessProtect
]

{ #category : #'as yet unclassified' }
MyRepository class >> addComponents: compList [

	^ self root addComponents: compList

]

{ #category : #'as yet unclassified' }
MyRepository class >> allSimulations [
	"Collect all simulations, including nested simulations"
	^ AbstractSimulation allSubInstances	"it's not quite sure they are all in MyRepository"

]

{ #category : #'as yet unclassified' }
MyRepository class >> at: p [

	^ self root objectWithPathName: p

]

{ #category : #'as yet unclassified' }
MyRepository class >> at: p ifAbsent: aBlock [ 

	| o |
	o := self at: p.
	^ o ifNil: [ aBlock value ] ifNotNil: [ o ]


]

{ #category : #'as yet unclassified' }
MyRepository class >> at: pathName put: obj [

	| c nm |
	(pathName = '') | (pathName = '/') ifTrue: [ MyRepository Root: obj. ^self ].
	c := MyRepository root.
	(pathName asString findTokens: '/') allButLast do: [ :n | 
		c := c componentNamed: n ifAbsent: [ 
			c addComponents: { n -> MyRepository new}.
			c := c componentNamed: n ] ].
	nm := (pathName asString findTokens: '/') last. 
	nm := c assureComponentName: nm.
	c addComponents: { nm -> obj }

]

{ #category : #clipboard }
MyRepository class >> clipboardObject: anObject [

  "place the reference of the object to the clipboard"
  ClipboardObject := anObject.
]

{ #category : #'as yet unclassified' }
MyRepository class >> componentNamed: n [

	^ self root componentNamed: n
]

{ #category : #'as yet unclassified' }
MyRepository class >> componentNames [

	^ self root componentNames
]

{ #category : #clipboard }
MyRepository class >> getClipboardObject [

  "get a reference of the clipboard object"
  ^ ClipboardObject
]

{ #category : #clipboard }
MyRepository class >> getClipboardObjectCopy [

  "get a COPY of the clipboard object"
  (ClipboardObject isKindOf: BaseDEVS) ifTrue:
  [
	^ ClipboardObject safeCopy.
  ]
  ifFalse:
  [
	^ ClipboardObject copy.
  ].
]

{ #category : #'as yet unclassified' }
MyRepository class >> makeSARfrom: obj [
"
	self makeStoreStringSARfrom: obj.
"
	self makeSIXXSARfrom: obj


]

{ #category : #'as yet unclassified' }
MyRepository class >> makeSIXXSARfrom: obj [
	| sar sarName |

Cursor write showWhile: [

	sar := ZipArchive new.
	"sar addString: obj sixxString as: 'sixxstring'."
	sar addCompressedString:  (obj sixxString convertToWithConverter: (TextConverter newForEncoding: 'utf-8')) as: 'sixxstring'.

	sar addString: 'Cursor read showWhile: [ MyRepository at: ', obj pathName storeString, 
		' put: (Object readSixxFrom: ((self memberNamed: ''sixxstring'') contents convertFromWithConverter: (TextConverter newForEncoding: ''utf-8''))) ]. ' as: 'install/preamble'.

	sarName := 'Root', ((obj pathName copyWithRegex: '/' matchesReplacedWith: '.') copyWithRegex: ' ' matchesReplacedWith: '_'), '.sar'.

	sar writeToFileNamed: sarName.

]


]

{ #category : #'as yet unclassified' }
MyRepository class >> makeStoreStringSARfrom: obj [
	| sar sarName |
	sar := ZipArchive new.
	sar addString: obj storeString as: 'storestring'.

	sar addString: 'MyRepository at: ', obj pathName storeString, 
		' put: (Object readFrom: (self memberNamed: ''storestring'') contents). ' as: 'install/preamble'.

	sarName := 'Root', ((obj pathName copyWithRegex: '/' matchesReplacedWith: '.') copyWithRegex: ' ' matchesReplacedWith: '_'), '.sar'.

	sar writeToFileNamed: sarName.

]

{ #category : #'as yet unclassified' }
MyRepository class >> menuOfAllSimSpacesWithTarget: aTarget selector: aSelector root: anObject [

  | aMenu item obj |

  aMenu:=MenuMorph new.
  item:=anObject.
  (item isKindOf:AtomicDEVS) ifTrue:
  [
	aMenu add: (item name) target: aTarget selector: aSelector argumentList: (Array with: item).
	^aMenu.
  ].
  (anObject isKindOf: DEVSRootSolver) ifTrue: [item:=anObject rootDEVS].
  (item componentNames isEmpty) 
  ifTrue: 
  [aMenu add: 'empty...' target: aTarget selector: #yourself argumentList: #().].
  item componentNames do:
  [
	:cn |
	obj:=item componentNamed: cn.
	(obj isKindOf:AtomicDEVS) 
	ifTrue:
  	[
		aMenu add: (obj name) target: aTarget selector: aSelector argumentList: (Array with: obj).
  	]
	ifFalse:
	[
		| subMenu |
		(obj isKindOf: DEVSRootSolver) ifTrue: [obj:=obj rootDEVS].
		subMenu:=self menuOfAllSimSpacesWithTarget: aTarget selector: aSelector root: obj.
		aMenu add: (obj name asString) subMenu: subMenu target: aTarget selector: aSelector argumentList: (Array with: obj).
	].
  ].
  ^aMenu.
]

{ #category : #'as yet unclassified' }
MyRepository class >> menuOfAllSimSpacesWithTarget: aTarget selector: aSelector root: anObject classList: aClass [

  | aMenu item obj subMenu |

  aMenu:=MenuMorph new.
  item:=anObject.
  (item isKindOf: aClass)
  ifTrue:
  [
	aMenu add: (item name asString) target: aTarget selector: aSelector argumentList: (Array with: item).
    ^aMenu
  ].
  (item componentNames isEmpty)
  ifTrue: 
  [
	aMenu add: 'empty...' target: aTarget selector: #yourself argumentList: #().
  ]
  ifFalse:
  [
  	item componentNames do:
  	[
		:cn |
		obj:=item componentNamed: cn.
		(obj componentNames isEmpty) ifTrue:
		[
			aMenu add: (obj name asString) target: aTarget selector: aSelector argumentList: (Array with: obj).
		]
		ifFalse:
		[
			subMenu:=self menuOfAllSimSpacesWithTarget: aTarget selector: aSelector root: obj classList: aClass.
			aMenu add: (obj name asString) subMenu: subMenu target: aTarget selector: aSelector argumentList: (Array with: obj).
		].
	].
  ].
  ^aMenu.
]

{ #category : #'as yet unclassified' }
MyRepository class >> newFolder [
	^ self new
]

{ #category : #'as yet unclassified' }
MyRepository class >> objectWithPathName: p [

	^ self root objectWithPathName: p

]

{ #category : #'as yet unclassified' }
MyRepository class >> openBrowser [

	MyRepositoryBrowser new openInWorldExtent: 300@300

]

{ #category : #'as yet unclassified' }
MyRepository class >> pathNameForObject: o [

	^ self root pathNameForObject: o
]

{ #category : #'as yet unclassified' }
MyRepository class >> register [

	(TheWorldMenu respondsTo: #registerOpenCommand:) ifTrue: [
		TheWorldMenu unregisterOpenCommand: 'SimSpace Explorer'.
		TheWorldMenu unregisterOpenCommand: 'MyRepository Browser'.
		TheWorldMenu registerOpenCommand: {'MyRepository Browser'. {self. #openBrowser}}].
	Smalltalk addToStartUpList: self.
	Smalltalk addToShutDownList: self.

]

{ #category : #'as yet unclassified' }
MyRepository class >> removeComponents: compList [

	^ self root removeComponents: compList
]

{ #category : #'as yet unclassified' }
MyRepository class >> root [

	Root isNil ifTrue: [ self Initialize ].
	^ Root
 

]

{ #category : #'as yet unclassified' }
MyRepository class >> shutDown [
	SimulationsToWakeUpAtStart := self simulations select: [ :s | s isRunning ].
	SimulationsToWakeUpAtStart do: [ :s | Transcript show: 'Stopping simulation ...'; cr. s stop ].	

]

{ #category : #'as yet unclassified' }
MyRepository class >> simulations [
	"Collect all simulations in MyRepository"
	^ self allSimulations	"TO DO: exclude nested simulations because they are controlled exclusively by theit supersimulations !!!!!!!!!!!!!!!!!!!!!"

]

{ #category : #'as yet unclassified' }
MyRepository class >> startUp [
	SimulationsToWakeUpAtStart do: [ :s | Transcript show: 'Starting simulation ...'; cr. s start ].	

]

{ #category : #'as yet unclassified' }
MyRepository >> accessProtect [
	^ self class accessProtect
]

{ #category : #accessing }
MyRepository >> addComponent: c named: n [

	namedComponents at: n put: c.
	c parent: self.
	c name: n.



]

{ #category : #'as yet unclassified' }
MyRepository >> changed: aParameter [
	self accessProtect critical: [ super changed: aParameter ]
]

{ #category : #misc }
MyRepository >> checkTree: nodes [
	"MyRepository root checkTree: OrderedCollection new"

	(nodes includes: self) ifTrue: [ self error: 'Tree structure corrupted !!!' ].
	nodes add: self.
	namedComponents valuesDo: [ :v | 
		(v respondsTo: #checkTree:) ifTrue: [ v checkTree: nodes ] ].
	^ nodes

]

{ #category : #accessing }
MyRepository >> componentNamed: n ifAbsent: aBlock [

	n == #self ifTrue: [ ^ self ].
	^ namedComponents at: n ifAbsent: aBlock
]

{ #category : #accessing }
MyRepository >> componentNames [

	^ namedComponents keys
]

{ #category : #'as yet unclassified' }
MyRepository >> contentsChanged [

	"ignore"
]

{ #category : #copying }
MyRepository >> copy [

	| aCopy var |
	
	"we must copy each instance variable, because of the successors of MyRepository"
	aCopy := (self class) new.
	"parent MUST BE NIL, will be set in addComponents:"
	aCopy name: name; parent: nil.
	"We don't trust in the copy method of Dictionary. Later we could use MyDictionary that copies every element."
	namedComponents keysAndValuesDo: [:k :v | aCopy addComponents: { k-> (v copy)}].
	"the remaining instance variables are copied with copy, hopefully"
	(self class allInstVarNames difference: {'parent'. 'namedComponents'. 'name'. }) do: 
	[:n |
		var := (self instVarNamed: n) copy.	
		aCopy instVarNamed: n put: var.
	].
	^  aCopy

]

{ #category : #'menu actions' }
MyRepository >> fileInAction [

	| stdFileMenuResult obj aSymbol filename objname |

	stdFileMenuResult := ((StandardFileMenu new) pattern: '*';	"*.storestring ?" 
		oldFileFrom: FileDirectory default ) 
			startUpWithCaption: 'Select a File:' translated.
	stdFileMenuResult ifNil: [^ nil].

	filename := (stdFileMenuResult directory) fullNameFor: (stdFileMenuResult name). 

	obj := Object readFrom: (FileStream readOnlyFileNamed: filename) contentsOfEntireFile. "we use string here becouse reading from stream is bugy "
	obj ifNotNil: [
		objname := obj name isNil ifTrue: [ stdFileMenuResult name ] ifFalse: [ obj name ].
		aSymbol := self assureComponentName: objname.
		aSymbol ifNotNil: [ self addComponents: { aSymbol -> obj } ] ].

]

{ #category : #'menu actions' }
MyRepository >> fileInFromMethodAction [

	| class message obj aSymbol objname |

	"TO DO: dialog"
	class := #MyRepository.
	message := #aStoreString.

	obj := Object readFrom: ((Smalltalk at: class) perform: message). 
	obj ifNotNil: [
		objname := obj name isNil ifTrue: [ message asString ] ifFalse: [ obj name ].
		aSymbol := self assureComponentName: objname.
		aSymbol ifNotNil: [ self addComponents: { aSymbol -> obj } ] ].


]

{ #category : #'menu actions' }
MyRepository >> fileIntoSimulationAction [

	| stdFileMenuResult obj aSymbol filename objname |

	stdFileMenuResult := ((StandardFileMenu new) pattern: '*';	"*.storestring ?" 
		oldFileFrom: FileDirectory default ) 
			startUpWithCaption: 'Select a File:' translated.
	stdFileMenuResult ifNil: [^ nil].

	filename := (stdFileMenuResult directory) fullNameFor: (stdFileMenuResult name). 

	obj := Object readFrom: (FileStream readOnlyFileNamed: filename) contentsOfEntireFile.
	obj ifNotNil: 
	[
		(obj isKindOf: CoupledDEVS) ifTrue:
		[
			objname := obj name isNil ifTrue: [ stdFileMenuResult name ] ifFalse: [ obj name ].
			aSymbol := self assureComponentName: objname.
			aSymbol ifNotNil:
			[
				obj name: aSymbol.
				self addComponents: {aSymbol -> (obj getSimulatorRT deepVerbose: false; reportStream: (DummyStream on: nil); yourself)}.
			].
		]
		ifFalse:
		[
			self error: 'Inappropriate object. Must be CoupledDEVS!'.
		].
	].

]

{ #category : #'menu actions' }
MyRepository >> fileOutAction [

	| fileStream |

	(self confirm: 'DANGEROUS !!! Are you sure? Have you saved your image before?') ifFalse: [ ^nil ].

	fileStream := (StandardFileMenu newFileStreamFrom: FileDirectory default ).
	fileStream ifNil: [^ nil].

	fileStream store: self.
	fileStream close.

]

{ #category : #menu }
MyRepository >> getMenu [
  | myMenu newMenu importMenu |
  myMenu:=MenuMorph new.
  "self isFolder ifFalse:" (self species canUnderstand: #open) ifTrue: [ 
	myMenu add: 'open' target: self selector: #open.
  	myMenu addLine ].
  newMenu:=self newMenu.
  newMenu ifNotNil: [ 
	myMenu add: 'new' subMenu: newMenu target: self selector: #yourself argumentList: #().
  	myMenu addLine ].
  myMenu add: 'copy' target: self selector: #copyToClipboard.
  parent ifNotNil: [ myMenu add: 'cut' target: self selector: #cutAction ].
  self isFolder ifTrue: [ myMenu add: 'paste' target: self selector: #pasteAction ].
  self isFolder ifTrue: [ myMenu add: 'paste as ...' target: self selector: #pasteAsAction ].
  parent ifNotNil: [ myMenu add: 'rename' target: self selector: #renameAction ].
  parent ifNotNil: [ myMenu add: 'delete' target: self selector: #deleteAction ].
  myMenu addLine.
  myMenu add: 'make SAR' target: self selector: #makeSAR.
  myMenu add: 'file out ...' target: self selector: #fileOutAction.
  self isFolder ifTrue: [ myMenu add: 'file in ...' target: self selector: #fileInAction ].
  self isFolder ifTrue: [ myMenu add: 'file into simulation ...' target: self selector: #fileIntoSimulationAction].
  myMenu addLine.
"  myMenu add: 'store as a method ...' target: self selector: #installStoreStringAsMethodAction.
  self isFolder ifTrue: [ myMenu add: 'file in using a method ... ' target: self selector: #fileInFromMethodAction ].
  myMenu addLine. "
  importMenu:=self importMenu.
  importMenu ifNotNil: [ 
	myMenu add: 'import' subMenu: importMenu target: self selector: #yourself argumentList: #().
  	myMenu addLine ].
  myMenu add: 'inspect' target: self selector: #inspect.
  ^myMenu
]

{ #category : #'menu actions' }
MyRepository >> importAllFilesFromDirectory [

	| directory |
	directory := FileList2 modalFolderSelector.
	directory ifNil: [^self].
	self importFrom: directory

]

{ #category : #'menu actions' }
MyRepository >> importDirectory [

	| directory aSymbol dirname obj |
	directory := FileList2 modalFolderSelector.
	directory ifNil: [^self].
	dirname := directory pathParts last.
	aSymbol := self assureComponentName: dirname.	
	aSymbol ifNotNil: [
		obj := (ImportedDirectory new importFrom: directory ; yourself). 
		self addComponents: { aSymbol -> obj } ].



]

{ #category : #'menu actions' }
MyRepository >> importFile [

	| filename obj aSymbol filestream |
	filestream := FileList2 modalFileSelector.
	filestream ifNil: [^self].
	filename := filestream localName.
	obj := filestream binary; contentsOfEntireFile.
	obj ifNotNil: [
		aSymbol:=self assureComponentName: filename.
		aSymbol ifNotNil: [ self addComponents: { aSymbol -> (ImportedFile contents: obj) } ] ].

]

{ #category : #'menu actions' }
MyRepository >> importFrom: aFileDirectory [

	| aSymbol obj file |
	aFileDirectory fileNames do: [ :fn | 
		aSymbol := self assureComponentName: fn.	
		file := (FileStream readOnlyFileNamed: (aFileDirectory fullNameFor: fn)) contentsOfEntireFile.
		aSymbol notNil & file notNil ifTrue: [
			self addComponents: { aSymbol -> (ImportedFile contents: file) } ]].
 	aFileDirectory directoryNames do: [ :fn | 
		aSymbol := self assureComponentName: fn.	
		aSymbol ifNotNil: [
			obj := (ImportedDirectory new 
				importFrom: (aFileDirectory directoryNamed: fn) ; 
				yourself). 
			self addComponents: { aSymbol -> obj } ]].

]

{ #category : #menu }
MyRepository >> importMenu [
	"subclasses may return nil"
  | m |
  self acceptsFiles ifTrue: [   
		m:=MenuMorph new.
		m add: 'import file ...' target: self selector: #importFile.
		m add: 'import all files from directory ...' target: self selector: #importAllFilesFromDirectory.
		m add: 'import directory ...' target: self selector: #importDirectory ].
 ^ m

]

{ #category : #initializing }
MyRepository >> initialize [

	namedComponents := Dictionary new.
]

{ #category : #'menu actions' }
MyRepository >> installStoreStringAsMethodAction [

	| class message |


	(self confirm: 'DANGEROUS !!! Are you sure? Have you saved your image before?') ifFalse: [ ^nil ].

	self inform: 'a storeString will be installed as a method ... in a class ... '.

	"TO DO: dialog"
	class := #MyRepository.
	message := #aStoreString.

	(Smalltalk at: class) class compile: message asString, String cr, '^', self storeString printString.


]

{ #category : #'as yet unclassified' }
MyRepository >> makeSAR [
	self class makeSARfrom: self
]

{ #category : #accessing }
MyRepository >> name [

	^ name
]

{ #category : #accessing }
MyRepository >> name: anObject [

	name := anObject
]

{ #category : #'menu actions' }
MyRepository >> newDocument [

  | str |

  str:=UIManager default request: 'New document name' initialAnswer: 'noname'.
  str := self assureComponentName: str.
  str~='' & str notNil ifTrue: [ self addComponents: {str -> Document new} ].

]

{ #category : #'menu actions' }
MyRepository >> newFolder [

  | str |

  str:=UIManager default request: 'New folder name' initialAnswer: 'noname'.
  str := self assureComponentName: str.
  str~='' & str notNil ifTrue: [ self addComponents: {str -> MyRepository new} ].

]

{ #category : #'menu actions' }
MyRepository >> newLaTeXDocument [

  | str |

  str:=UIManager default request: 'New document name' initialAnswer: 'noname'.
  str := self assureComponentName: str.
  str~='' & str notNil ifTrue: [ self addComponents: {str -> LaTeXDocument new} ].

]

{ #category : #menu }
MyRepository >> newMenu [
	"subclasses may return nil"
  | newMenu |
  self isFolder ifFalse: [ ^nil ].
  newMenu:=MenuMorph new.
  newMenu add: 'folder' target: self selector: #newFolder.
  newMenu addLine.
  newMenu add: 'text document' target: self selector: #newDocument.
  newMenu add: 'LaTeX document' target: self selector: #newLaTeXDocument.
  newMenu add: 'simulation' target: self selector: #newSimulation.
  newMenu add: 'prototype or trait object' target: self selector: #newPrototypeObject.
  newMenu add: 'PNtalk class' target: self selector: #newPNClass.
  ^ newMenu
]

{ #category : #'menu actions' }
MyRepository >> newPNClass [

  | str |

  str:=UIManager default request: 'New PNtalk class name' initialAnswer: 'noname'.
  str := self assureComponentName: str.
  str~='' & str notNil ifTrue: [ self addComponents: {str -> PNCompiledClass new} ].

]

{ #category : #'menu actions' }
MyRepository >> newPrototypeObject [

  | str |

  str:=UIManager default request: 'New folder name' initialAnswer: 'noname'.
  str := self assureComponentName: str.
  str~='' & str notNil ifTrue: [ 
	self addComponents: {str -> PrototypeObjectForMyRepository new} ].

	

]

{ #category : #'menu actions' }
MyRepository >> newSimulation [

  | str cd aSymbol |

  str:=UIManager default request: 'new simulation name'.
  str~='' & str notNil ifTrue:
  [
	aSymbol:=self assureComponentName: (str asSymbol).
	aSymbol ifNotNil:
	[
	  	cd:=CoupledDEVSPrototype new.
	  	cd name: aSymbol.
	  	self addComponents: { aSymbol -> (cd getSimulatorRT deepVerbose: false; reportStream: (DummyStream on: nil); yourself)}.
	].
  ].


]

{ #category : #misc }
MyRepository >> objectWithPathName: p [

	| c |
	c := MyRepository root.
	(p asString findTokens: '/') do: [ :n | c := c componentNamed: n ifAbsent: [ ^nil ] ]. 
	^ c

]

{ #category : #accessing }
MyRepository >> parent [

	^ parent
]

{ #category : #accessing }
MyRepository >> parent: anObject [

	parent := anObject
]

{ #category : #misc }
MyRepository >> pathNameForObject: o [

	| c path nam |
	path := ''.
	c := namedComponents select: [ :a | a value == o ].
	c size > 0 
		ifTrue: [ 
			c keys do: [ :key | nam := key ].
			^ (self pathName, '/', nam asString) copy ]
		ifFalse: [ 
			namedComponents valuesDo: [ :v |
				(v respondsTo: #pathNameForObject:) ifTrue: [ path := v pathNameForObject: o ].
				path size > 0 ifTrue: [ ^ path copy ] ]].
	^ path
]

{ #category : #printing }
MyRepository >> printOn: aStream [

	name isNil 
		ifTrue: [ super printOn: aStream ]
		ifFalse: [ aStream nextPutAll: name asString ]

]

{ #category : #accessing }
MyRepository >> removeComponentNamed: c [

	namedComponents removeKey: c ifAbsent: [] 

]

{ #category : #querying }
MyRepository >> root [

	^ self class root
]

{ #category : #copying }
MyRepository >> sixxContentOn: aStream indent: level context: dictionary [ 

	aStream cr.
	(self class allInstVarNames difference: #('parent'))
		do: 
			[:nm | 
			(self instVarNamed: nm) 
				sixxOn: aStream
				name: nm
				indent: level
				context: dictionary].
	aStream tab: level
]

{ #category : #copying }
MyRepository >> sixxInitialize [

	namedComponents do: [ :c | c parent: self ].
]

{ #category : #copying }
MyRepository >> storeOn: aStream [

	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' new'.
	(self class allInstVarNames difference: {'parent'. 'namedComponents'. }) do: [:n |
		aStream nextPutAll: ' instVarNamed: ';
			store: n;
			nextPutAll: ' put: ';
			store: (self instVarNamed: n);
			nextPut: $; ; 
			nextPutAll: String cr ].

	"components"
	aStream nextPutAll: 'addComponents: {'; nextPutAll: String cr.
	namedComponents keysAndValuesDo: [ :k :v |
		aStream store: k; nextPutAll: ' -> '; store: v; nextPut: $.; nextPutAll: String cr ].
	aStream nextPutAll: '};'; nextPutAll: String cr.

	aStream nextPutAll: ' yourself)'; nextPutAll: String cr

]
