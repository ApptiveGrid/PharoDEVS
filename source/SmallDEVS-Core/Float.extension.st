Extension { #name : 'Float' }

{ #category : '*SmallDEVS-Core' }
Float >> storeOn: aStream [

	self = Infinity
		ifTrue: [ aStream nextPutAll: '(Float infinity)' ] 
		ifFalse: [ super storeOn: aStream ]
]
