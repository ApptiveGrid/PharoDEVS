Class {
	#name : #SerializablePrototypeObject,
	#superclass : #PrototypeObject,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
SerializablePrototypeObject >> excludedSlots [

	^ self slotNames select: [ :n | n asString beginsWith: 'X' ].
]

{ #category : #'as yet unclassified' }
SerializablePrototypeObject >> getMethodID: aString [

  | id tokens count |

  id:=''.
  count:=1.
  tokens:=(aString asString withSeparatorsCompacted) findTokens: #($ ).
  tokens do:
  [ :str |
	(count odd) ifTrue: [id:=id,str].
	(id at: (id size))=$: ifFalse:
	[
	  count=1 ifTrue: [^id] ifFalse: [^id copyFrom: 1 to: ((id size)-(str size))]
	].
     count:=count+1
  ].
  ^id.
]

{ #category : #'as yet unclassified' }
SerializablePrototypeObject >> privatePostClone [
	super privatePostClone.
	self excludedSlots do: [ :n | self addSlot: n withValue: nil ].
]

{ #category : #'as yet unclassified' }
SerializablePrototypeObject >> sixxOn: aStream name: nm indent: level context: dictionary [

	(PrototypeObjectConstructor for: self without: self excludedSlots) sixxOn: aStream name: nm indent: level context: dictionary
]

{ #category : #'as yet unclassified' }
SerializablePrototypeObject >> species [
	^ SerializablePrototypeObject
]
