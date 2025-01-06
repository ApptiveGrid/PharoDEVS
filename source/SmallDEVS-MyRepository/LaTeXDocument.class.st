"
Only a simple demo of how it could work. Requires Unix/Linux with LaTeX, xpdf, wmctrl and SM packages OSProcess, CommandShell. When a LaTeX source is saved, LaTeX compiler is invoked and viewer opened. Eps figures or other files can be attached (menu -> import). All sources are stored in image, host OS files are used only temporarily.

If something does not work properly, remove the temporary directories /tmp/LatexDocumentTMP*.




"
Class {
	#name : #LaTeXDocument,
	#superclass : #Document,
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
LaTeXDocument >> acceptsFiles [
	
	^true
]

{ #category : #'as yet unclassified' }
LaTeXDocument >> contentsChanged [

	self latexCompileAndView
]

{ #category : #'as yet unclassified' }
LaTeXDocument >> editorMenu: aMenu shifted: shifted [

	^aMenu
	labels: 
'LaTeX' 
	lines: #()
	selections: #(latexCompileAndView)


]

{ #category : #'as yet unclassified' }
LaTeXDocument >> exportTo: aFileDirectory [

	| fs |
	aFileDirectory assureExistence.
	fs := aFileDirectory forceNewFileNamed: self name asByteString, '.tex'.
	fs nextPutAll: (CrLfFileStream new convertStringFromCr: (text asString convertToWithConverter: TextConverter defaultSystemConverter) asByteArray). 
	fs close.
	namedComponents keysAndValuesDo: [ :filename :fileOrDirectory |
		fileOrDirectory exportTo: aFileDirectory ].

]

{ #category : #'as yet unclassified' }
LaTeXDocument >> fullName [

	^ self name, ' [LaTeX]'
]

{ #category : #'as yet unclassified' }
LaTeXDocument >> isFolder [

	^true
]

{ #category : #'as yet unclassified' }
LaTeXDocument >> latexCompileAndView [
	"Requires UNIX, LaTeX, xpdf, wmctrl. Log goes to Transcript."

	| latexCommand viewCommand viewerStartCommand viewerTestCommand |

	self exportTo: (FileDirectory on: ('/tmp/LaTeXDocumentTMP.DOCUMENT/' copyReplaceTokens: 'DOCUMENT' with: self name asByteString)).

	latexCommand := 'rm -f /tmp/LaTeXDocumentTMP.DOCUMENT/DOCUMENT.log /tmp/LaTeXDocumentTMP.DOCUMENT/DOCUMENT.dvi /tmp/LaTeXDocumentTMP.DOCUMENT/DOCUMENT.ps /tmp/LaTeXDocumentTMP.DOCUMENT/DOCUMENT.pdf ; ',
		'cd /tmp/LaTeXDocumentTMP.DOCUMENT ; ',
	"	'recode utf8..latin2 DOCUMENT.tex ; ',	"
		'latex --interaction=nonstopmode DOCUMENT.tex ; ',	
		'dvips -Ppdf -q DOCUMENT.dvi -o DOCUMENT.ps ; ',
		'ps2pdf DOCUMENT.ps DOCUMENT.pdf'.
	latexCommand := latexCommand copyReplaceTokens: 'DOCUMENT' with: self name asByteString.

	viewerStartCommand := 'xpdf -remote .DOCUMENT. /tmp/LaTeXDocumentTMP.DOCUMENT/DOCUMENT.pdf'.
	viewerStartCommand := viewerStartCommand copyReplaceTokens: 'DOCUMENT' with: self name asByteString.
	viewCommand := 'wmctrl -a DOCUMENT; xpdf -remote .DOCUMENT. -reload'.
	viewCommand := viewCommand copyReplaceTokens: 'DOCUMENT' with: self name asByteString.

"
	viewerStartCommand := 'xdvi /tmp/TeXTMP.dvi'.
	viewCommand := 'wmctrl -a TeXTMP; killall -SIGUSR1 xdvi.bin'.
"
	viewerTestCommand := 'wmctrl -l | grep DOCUMENT'.
	viewerTestCommand := viewerTestCommand copyReplaceTokens: 'DOCUMENT' with: self name asByteString.

	Transcript show: (PipeableOSProcess command: latexCommand) output asString withSqueakLineEndings.
	(PipeableOSProcess command: viewerTestCommand) output size > 0 ifTrue: [
		OSProcess command: viewCommand ]
	ifFalse: [
		OSProcess command: viewerStartCommand ].

	"see also TeXTMP.log"



]

{ #category : #'as yet unclassified' }
LaTeXDocument >> text: anObject [

	text := anObject.
	self latexCompileAndView.
	^ true
]
