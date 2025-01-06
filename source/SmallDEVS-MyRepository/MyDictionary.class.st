"
A Dictionary with correct storeOn: method and a modified copy method, that copies every element in the dictionary.
"
Class {
	#name : #MyDictionary,
	#superclass : #Dictionary,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #copying }
MyDictionary >> copy [
	| aCopy |

	aCopy:=(self class) new.
	self keysAndValuesDo: [:k :v | aCopy at: k put: (v copy).].
	^aCopy
]

{ #category : #copying }
MyDictionary >> storeOn: aStream [
	| noneYet |
	aStream nextPutAll: '('.
	aStream nextPutAll: self class name.
	aStream nextPutAll: ' new'.
	noneYet := true.
	self associationsDo: 
			[:each | 
			noneYet
				ifTrue: [noneYet := false]
				ifFalse: [aStream nextPut: $;].
			aStream nextPutAll: ' at: '.
			aStream store: (each key).
			aStream nextPutAll: ' put: '.
			aStream store: (each value).
			].
	noneYet ifFalse: [aStream nextPutAll: '; yourself'].
	aStream nextPut: $)
]
