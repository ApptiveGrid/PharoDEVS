"
I'm a class of auxiliary objects needed by SIXX to serialize/deserialize subinstances of PrototypeObject.

TO DO: Use SIXX custom serialization instead of this dirty hack.

"
Class {
	#name : #PrototypeObjectConstructor,
	#superclass : #Object,
	#instVars : [
		'class',
		'slots',
		'delegates',
		'methods'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
PrototypeObjectConstructor class >> for: aPrototypeObject [

	^ self new for: aPrototypeObject
]

{ #category : #'as yet unclassified' }
PrototypeObjectConstructor class >> for: aPrototypeObject without: excludedSlots [

	^ self new for: aPrototypeObject without: excludedSlots
]

{ #category : #'as yet unclassified' }
PrototypeObjectConstructor >> for: aPrototypeObject [

	self for: aPrototypeObject without: Array new.


]

{ #category : #'as yet unclassified' }
PrototypeObjectConstructor >> for: aPrototypeObject without: excludedSlots [

	class := aPrototypeObject species.
	slots := Dictionary new.
	(aPrototypeObject slotNames) do: [ :n | 
		(excludedSlots includes: n)
			ifTrue:  [ slots at: n put: nil ] 
			ifFalse: [ slots at: n put: (TemporarySymlink 
				toObject: (aPrototypeObject perform: n asSymbol) owner: self)] ].
	delegates := Dictionary new.
	(aPrototypeObject delegateNames) do: [ :n | 
		delegates at: n put: (TemporarySymlink 
			toObject: (aPrototypeObject perform: n asSymbol) owner: self) ].
	methods := Dictionary new.
	(aPrototypeObject methodNames difference: #(DoIt), excludedSlots) do: [ :n | 
		methods at: n put: (aPrototypeObject methodSourceAt: n asSymbol) ].
]

{ #category : #'as yet unclassified' }
PrototypeObjectConstructor >> sixxInitialize [
	"The method is called after the loading of the receiver"

	| s d m |
	s := slots. d := delegates. m := methods.
	self become: class new.
	s keysAndValuesDo: [ :k :v | self addSlot: k withValue: v ].
	d keysAndValuesDo: [ :k :v | self addDelegate: k withValue: v ].
	m keysAndValuesDo: [ :k :v | self addMethod: v ].


]
