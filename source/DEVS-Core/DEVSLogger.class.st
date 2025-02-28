Class {
	#name : 'DEVSLogger',
	#superclass : 'Object',
	#instVars : [
		'events'
	],
	#category : 'DEVS-Core-Basic',
	#package : 'DEVS-Core',
	#tag : 'Basic'
}

{ #category : 'adding' }
DEVSLogger >> addEvent: anEvent [ 
	events add: anEvent 
]

{ #category : 'initialization' }
DEVSLogger >> initialize [ 
	super initialize.
	events := OrderedCollection new
	
]

{ #category : 'as yet unclassified' }
DEVSLogger >> inspectionEvents [
	<inspectorPresentationOrder: 0 title: 'simulation events'>

	^ SpTablePresenter new
		beResizable;
		items: events;
		addColumn: (SpStringTableColumn new title: '#'; width: 35; evaluated: [:each | events indexOf: each ]);
		addColumn: (SpStringTableColumn new title: 'time'; width: 40; evaluated: [:each | each time  ]);
		addColumn: (SpStringTableColumn new title: 'event'; width: 80; evaluated: [:each | each class displayLabel ]);
		addColumn: (SpStringTableColumn new
			title: 'component';
			evaluated: [:each | each component ]);
		addColumn: (SpStringTableColumn new
			title: 'description';
			evaluated: [:each | each payload ])
]
