Class {
	#name : #MyRepositoryWrapper,
	#superclass : #MyRepositoryListItemWrapper,
	#category : #'SmallDEVS-MyRepository-GUI'
}

{ #category : #'as yet unclassified' }
MyRepositoryWrapper >> asString [
	^ item fullName
]

{ #category : #'as yet unclassified' }
MyRepositoryWrapper >> contents [
  ^(item componentNames sorted) collect: [ :c | self class with: (item componentNamed: c)].
]
