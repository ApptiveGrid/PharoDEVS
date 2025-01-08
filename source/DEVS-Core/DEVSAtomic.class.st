Class {
	#name : 'DEVSAtomic',
	#superclass : 'DEVSModel',
	#instVars : [
		'elapsed',
		'savedTimeAdvance'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'as yet unclassified' }
DEVSAtomic class >> displayLabel [ 
	^ #atomic
]

{ #category : 'modeling' }
DEVSAtomic >> elapsed [
	^ elapsed
]

{ #category : 'modeling' }
DEVSAtomic >> externalTransition [

	self subclassResponsibility
]

{ #category : 'modeling' }
DEVSAtomic >> initialize [

	super initialize.
	elapsed := 0.


]

{ #category : 'modeling' }
DEVSAtomic >> internalTransition [

	self subclassResponsibility
]

{ #category : 'modeling' }
DEVSAtomic >> outputFunction [

	self subclassResponsibility

]

{ #category : 'modeling' }
DEVSAtomic >> prepareToStart [
	"Resumes eventual processes in atomic model. It makes some sense in RT simulation."
]

{ #category : 'modeling' }
DEVSAtomic >> prepareToStop [
	"Suspends eventual processes in atomic model. It makes some sense in RT simulation."

]

{ #category : 'simulation' }
DEVSAtomic >> receiveMsgInitTime: time [

	timeLast := time - elapsed.
	savedTimeAdvance isNil ifTrue: [ savedTimeAdvance := self timeAdvance ].
	timeNext := timeLast + savedTimeAdvance.
	self assert: [ (timeNext >= time) | ((timeNext - time) closeTo: 0) ].

	self prepareToStart. 		"resume processes in atomic model"

]

{ #category : 'simulation' }
DEVSAtomic >> receiveMsgStarTime: time [

	self assert: [ (time - timeNext) closeTo: 0 ].

	output := Dictionary new.
	self outputFunction.

	self internalTransition.
	timeLast := time.
	timeNext := timeLast + (savedTimeAdvance := self timeAdvance).
	elapsed := 0.

	verbose ifTrue: [
		self reportStream nextPutAll: '* Internal Transition: ', self printString, String cr.
		self reportStream nextPutAll: '    * New State: ', self printString, String cr.
		self reportStream nextPutAll: '    * Output Port Configuration: ', String cr.
		self reportOutputPortConfig.
		self reportStream nextPutAll: '    * Next scheduled internal transition at time ', timeNext printString, String cr ].

	^ output



]

{ #category : 'simulation' }
DEVSAtomic >> receiveMsgSyncTime: time [

	timeLast ifNotNil: [ 
		elapsed := time - timeLast ].

	self prepareToStop.		"suspend processes in atomic models"
]

{ #category : 'simulation' }
DEVSAtomic >> receiveMsgX: message time: time [

	self assert: [ (timeLast <= time) & (time <= timeNext) ].

	input := message.

	elapsed := time - timeLast.
	self externalTransition.

	timeLast := time.
	timeNext := timeLast + (savedTimeAdvance := self timeAdvance).
	elapsed := 0.

	verbose ifTrue: [
		self reportStream nextPutAll: '* External Transition: ', self printString, String cr.
		self reportStream nextPutAll: '    * Input Port Configuration: ', String cr.
		self reportInputPortConfig. 
		self reportStream nextPutAll: '    * New State: ', self printString, String cr ].

]

{ #category : 'modeling' }
DEVSAtomic >> remaining [
	^ savedTimeAdvance - elapsed
]

{ #category : 'private' }
DEVSAtomic >> reset [

	timeLast = 0. timeNext := Float infinity.
	elapsed := 0. savedTimeAdvance := nil.
	self initializeModel
]

{ #category : 'simulation' }
DEVSAtomic >> sendMsgSETime: time [

	parent receiveMsgSETime: (timeNext := time).

]

{ #category : 'internal events' }
DEVSAtomic >> signalStateEvent [   
	self rootSolver stateEventIn: self
]

{ #category : 'modeling' }
DEVSAtomic >> timeAdvance [

	self subclassResponsibility

]
