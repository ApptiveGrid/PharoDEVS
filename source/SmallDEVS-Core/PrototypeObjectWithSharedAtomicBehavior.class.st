"
Used in AtomicDEVSPrototype>>initialize for its nested prototype object creation. Several methods are added to PrototypeObject.


"
Class {
	#name : 'PrototypeObjectWithSharedAtomicBehavior',
	#superclass : 'Object',
	#category : 'SmallDEVS-Core-Prototypes',
	#package : 'SmallDEVS-Core',
	#tag : 'Prototypes'
}

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> elapsed [  
	^ self atomic elapsed
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> name [
	^ self atomic name
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> name: n [  
	^ self atomic name: n
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> parent [  
	^ self atomic parent
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> parent: p [  
	^ self atomic parent: p
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> peekFrom: port [   
	^ self atomic peekFrom: port
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> poke: value to: port [   
	self atomic poke: value to: port
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> remaining [
	^ self atomic remaining
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> signalStateEvent [   
	self atomic rootSolver stateEventIn: self atomic
]

{ #category : 'atomic devs shared behavior' }
PrototypeObjectWithSharedAtomicBehavior >> species [
	^ PrototypeObjectWithSharedAtomicBehavior
]
