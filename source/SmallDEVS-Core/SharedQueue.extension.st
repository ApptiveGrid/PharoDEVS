Extension { #name : 'SharedQueue' }

{ #category : '*SmallDEVS-Core' }
SharedQueue >> getContentsOrNilAndFlush [

	| r |
	accessProtect critical: [
		r := readPosition < writePosition 
			ifTrue: [ contentsArray copyFrom: readPosition to: writePosition - 1 ]
			ifFalse: [ nil ].
		readPosition := 1.
		writePosition := 1.
		"Reset the read synchronization semaphore"
		readSynch initSignals	].
	^r
]

{ #category : '*SmallDEVS-Core' }
SharedQueue >> nextPutAll: aCollection [
	"slow. todo: make it faster"

	^ aCollection do: [:each | self nextPut: each]
]
