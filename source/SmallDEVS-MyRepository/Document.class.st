"
A text document - a node of MyRepository.
"
Class {
	#name : #Document,
	#superclass : #MyRepository,
	#instVars : [
		'text'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
Document >> asHtml [

	"very simple demo (only <b> and <i>), somebody could finish the idea"

	| outData p emphasis stopemphasis endDocument beginDocument beginBold endBold beginItalics endItalics htmlEntities temp |

	htmlEntities := (Dictionary new)
		at: 'amp'	put: $&;
		at: 'lt'		put: $<;
		at: 'gt'		put: $>;
		at: 'quot'	put: $";
		at: 'euro'	put: Character euro;
		yourself.

	beginDocument := '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-2"> 
<title>', self name, '</title>
<body>'.
	endDocument := '</body>'.
	beginBold := '<b>'.
	endBold := '</b>'.
	beginItalics := '<i>'.
	endItalics := '</i>'.

	outData := WriteStream on: String new.
	p:=1.
	outData nextPutAll: beginDocument.
	text runs runsAndValuesDo: [ :rrr :att |
	 	emphasis := String new.
		stopemphasis := String new.
	  	att  do: [ :atribut |
			(atribut isKindOf: TextEmphasis) ifTrue: [
				( (atribut emphasisCode \\ 2) = 1 ) ifTrue:
				      [ emphasis := emphasis, beginBold. stopemphasis := endBold, stopemphasis ].
			 	( ((atribut emphasisCode \\ 4) // 2) = 1 ) ifTrue:
				 	[ emphasis := emphasis, beginItalics. stopemphasis := endItalics, stopemphasis ].
			].
		].
		outData nextPutAll: emphasis.

		temp := text asString copyFrom: p to: (p+rrr-1).

		htmlEntities keysAndValuesDo: [:entity :char |
			char = $& ifFalse: [temp := temp copyReplaceAll: char asString with: '&' , entity , ';']].
		temp := temp copyReplaceAll: '	' with: '	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; '.

		temp linesDo: [ :line |
			outData nextPutAll: line.
			outData nextPutAll: '<br>', String cr.
		].
	    	outData nextPutAll: stopemphasis.
		p:= p+ rrr.
	].
	outData nextPutAll: endDocument.

	^ outData contents


]

{ #category : #'as yet unclassified' }
Document >> contents [

	^ self text asString
]

{ #category : #'as yet unclassified' }
Document >> editorMenu: aMenu shifted: shifted [

	^aMenu
"	labels: 
'LaTeX' 
	lines: #()
	selections: #(latexCompileAndView)
"

]

{ #category : #'as yet unclassified' }
Document >> exportTo: aFileDirectory [

	| fs |
	aFileDirectory assureExistence.
	fs := (aFileDirectory forceNewFileNamed: self name asByteString).
	fs nextPutAll: (CrLfFileStream new convertStringFromCr: (self contents convertToWithConverter: TextConverter defaultSystemConverter) asByteArray).
	fs close.

]

{ #category : #'as yet unclassified' }
Document >> fileOutAction [

	| fileStream |

	fileStream := (StandardFileMenu newFileStreamFrom: FileDirectory default ).
	fileStream ifNil: [^ nil].

	fileStream store: self.
	fileStream close.
]

{ #category : #'as yet unclassified' }
Document >> fullName [

	"^ self name, ' [text]'"
	^ self name
]

{ #category : #'as yet unclassified' }
Document >> getMenu [
	| m |
	m := super getMenu.
	m addTitle: 'Document'.
	^ m
]

{ #category : #'as yet unclassified' }
Document >> isFolder [
	^ false
]

{ #category : #'as yet unclassified' }
Document >> newMenu [
	^nil
]

{ #category : #'as yet unclassified' }
Document >> open [

	| window editor |
	window := SystemWindow labelled: name asString.
	window model: self.
	editor := PluggableTextMorph on: self text: #text accept: #text: readSelection: nil menu: #editorMenu:shifted:.
	window addMorph: editor frame: (0@0 extent: 1@1).
	"window submorphsDo: [:m | m color: Color lightMagenta]."
	window openInWorldExtent: 400@200.
	

]

{ #category : #'as yet unclassified' }
Document >> perform: selector orSendTo: otherTarget [
	"Selector was just chosen from a menu by a user.  If can respond, then
perform it on myself. If not, send it to otherTarget, presumably the
editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ otherTarget perform: selector]
]

{ #category : #'as yet unclassified' }
Document >> saveAsHtml [

	| fileStream |
	fileStream := (StandardFileMenu newFileStreamFrom: FileDirectory default ).
	fileStream ifNil: [^ nil].

	fileStream nextPutAll: self asHtml.
	fileStream close.

]

{ #category : #'as yet unclassified' }
Document >> storeOn: aStream [

	"Text is filed out/in using #nextChunkPutWithStyle: and #nextChunkText."
	"It would be better to define Text>>storeString this way and rely on inherited #storeOn: here."

	aStream nextPut: $(.
	aStream nextPutAll: self class name, ' new '.
	aStream nextPutAll: 'name: ', name storeString, '; '.

	"text"	
	aStream nextPutAll: 'text: (ReadStream on: '.
	aStream store: ((ReadWriteStream on: String new) nextChunkPutWithStyle: text) contents.
	aStream nextPutAll: ') nextChunkText ;', String cr.

	"components (subclasses may need it)"
	aStream nextPutAll: 'addComponents: {'; nextPutAll: String cr.
	namedComponents keysAndValuesDo: [ :k :v |
		aStream store: k; nextPutAll: ' -> '; store: v; nextPut: $.; nextPutAll: String cr ].
	aStream nextPutAll: '};'; nextPutAll: String cr.

	aStream nextPutAll: ' yourself)'; nextPutAll: String cr

]

{ #category : #accessing }
Document >> text [

	^ text
]

{ #category : #accessing }
Document >> text: anObject [

	text := anObject.
	parent ifNotNil: [ parent contentsChanged ].
	^ true

]

{ #category : #'as yet unclassified' }
Document >> windowReqNewLabel: labelString [
	"My window's title has been edited.
	Return true if this is OK, and override for further behavior."

 	^ self renameTo: labelString


]
