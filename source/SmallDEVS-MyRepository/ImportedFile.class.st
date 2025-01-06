"
Imported file. Needed by LaTeX document. May contain arbitrary string (byte array) such as eps figure, style etc.

To do:
	open a viewer/editor according to file type.


"
Class {
	#name : #ImportedFile,
	#superclass : #MyRepository,
	#instVars : [
		'contents'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
ImportedFile class >> contents: aByteArrayOrString [

	^ self new contents: aByteArrayOrString 
]

{ #category : #'as yet unclassified' }
ImportedFile >> contents [

	^ contents 
]

{ #category : #'as yet unclassified' }
ImportedFile >> contents: aByteArrayOrString [

	contents := aByteArrayOrString 
]

{ #category : #'as yet unclassified' }
ImportedFile >> exportTo: aFileDirectory [

	| fs |
	aFileDirectory assureExistence.
	fs := (aFileDirectory forceNewFileNamed: self name asByteString).
	fs binary.
	fs nextPutAll: self contents.
	fs close.

]

{ #category : #'as yet unclassified' }
ImportedFile >> fullName [

	^ self name, ' [import]'
]

{ #category : #'as yet unclassified' }
ImportedFile >> isFolder [

	^false
]
