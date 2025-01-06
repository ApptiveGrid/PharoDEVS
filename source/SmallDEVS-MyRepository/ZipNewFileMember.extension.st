Extension { #name : #ZipNewFileMember }

{ #category : #'*SmallDEVS-MyRepository' }
ZipNewFileMember >> fromString: aString [
	compressionMethod := CompressionStored.
	"Now get the size, attributes, and timestamps, and see if the file exists"
	stream := ReadStream on: aString.
	compressedSize := uncompressedSize := aString size.
	desiredCompressionMethod := compressedSize > 0 ifTrue: [ CompressionDeflated ] ifFalse: [ CompressionStored ].
	self setLastModFileDateTimeFrom: Time totalSeconds

]
