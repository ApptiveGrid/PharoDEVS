Class {
	#name : #ImportedDirectory,
	#superclass : #MyRepository,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
ImportedDirectory >> acceptsFiles [
	
	^true
]

{ #category : #'as yet unclassified' }
ImportedDirectory >> contentsChanged [

	parent ifNotNil: [ parent contentsChanged ]
]

{ #category : #'as yet unclassified' }
ImportedDirectory >> exportTo: aFileDirectory [

	aFileDirectory assureExistence.

	(aFileDirectory directoryExists: self name asByteString)
		ifFalse: [ aFileDirectory createDirectory: self name asByteString ].

	namedComponents keysAndValuesDo: [ :filename :file |
		file exportTo: (aFileDirectory directoryNamed: self name asByteString) ]


]

{ #category : #'as yet unclassified' }
ImportedDirectory >> newMenu [
  | newMenu |
  newMenu := MenuMorph new.
  newMenu add: 'folder' target: self selector: #newFolder.
  newMenu add: 'text document' target: self selector: #newDocument.
  ^ newMenu
]
