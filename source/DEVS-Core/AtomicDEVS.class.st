Class {
	#name : 'AtomicDEVS',
	#superclass : 'BasicDEVS',
	#instVars : [
		'elapsed',
		'savedTimeAdvance'
	],
	#category : 'DEVS-Core',
	#package : 'DEVS-Core'
}

{ #category : 'modeling' }
AtomicDEVS >> elapsed [
	^ elapsed
]

{ #category : 'modeling' }
AtomicDEVS >> externalTransition [

	self subclassResponsibility
]

{ #category : 'modeling' }
AtomicDEVS >> initialize [

	super initialize.
	elapsed := 0.


]

{ #category : 'modeling' }
AtomicDEVS >> internalTransition [

	self subclassResponsibility
]

{ #category : 'modeling' }
AtomicDEVS >> outputFunction [

	self subclassResponsibility

]

{ #category : 'modeling' }
AtomicDEVS >> prepareToStart [
	"Resumes eventual processes in atomic model. It makes some sense in RT simulation."
]

{ #category : 'modeling' }
AtomicDEVS >> prepareToStop [
	"Suspends eventual processes in atomic model. It makes some sense in RT simulation."

]

{ #category : 'simulation' }
AtomicDEVS >> receiveMsgInitTime: time [

	timeLast := time - elapsed.
	savedTimeAdvance isNil ifTrue: [ savedTimeAdvance := self timeAdvance ].
	timeNext := timeLast + savedTimeAdvance.
	self assert: [ (timeNext >= time) | ((timeNext - time) closeTo: 0) ].

	self prepareToStart. 		"resume processes in atomic model"

]

{ #category : 'simulation' }
AtomicDEVS >> receiveMsgStarTime: time [

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
AtomicDEVS >> receiveMsgSyncTime: time [

	timeLast ifNotNil: [ 
		elapsed := time - timeLast ].

	self prepareToStop.		"suspend processes in atomic models"
]

{ #category : 'simulation' }
AtomicDEVS >> receiveMsgX: message time: time [

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
AtomicDEVS >> remaining [
	^ savedTimeAdvance - elapsed
]

{ #category : 'private' }
AtomicDEVS >> reset [

	timeLast = 0. timeNext := Float infinity.
	elapsed := 0. savedTimeAdvance := nil.
	self initModel
]

{ #category : 'simulation' }
AtomicDEVS >> sendMsgSETime: time [

	parent receiveMsgSETime: (timeNext := time).

]

{ #category : 'internal events' }
AtomicDEVS >> signalStateEvent [   
	self rootSolver stateEventIn: self
]

{ #category : 'modeling' }
AtomicDEVS >> timeAdvance [

	self subclassResponsibility

]
