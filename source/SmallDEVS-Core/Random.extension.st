Extension { #name : 'Random' }

{ #category : '*SmallDEVS-Core' }
Random >> = anObject [

	^ anObject class = self class and: [ seed = anObject seed ]
]
