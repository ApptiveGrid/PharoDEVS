"
PrototypeBehavior implements the behavior of PrototypeObjects. A PrototypeBehavior has simplified methods for creating and removing methods and slot accessors.

For good storage economy, PrototypeBehaviors are shared between structurally similar PrototypeObjects. When a PrototypeObject is cloned, its class is set to shared.

When a PrototypeObject changes structure (by adding/removing slots or methods) it checks to see whether its class is shared. If it is, a new PrototypeBehavior is created for this now structurally different object. This new PrototypeBehavior is owned, so further structural changes don't create new PrototypeBehaviors.

Implementation detail: Methods stored in PrototypeBehaviors are specially marked to note whether they are slot accessors or normal methods. 
"
Class {
	#name : #PrototypeBehavior,
	#superclass : #Behavior,
	#instVars : [
		'shared'
	],
	#category : #'System-Prototypes'
}

{ #category : #'instance creation' }
PrototypeBehavior >> basicNew: anInteger [

	self error: 'disallowed'
]

{ #category : #accessing }
PrototypeBehavior >> beOwned [

	shared := false
]

{ #category : #accessing }
PrototypeBehavior >> beShared [

	shared := true
]

{ #category : #'as yet unclassified' }
PrototypeBehavior >> category [
	^ String new: 0

]

{ #category : #accessing }
PrototypeBehavior >> classPool [

	^superclass classPool
]

{ #category : #accessing }
PrototypeBehavior >> cloneForModifiedObject [

	^self copy beOwned
]

{ #category : #compiling }
PrototypeBehavior >> compile: aString [

	^self
		compile: aString
		kind: #PrototypeMethod
]

{ #category : #compiling }
PrototypeBehavior >> compile: code kind: k [

	"Compile code with a specified kind of method trailer - see senders"
	
	| methodNode selector method |

	methodNode := self compilerClass new
				compile: code
				in: self
				notifying: nil
				ifFail: [:error | self error: error].

	selector := methodNode selector.
	methodNode encoder requestor: nil.  "Why was this not preserved?"
	method := methodNode generate: (CompiledMethodTrailer new data: code asString; kind: k).
	self addSelector: selector withMethod: method.

	^selector
]

{ #category : #compiling }
PrototypeBehavior >> compileDelegate: aString index: delegateIndex [

	self
		compile: aString, '^(self instVarAt: 2) at:', delegateIndex printString
		kind: #PrototypeDelegate.

	self
		compile: aString, ':obj ^(self instVarAt: 2) at:', delegateIndex printString, ' put:obj'
		kind: #PrototypeDelegateSetter.

	
]

{ #category : #compiling }
PrototypeBehavior >> compileSlot: aString index: slotIndex [

	self
		compile: aString, '^(self instVarAt: 1) at:', slotIndex printString
		kind: #PrototypeSlot.

	self
		compile: aString, ':obj ^(self instVarAt: 1) at:', slotIndex printString, ' put:obj'
		kind: #PrototypeSlotSetter.

	
]

{ #category : #accessing }
PrototypeBehavior >> delegateNames [

	^(self selectors select: [:each | (self compiledMethodAt: each) trailer kind = #PrototypeDelegate]) asSortedCollection
]

{ #category : #accessing }
PrototypeBehavior >> fromSuperclass: aSuperclass [

	format := aSuperclass format.
	superclass := aSuperclass.
	methodDict := MethodDictionary new
]

{ #category : #'as yet unclassified' }
PrototypeBehavior >> hasTraitComposition [
	^false
]

{ #category : #accessing }
PrototypeBehavior >> isShared [

	^shared == true
]

{ #category : #accessing }
PrototypeBehavior >> methodNames [

	^(self selectors select: [:each | (self compiledMethodAt: each) trailer kind = #PrototypeMethod]) asSortedCollection
]

{ #category : #'instance creation' }
PrototypeBehavior >> new [

	self error: 'disallowed'
]

{ #category : #'instance creation' }
PrototypeBehavior >> new: anInteger [

	self error: 'disallowed'
]

{ #category : #'as yet unclassified' }
PrototypeBehavior >> organization [
	| list org |
	list := OrderedCollection new.
	org := PseudoClassOrganizer defaultList: (list asArray).
	org addCategory: 'methods'.
	methodDict keys do: [:m |
		org classify: (m name) under: 'methods'.
	].
	^ org.
]

{ #category : #accessing }
PrototypeBehavior >> sharedPools [

	^superclass sharedPools
]

{ #category : #accessing }
PrototypeBehavior >> slotNames [

	^(self selectors select: [:each | (self compiledMethodAt: each) trailer kind = #PrototypeSlot]) asSortedCollection
]

{ #category : #accessing }
PrototypeBehavior >> sourceCodeAt: selector [

		^ (self methodDict at: selector) trailer data
]

{ #category : #'as yet unclassified' }
PrototypeBehavior >> theNonMetaClass [
	"Sent to a class or metaclass, always return the class"
	^self
]
