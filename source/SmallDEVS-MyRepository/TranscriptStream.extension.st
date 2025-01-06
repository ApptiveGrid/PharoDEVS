Extension { #name : #TranscriptStream }

{ #category : #'*SmallDEVS-MyRepository' }
TranscriptStream >> nextPutAll: aCollection [
	self semaphore critical: [ super nextPutAll: aCollection ]. 
	^aCollection
]
