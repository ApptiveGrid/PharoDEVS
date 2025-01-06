"
This special inspector serves as a user interface for PrototypeObjects. It displays slots and methods in an intuitive way. Note that it does not work very well in the Morphic environment.
"
Class {
	#name : #PrototypeInspector,
	#superclass : #Object,
	#category : #'System-Prototypes'
}

{ #category : #'as yet unclassified' }
PrototypeInspector >> accept: aString [
	| slotName selector result |

	slotName := self selectedSlotName.

	((object methodNames includes: slotName) or: [slotName = self methodsHeading])
		ifTrue: [
			selector := object addMethod: aString.
			selector = slotName ifFalse: [
				self changed: #fieldList.
				self toggleIndex: (self fieldList indexOf: selector)]
			ifTrue: [ self update ].
			^true].

	((object slotNames includes: slotName) or: [slotName = self slotsHeading])
		ifTrue: [
			result := self doItReceiver class evaluatorClass new
				evaluate: (ReadStream on: aString)
				in: self doItContext
				to: self doItReceiver
				notifying: nil	"fix this"
				ifFail:  [^ false].

			result == #failedDoit ifFalse: 
				[contents := result printString.
				self replaceSelectionValue: result.	"may put contents back"
				self changed: #contents.
			^ true]].
	^false
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> contentsForSlotName: slotName [

	slotName = 'self' ifTrue: [^object printString].

	slotName = self slotsHeading
		ifTrue: [^'Enter slot value to create a new slot'].

	slotName = self delegatesHeading
		ifTrue: [^'List of delegates to this object'].

	slotName = self methodsHeading
		ifTrue: [^'method

	"New method in Smalltalk syntax. Remember to access slots via message sends!"' asText makeSelectorBoldIn: object class].

	(object methodNames includes: slotName)
		ifTrue: [^(object methodSourceAt: slotName) asText makeSelectorBoldIn: object class].

	^(object perform: slotName) printString
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> contentsIsString [
	"Hacked so contents empty when deselected and = long printString when item 2"
	| slotName |

	selectionIndex = 0 ifTrue: [^true].

	slotName := self selectedSlotName.

	^ (object methodNames includes: slotName) | (self methodsHeading = slotName) | (self slotsHeading = slotName)
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> delegatesHeading [

	^'--- delegates ---' asText allBold
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> fieldList [

	^OrderedCollection new
		add: 'self';
		add: self slotsHeading;
		addAll: object slotNames;
		add: self delegatesHeading;
		addAll: object delegateNames;
		add: self methodsHeading;
		addAll: object methodNames;
		yourself
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> fieldListMenu: aMenu [

	^ aMenu labels: 'inspect
inspect references
clone
remove slot/method
update
'
	lines: #(3 4)
	selections: #(inspectSelection objectReferencesToSelection inspectClone  removeSlot updateFieldList).


]

{ #category : #'as yet unclassified' }
PrototypeInspector >> inspectClone [

	^self selection clone inspect
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> methodsHeading [

	^'--- methods ---' asText allBold
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> removeSlot [
	| slotName |

	slotName := self selectedSlotName.

	(object slotNames includes: slotName)
		ifTrue: [object removeSlot: slotName]
		ifFalse: [(object methodNames includes: slotName)
					ifTrue: [object removeMethod: slotName]].

	selectionIndex := 0.
	self changed: #fieldList
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> replaceSelectionValue: anObject [ 
	| slotName |

	slotName := self selectedSlotName.

	(object slotNames includes: slotName)
		ifTrue: [object perform: (slotName, ':') asSymbol with: anObject]
		ifFalse: [
			slotName := UIManager default request: 'Name of slot to store into (empty to ignore)?'.
			slotName isEmpty ifFalse: [
				object addSlot: slotName withValue: anObject.
				self changed: #fieldList.
				self toggleIndex: (self fieldList indexOf: slotName asSymbol)]]
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> selectedSlotName [

	selectionIndex = 0 ifTrue: [^nil].

	^self fieldList atPin: selectionIndex
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> selection [
	| slotName |

	selectionIndex = 0 ifTrue: [^nil].
	selectionIndex = 1 ifTrue: [^object].
	slotName := self selectedSlotName.
	slotName = self slotsHeading
		ifTrue: [^'Enter slot value to create a new slot'].

	slotName = self delegatesHeading
		ifTrue: [^'List of delegates to this object'].

	slotName = self methodsHeading
		ifTrue: [^'method

	"New method in Smalltalk syntax. Remember to access slots via message sends!"' asText makeSelectorBoldIn: object class].

	(object methodNames includes: slotName)
		ifTrue: [^(object methodSourceAt: slotName) asText makeSelectorBoldIn: object class].

	^object perform: slotName
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	aPluggableShoutMorphOrView classOrMetaClass: Object.  
	^ (object methodNames includes: self selectedSlotName)
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> slotsHeading [

	^'--- slots ---' asText allBold
]

{ #category : #'as yet unclassified' }
PrototypeInspector >> updateFieldList [
	| slotName |

	slotName := self selectedSlotName.
	selectionIndex := 0.
	self changed: #fieldList.
	self toggleIndex: (self fieldList indexOf: slotName)
]
