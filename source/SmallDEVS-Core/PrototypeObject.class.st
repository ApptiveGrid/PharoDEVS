"
PrototypeObjects are objects with instance-specific behavior and structure. You can add and remove slots at any time with the messages

	PrototypeObject addSlot:

	PrototypeObject addSlot:withValue:

	PrototypeObject removeSlot:

Added slots are accessible with standard getter/setter messages.

Methods can be added and removed with

	PrototypeObject addMethod:

	PrototypeObject removeMethod:

PrototypeObjects have a class which is an instance of PrototypeBehavior. Look there for the internals of behavior sharing.



An example structure of PrototypeObjects: execute PrototypeObject exampleFamily.
"
Class {
	#name : 'PrototypeObject',
	#superclass : 'Object',
	#instVars : [
		'slots',
		'delegates'
	],
	#category : 'SmallDEVS-Core',
	#package : 'SmallDEVS-Core'
}

{ #category : 'examples' }
PrototypeObject class >> exampleFamily [

	"PrototypeObject exampleFamily"

	| person child parent dad mom son daughter jimmy patty |

	person := self new.

	person addSlot: 'name'.

	parent := person clone.

	parent addSlot: 'children'.



	dad := parent clone.

	dad name: 'Daddy'.

	mom := parent clone.

	mom name: 'Mommy'.

	dad addSlot: 'wife' withValue: mom.

	mom addSlot: 'husband' withValue: dad.



	child := person clone.

	child addSlot: 'dad' withValue: dad.

	child addSlot: 'mom' withValue: mom.

	child addMethod: 'childSpec ^''child'''.

	child addMethod: 'printOn: aStream

					aStream

						nextPutAll: self name;

						nextPutAll: '', '', self childSpec, '' of '', self dad name;

						nextPutAll: '' and '', self mom name'.

	son := child clone.

	son addMethod: 'childSpec ^''son'''.

	daughter := child clone.

	daughter addMethod: 'childSpec ^''daughter'''.



	jimmy := son clone.

	jimmy name: 'Jimmy'.

	patty := daughter clone.

	patty name: 'Patty'.



	dad children: (OrderedCollection with: jimmy with: patty).

	mom children: dad children copy.



	dad inspect
]

{ #category : 'instance creation' }
PrototypeObject class >> new [

	"Objects are instantiated with no slots"

	^self newPrototypeBehavior basicNew slots: #(); delegates: #()
]

{ #category : 'instance creation' }
PrototypeObject class >> newPrototypeBehavior [

	"Create a new PrototypeBehavior for a cloned object"

	^PrototypeBehavior new fromSuperclass: self
]

{ #category : 'delegation' }
PrototypeObject >> addDelegate: aString withValue: anObject [

	"Add a new slot with the given value. New clones of this object will also have that slot"

	delegates := delegates copyWith: anObject.

	self ownClass compileDelegate: aString index: delegates size
]

{ #category : 'as yet unclassified' }
PrototypeObject >> addDelegates: anArrayOfAssociations [

	anArrayOfAssociations do: [ :assoc |  self addDelegate: assoc key withValue: assoc value ].

]

{ #category : 'slot adding/removing' }
PrototypeObject >> addMethod: aString [
	"Add a new method to the receiver, or overwrite a method of the same name.
	Returns the selector of the new method"

	^self ownClass compile: aString
]

{ #category : 'slot adding/removing' }
PrototypeObject >> addSlot: aString [

	^self addSlot: aString withValue: nil
]

{ #category : 'slot adding/removing' }
PrototypeObject >> addSlot: aString withValue: anObject [
	"Add a new slot with the given value. New clones of this object will also have that slot"

	slots := slots copyWith: anObject.
	self ownClass compileSlot: aString index: slots size
]

{ #category : 'as yet unclassified' }
PrototypeObject >> addSlots: anArrayOfAssociations [

	anArrayOfAssociations do: [ :assoc |  self addSlot: assoc key withValue: assoc value ].

]

{ #category : 'cloning' }
PrototypeObject >> clone [

	self class beShared.

	^super shallowCopy
		privatePostClone;
		postClone;
		yourself
]

{ #category : 'cloning' }
PrototypeObject >> copy [
	^ self clone
]

{ #category : 'inspecting' }
PrototypeObject >> defaultLabelForInspector [

	^self name
]

{ #category : 'as yet unclassified' }
PrototypeObject >> delegateAt: n [
	^self perform: n asSymbol
]

{ #category : 'accessing' }
PrototypeObject >> delegateNames [

	^self class delegateNames
]

{ #category : 'private' }
PrototypeObject >> delegates: anArray [

	delegates := anArray
]

{ #category : 'private' }
PrototypeObject >> doesNotUnderstand: aMessage [ 
	| method selector |
	selector := aMessage selector.
	delegates do: [:each | each
		ifNotNil: [(method := each getCompiledMethod: selector)
				ifNotNil: [method trailer kind = #PrototypeSlot | (method trailer kind = #PrototypeSlotSetter)
						ifTrue: [^ each perform: selector withArguments: aMessage arguments]
						ifFalse: ["self class addSelector: selector withMethod: method.
							result := self perform: selector withArguments: aMessage arguments.
							self class removeSelector: selector.
							^ result"
							"NOTE by ke (2007/09/11): this is a better way, than the original implementation,
													 ensures, that the method is removed from the prototype,
													 thus does not overwrite the original source."
							^ self withArgs: (aMessage arguments) executeMethod: method.							
							]]]].
	^ super doesNotUnderstand: aMessage
]

{ #category : 'as yet unclassified' }
PrototypeObject >> explore [
	^self inspect
]

{ #category : 'private' }
PrototypeObject >> getCompiledMethod: aSelector [
	| temp |
	^self class compiledMethodAt: aSelector ifAbsent: [
		delegates do: [:each |
			(temp := each getCompiledMethod: aSelector) ifNotNil: [^temp]].
		^ nil]
]

{ #category : 'accessing' }
PrototypeObject >> methodNames [

	^self class methodNames
]

{ #category : 'accessing' }
PrototypeObject >> methodSourceAt: aSymbol [

	^self class sourceCodeAt: aSymbol
]

{ #category : 'as yet unclassified' }
PrototypeObject >> name [

	^'a Prototype Object'
]

{ #category : 'private' }
PrototypeObject >> ownClass [

	| newClass |

	self class isShared ifTrue: [

		newClass := self class cloneForModifiedObject.

		self become: (newClass basicNew slots: slots; delegates: delegates)].

	^self class
]

{ #category : 'cloning' }
PrototypeObject >> postClone [

	"instances can define something else"
]

{ #category : 'printing' }
PrototypeObject >> printOn: aStream [

	aStream nextPutAll: self name
]

{ #category : 'private' }
PrototypeObject >> privatePostClone [

	slots := slots shallowCopy.
	delegates := delegates shallowCopy
]

{ #category : 'delegation' }
PrototypeObject >> removeDelegate: aString [

	"The storage for the slot is not actually removed. This is left as an exercise for the reader"
	"NOTE by ke (2007/10/02): actually, if the storage is not removed, and we remove a delegate, 
							 subsequent calls to methods in a delegate fail for calling 
							 nil>>getCompiledMethod!!!"
	| setter getter |

	setter := (aString, ':') asSymbol.
	getter := aString asSymbol.
	self perform: setter with: nil.

	self ownClass
		removeSelector: setter;
		removeSelector: getter.

	"so let's remove nils from delegates'"
	self delegates: (delegates select: [:i | i~=nil]).

		
]

{ #category : 'slot adding/removing' }
PrototypeObject >> removeMethod: aSymbol [

	self ownClass removeSelector: aSymbol
]

{ #category : 'slot adding/removing' }
PrototypeObject >> removeSlot: aString [
	"The storage for the slot is not actually removed. This is left as an exercise for the reader"
	| setter getter |

	setter := (aString, ':') asSymbol.
	getter := aString asSymbol.

	self perform: setter with: nil.

	self ownClass
		removeSelector: setter;
		removeSelector: getter
]

{ #category : 'as yet unclassified' }
PrototypeObject >> shallowCopy [
	^ self clone
]

{ #category : 'accessing' }
PrototypeObject >> slotNames [

	^self class slotNames
]

{ #category : 'as yet unclassified' }
PrototypeObject >> slotValueAt: n [
	^self perform: n asSymbol
]

{ #category : 'private' }
PrototypeObject >> slots: anArray [

	slots := anArray
]

{ #category : 'as yet unclassified' }
PrototypeObject >> species [
	^ PrototypeObject
]
