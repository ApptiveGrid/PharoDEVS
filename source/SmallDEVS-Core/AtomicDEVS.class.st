Class {
	#name : #AtomicDEVS,
	#superclass : #BaseDEVS,
	#instVars : [
		'elapsed',
		'savedTimeAdvance'
	],
	#category : #'SmallDEVS-Core'
}

{ #category : #copying }
AtomicDEVS >> copy [

	| aCopy |
	self safelyDo: [ aCopy := super copy ].
	^ aCopy

]

{ #category : #modeling }
AtomicDEVS >> elapsed [
	^elapsed
]

{ #category : #modeling }
AtomicDEVS >> extTransition [

	self subclassResponsibility
]

{ #category : #modeling }
AtomicDEVS >> initialize [

	super initialize.
	elapsed := 0.


]

{ #category : #modeling }
AtomicDEVS >> intTransition [

	self subclassResponsibility
]

{ #category : #printing }
AtomicDEVS >> longPrintOn: aStream [
	"Prints DEVS state, i.e. only variables that are not inherited from AtomicDEVS"

	self class allInstVarNames doWithIndex: [:title :index | 
		(AtomicDEVS allInstVarNames includes: title) ifFalse: [
			aStream nextPutAll: '        ';
			 nextPutAll: title;
			 nextPut: $:;
			 space;
			 tab;
			 print: (self instVarAt: index);
		 cr]]
]

{ #category : #modeling }
AtomicDEVS >> outputFnc [

	self subclassResponsibility

]

{ #category : #modeling }
AtomicDEVS >> prepareToStart [
	"Resumes eventual processes in atomic model. It makes some sense in RT simulation."
]

{ #category : #modeling }
AtomicDEVS >> prepareToStop [
	"Suspends eventual processes in atomic model. It makes some sense in RT simulation."

]

{ #category : #simulation }
AtomicDEVS >> receiveMsgInitTime: t [

	timeLast := t - elapsed.
	savedTimeAdvance isNil ifTrue: [ savedTimeAdvance := self timeAdvance ].
	timeNext := timeLast + savedTimeAdvance.
	self assert: [ (timeNext >= t) | ((timeNext - t) closeTo: 0) ].

	self prepareToStart. 		"resume processes in atomic model"

]

{ #category : #simulation }
AtomicDEVS >> receiveMsgStarTime: t [

	self assert: [ (t - timeNext) closeTo: 0 ].

	output := Dictionary new.
	self outputFnc.

	self intTransition.
	timeLast := t.
	timeNext := timeLast + (savedTimeAdvance := self timeAdvance).
	elapsed := 0.

	verbose ifTrue: [
		self reportStream nextPutAll: '* Internal Transition: ', self printString, String cr.
		self reportStream nextPutAll: '    * New State: ', String cr, self longPrintString.
		self reportStream nextPutAll: '    * Output Port Configuration: ', String cr.
		self reportOutputPortConfig.
		self reportStream nextPutAll: '    * Next scheduled internal transition at time ', timeNext printString, String cr ].

	^ output



]

{ #category : #simulation }
AtomicDEVS >> receiveMsgSyncTime: t [

	timeLast ifNotNil: [ 
		elapsed := t - timeLast ].

	self prepareToStop.		"suspend processes in atomic models"
]

{ #category : #simulation }
AtomicDEVS >> receiveMsgX: x time: t [

	self assert: [ (timeLast <= t) & (t <= timeNext) ].

	input := x.

	elapsed := t - timeLast.
	self extTransition.

	timeLast := t.
	timeNext := timeLast + (savedTimeAdvance := self timeAdvance).
	elapsed := 0.

	verbose ifTrue: [
		self reportStream nextPutAll: '* External Transition: ', self printString, String cr.
		self reportStream nextPutAll: '    * Input Port Configuration: ', String cr.
		self reportInputPortConfig. 
		self reportStream nextPutAll: '    * New State: ', String cr, self longPrintString ].

]

{ #category : #modeling }
AtomicDEVS >> remaining [
	^ savedTimeAdvance - elapsed
]

{ #category : #private }
AtomicDEVS >> reset [

	timeLast = 0. timeNext := Float infinity.
	elapsed := 0. savedTimeAdvance := nil.
	self initModel
]

{ #category : #simulation }
AtomicDEVS >> sendMsgSETime: t [

	parent receiveMsgSETime: (timeNext := t).

]

{ #category : #'internal events' }
AtomicDEVS >> signalStateEvent [   
	self rootSolver stateEventIn: self
]

{ #category : #modeling }
AtomicDEVS >> timeAdvance [

	self subclassResponsibility

]
