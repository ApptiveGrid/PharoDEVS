"
I am used as a replacement of hard links to shared objects before serialization of PrototypeObjects. Since I am a proxy, all is working like without me.

After deserialization, it is possible to keep my instances living, or remove them by executing:

Smalltalk garbageCollect.
TemporarySymlink allInstances do: [ :s | s replaceYourselfByTarget ].

Check the result:

Smalltalk garbageCollect.
TemporarySymlink allInstances


TO DO (after testing phase): Replace symlinks by targets automagically immediately after their first successfull use (when target exists).


"
Class {
	#name : #TemporarySymlink,
	#superclass : #Object,
	#instVars : [
		'owner',
		'pathName',
		'cachedTarget'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
TemporarySymlink class >> toObject: o [
	"Well-known object is represented by a TemporarySymlink."
	((o respondsTo: #pathName) and: [ o pathName > '' ])
		ifTrue: [ ^ TemporarySymlink toPathName: o pathName ] 
		ifFalse: [ ^ o ]


]

{ #category : #'as yet unclassified' }
TemporarySymlink class >> toObject: o owner: p [

	((o respondsTo: #pathName) and: [ o pathName > '' ])
		ifTrue: [ ^ (TemporarySymlink toPathName: o pathName) owner: p; yourself ] 
		ifFalse: [ ^ o ]


]

{ #category : #'as yet unclassified' }
TemporarySymlink class >> toPathName: p [

	^ self basicNew pathName: p
]

{ #category : #'as yet unclassified' }
TemporarySymlink >> clearCache [

	cachedTarget := nil

]

{ #category : #'as yet unclassified' }
TemporarySymlink >> doesNotUnderstand: aMessage [

	cachedTarget
		ifNil: [ cachedTarget := MyRepository at: pathName ].
	cachedTarget
		ifNotNil: [
			"self replaceYourselfByTarget"	"automagical replacement !!!" "not tested !!!!"
			^ cachedTarget perform: aMessage selector withArguments: aMessage arguments ]
		ifNil: [ self error: 'Symlink target ', pathName, ' does not exist.' ].


]

{ #category : #'as yet unclassified' }
TemporarySymlink >> eq: aTemporarySymlink [

	^ (aTemporarySymlink class = TemporarySymlink) 
		& (pathName = (aTemporarySymlink instVarNamed: 'pathName'))

]

{ #category : #'as yet unclassified' }
TemporarySymlink >> inspect [

	"Hack inspect to open an inspector over the object pointed to by me."

	cachedTarget
		ifNil: [ 
			cachedTarget := MyRepository at: pathName 
		].
	cachedTarget
		ifNotNil: [
			^ cachedTarget inspect 
		] ifNil: [ 
			self error: 'Symlink target ', pathName, ' does not exist.' 
		].


]

{ #category : #'as yet unclassified' }
TemporarySymlink >> owner: o [

	owner := o
]

{ #category : #'as yet unclassified' }
TemporarySymlink >> pathName: p [

	pathName := p
]

{ #category : #'as yet unclassified' }
TemporarySymlink >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('; print: owner; nextPutAll: '-->'; nextPutAll: pathName; nextPutAll: ')'.
]

{ #category : #'as yet unclassified' }
TemporarySymlink >> replaceYourselfByTarget [

	owner ifNil: [
		"PrototypeObject>sixxOn sets owner since cyclical references are not a problem there. 
		PrototypeObject>>storeOn: does not set the owner. We must search for it."
		owner := self theOnlyPrototypeObjectPointingToMe ].
	owner ifNil: [ self error: 'TemporarySymlink: Owner not known.' ].
	cachedTarget ifNil: [ cachedTarget := MyRepository at: pathName ifAbsent: [
		self error: 'TemporarySymlink: Target not known. ' ]].
	(owner isKindOf: PrototypeObject) 
		ifTrue: [
			owner slotNames, owner delegateNames do: [ :sn |
				(owner perform: sn asSymbol) == self ifTrue: [
					(owner perform: (sn, ':') asSymbol with: cachedTarget) ]]]
		ifFalse: [ self error: 'TemporarySymlink: Improper use.' ]


]

{ #category : #'as yet unclassified' }
TemporarySymlink >> sixxContentOn: aStream indent: level context: dictionary [ 

	aStream cr.
	(self class allInstVarNames difference: #('cachedTarget' "'owner'"))
		do: 
			[:nm | 
			(self instVarNamed: nm) 
				sixxOn: aStream
				name: nm
				indent: level
				context: dictionary].
	aStream tab: level
]

{ #category : #'as yet unclassified' }
TemporarySymlink >> storeOn: aStream [

"	aStream nextPut: $(; nextPutAll: self class name, ' new'.
	(self class allInstVarNames difference: #('cachedTarget' 'owner')) do: [:n |
		aStream nextPutAll: ' instVarNamed: ';
			store: n;
			nextPutAll: ' put: ';
			store: (self instVarNamed: n);
			nextPut: $;; cr ].
	aStream nextPutAll: ' yourself)'; cr
"

	aStream cr; tab; nextPut: $(; nextPutAll: self class name; nextPutAll: ' toPathName: '; store: pathName.
	aStream nextPutAll: ') '

]

{ #category : #'as yet unclassified' }
TemporarySymlink >> theOnlyPrototypeObjectPointingToMe [
	"... or nil"
	"Note: This is time consuming operation !!!"

	| allArrays slotArrays prototypeObjects prototypeObject |
	"searching for array of slots pointing to me"
	allArrays := (PointerFinder pointersTo: self) select: [ :p | p isKindOf: Array ]. 
	slotArrays := allArrays select: [ :q |
		prototypeObjects := (PointerFinder pointersTo: q) select: [ :r | r isKindOf: PrototypeObject ]. 
		prototypeObjects size = 1 ifTrue: [ prototypeObject :=  prototypeObjects at: 1 ].
		prototypeObjects size = 1 ].
	^ (slotArrays size = 1) ifTrue: [ prototypeObject ] ifFalse: [ nil ]


]
