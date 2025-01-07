"
Waiting for real time value. How to use:

	| t aTime |
	aTime := Time millisecondClockValue + 10000.
	t := Timer at: aTime.
	t wait.

	""waiting can be stopped by t unschedule""




"
Class {
	#name : 'Timer',
	#superclass : 'Delay',
	#category : 'DEVS-Core-RT',
	#package : 'DEVS-Core',
	#tag : 'RT'
}

{ #category : 'as yet unclassified' }
Timer class >> at: time [

	^ (self new setDelay: 0 forSemaphore: Semaphore new) scheduleResumptionTime: time
]

{ #category : 'as yet unclassified' }
Timer >> scheduleEventResumptionTime: t [
	"Schedule this delay"
	resumptionTime := t.
	AccessProtect critical:[
		ScheduledDelay := self.
		TimingSemaphore signal.
	].
]

{ #category : 'as yet unclassified' }
Timer >> scheduleResumptionTime: t [

	"This code is taken from Delay>>schedule and slightly modified."

	beingWaitedOn ifTrue: [self error: 'This Delay has already been scheduled.'].
	TimerEventLoop ifNotNil:[^self scheduleEventResumptionTime: t].
	AccessProtect critical: [
		beingWaitedOn := true.
		resumptionTime := t.           "Here is the difference from Delay>>schedule."
		ActiveDelay == nil
			ifTrue: [self activate]
			ifFalse: [
				resumptionTime < ActiveDelay resumptionTime
					ifTrue: [
						SuspendedDelays add: ActiveDelay.
						self activate]
					ifFalse: [SuspendedDelays add: self]]].

]

{ #category : 'as yet unclassified' }
Timer >> unschedule [

	super unschedule.
	delaySemaphore signal.

]

{ #category : 'as yet unclassified' }
Timer >> wait [

	delaySemaphore wait.

]
