Extension { #name : #Array }

{ #category : #'*SmallDEVS-MyRepository' }
Array >> storeOn: aStream [ 
	"Use the literal form if possible."

	self isLiteral
		ifTrue: 
			[aStream nextPut: $(; nextPut: $#; nextPut: $(.
			self do: 
				[:element | 
				element printOn: aStream.
				aStream space].
			aStream nextPutAll: ') copy)']	"Copy is necessary here when the storestring is used as part of a method code."
		ifFalse: [super storeOn: aStream]
]
