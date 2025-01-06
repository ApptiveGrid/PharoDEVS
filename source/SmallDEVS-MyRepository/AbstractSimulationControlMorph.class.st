"
aSimulation openSimControl


"
Class {
	#name : #AbstractSimulationControlMorph,
	#superclass : #MenuMorph,
	#instVars : [
		'model'
	],
	#category : #'SmallDEVS-MyRepository'
}

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph class >> on: aSimulation [

	^ self new on: aSimulation

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph class >> openOn: aSimulation [

	^ self new openOn: aSimulation

]

{ #category : #menu }
AbstractSimulationControlMorph >> addSubMenuUpdating: wordingSelector enablementSelector: enablementSelector target: target subMenu: aMenuMorph [

	| item |
	item := UpdatingMenuItemMorph new
		target: target;
		subMenu: aMenuMorph;
		wordingProvider: target wordingSelector: wordingSelector;
		enablementSelector: enablementSelector.
	self addMorphBack: item.
	^ item

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> getModelMenu [

	^ model model getMenu
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> logWording [
	^'Log: ', model reportStream className.

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> modelWording [
	^ 'Model: ', model name asString.
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> on: aSimulation [

	| logMenu simulationMenu |
	model := aSimulation.

	logMenu:=MenuMorph new.
	logMenu add: ' - ' target: self selector: #setReportStream: argument: (DummyStream on: nil).
	logMenu add: 'Transcript' target: self selector: #setReportStream: argument: Transcript.
	logMenu add: 'File' target: self selector: #setReportStreamToFile.

	simulationMenu:=MenuMorph new.
	simulationMenu title: 'Simulation menu'.
  	simulationMenu add: 'copy simulation' target: model selector: #copyAction.
  	simulationMenu add: 'cut simulation' target: model selector: #cutAction.
  	simulationMenu add: 'delete simulation' target: model selector: #remove.
  	simulationMenu add: 'rename simulation' target: model selector: #renameAction.
   	(model isKindOf: DEVSRootSolver) ifTrue: [ 
		simulationMenu add: 'paste root DEVS' target: model selector: #pasteRootDEVS ].
	simulationMenu addLine.
  	simulationMenu add: 'make SAR' target: model selector: #makeSAR.
	simulationMenu addLine.
  	simulationMenu add: 'open simulation control buttons' target: self selector: #openSimControlButtons.
	simulationMenu addLine.
	simulationMenu add: 'inspect simulation' target: model action: #inspect.

	self title: 'Simulation'.
	self addStayUpItem.
	self defaultTarget: self.

	self addSubMenuUpdating: #modelWording enablementSelector: #true target: self subMenu: self getModelMenu.
	self add: 'Simulation' subMenu: simulationMenu target: self selector: #yourself argumentList: #().
	self addLine.
	self addUpdating: #startWording enablement: #startEnabled action: #start.
	self addUpdating: #stopWording enablement: #stopEnabled action: #stop.
	self addLine.
	self add: 'Do One Step' target: aSimulation selector: #doOneStep.
	self addLine.
	self addUpdating: #resetWording enablement: #true action: #reset.
	self addLine.
	self addUpdating: #rtFactorWording enablement: #true action: #setRTFactor.
	self addUpdating: #stopTimeWording enablement: #true action: #setStopTime.
	self addSubMenuUpdating: #logWording enablementSelector: #true target: self subMenu: logMenu.

	^self

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> openModel [
	model openModel
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> openOn: aSimulation [

	self on: aSimulation.
	self stayUp: true.
	self openInHand
	"self popUpInWorld"


]

{ #category : #buttons }
AbstractSimulationControlMorph >> openSimControlButtons [
	(SimControlMorph withSolver: model) openInHand
]

{ #category : #'buttons  in window alternatice' }
AbstractSimulationControlMorph >> openWindowOn: aSimulation [
	"Experimental alternative to SimControlMorph. Not finished yet. Probably will be replaced by next version of SimControlMorph because it is better to separate model and gui."

	| win buttons b time buttons2 |

	model := aSimulation.

	win := SystemWindow labelled: model name asString.
	win model: model.

	buttons := AlignmentMorph new.

	b := PluggableButtonMorph on: self getState: nil action: #start.
	b label: 'Start/Continue'.
	b color: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons addMorphBack: b.

	b := PluggableButtonMorph on: self getState: nil action: #stop.
	b label: 'Stop'.
	b color: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons addMorphBack: b.

	b := PluggableButtonMorph on: self getState: nil action: #reset.
	b label: 'Reset'.
	b color: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons addMorphBack: b.

	b := PluggableButtonMorph on: self getState: nil action: #setRTFactor label: #rtFactorWording.
	b onColor: Color transparent offColor: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons addMorphBack: b.

	b := PluggableButtonMorph on: self getState: nil action: #setStopTime label: #stopTimeWording.
	b onColor: Color transparent offColor: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons addMorphBack: b.

	buttons2 := AlignmentMorph new.

	b := PluggableButtonMorph on: self getState: nil action: #openModel.
	b label: 'Model'.
	b color: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons2 addMorph: b.

	b := PluggableButtonMorph on: self getState: nil action: #setLog label: #logWording.
	b onColor: Color transparent offColor: Color transparent.
	b feedbackColor: Color black.
	b setProperty: #cornerStyle toValue: #rounded.
	buttons2 addMorph: b.

	self changed: #rtFactorWording.
	self changed: #StopTimeWording.

	time := SimTimeMorph withModel: (model rootDEVS).
	time extent: 100@10.
	time updateOnce.
	buttons2 addMorph: time.

	win addMorph: buttons frame: (0@0 extent: 1@0.5).
	win addMorph: buttons2 frame: (0@0.5 extent: 1@0.5).
	win openInWorldExtent: 350@50.

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> reset [
	(UIManager default confirm: 'State information of all model components will be lost! Reset anyway?')
		ifTrue: [ model asyncReset ].

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> resetWording [
	| t |
	t :=  model timeToShow < Float infinity
		ifTrue: [ (model timeToShow printShowingDecimalPlaces: 2) ]
		ifFalse: [ 'Infinity' ].
	^'Reset Simulation (time: ', t , ')'

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> rtFactorWording [
  ^'RT Factor: ',(model rtFactor asString)

]

{ #category : #'buttons  in window alternatice' }
AbstractSimulationControlMorph >> setLog [
	| logMenu |
	logMenu:=MenuMorph new.
	logMenu add: ' - ' target: self selector: #setReportStream: argument: (DummyStream on: nil).
	logMenu add: 'Transcript' target: self selector: #setReportStream: argument: Transcript.
	logMenu add: 'File' target: self selector: #setReportStreamToFile.
	logMenu popUpInWorld

]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> setRTFactor [

  | str |
  str := UIManager default request: 'new RT factor' initialAnswer: (model rtFactor asString).
  str= '' ifFalse: [
  	model asyncRtFactor: (str asNumber asFloat).
	self changed: #rtFactorWording ].
  
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> setReportStream: aStream [
	aStream ifNotNil: [
		model asyncReportStream: aStream.
		self changed: #logWording ].
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> setReportStreamToFile [
	| fileStream |
	fileStream:=(StandardFileMenu newFileStreamFrom: FileDirectory default ).
	fileStream ifNotNil: [self setReportStream: fileStream].
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> setStopTime [

	| str |
	str := UIManager default request: 'new stoptime' initialAnswer: (model stopTime asString).
	str = '' ifFalse: [ 
		model asyncStopTime: ([str asNumber] on: Error do: [Float infinity]).
		self changed: #stopTimeWording ].
  
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> start [
	model asyncStart.
	self changed: #startWording
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> startEnabled [
	^ model isRunning not
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> startWording [
	^'Start Simulation'
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> stop [
	model asyncStop.
	self changed: #stopWording
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> stopEnabled [
	^model isRunning
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> stopTimeWording [
	^'Stop Time: ', model stopTime asString
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> stopWording [
	^'Stop Simulation'
]

{ #category : #'as yet unclassified' }
AbstractSimulationControlMorph >> true [
	^true
]
