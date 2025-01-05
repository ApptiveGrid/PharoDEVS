"
Used in CoupledDEVSPrototype>>initialize for its nested prototype object creation. Several methods are added to PrototypeObject.

"
Class {
	#name : #PrototypeObjectWithSharedCoupledBehavior,
	#superclass : #Object,
	#category : #'SmallDEVS-Core-Prototypes'
}

{ #category : #'coupled devs shared behavior' }
PrototypeObjectWithSharedCoupledBehavior >> name [
	^ self devs name
]

{ #category : #'coupled devs shared behavior' }
PrototypeObjectWithSharedCoupledBehavior >> name: n [  
	^ self devs name: n
]

{ #category : #'coupled devs shared behavior' }
PrototypeObjectWithSharedCoupledBehavior >> parent [  
	^ self devs parent
]

{ #category : #'coupled devs shared behavior' }
PrototypeObjectWithSharedCoupledBehavior >> parent: p [  
	^ self devs parent: p
]

{ #category : #'coupled devs shared behavior' }
PrototypeObjectWithSharedCoupledBehavior >> species [
	^ PrototypeObjectWithSharedCoupledBehavior

]
