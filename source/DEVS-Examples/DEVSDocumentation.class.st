"
Description:
	SmallDEVS - A multiparadigm simulation framework based on DEVS formalism. 
Author:
	Vladimir Janousek
Contributors:
	Elod Kironsky (SmallDEVS-GUI,  ...)
Comment:
	SmallDEVS is a new and experimental implementation of B. Zeigler's DEVS (Discrete event systems specification) formalism, partially inspired by PythonDEVS. It is an experimental software.  Its main purpose is experimenting with model editing during runtime as well as prototype-based model construction. A long-term target of this experiment is to prove usability of that approach for model-based and simulation-based development. SmallDEVS is suitable for education and research. Usage in production is also potentially possible, but it would need some additions and improvements which are outside the original author's focus.

What is DEVS? 
DEVS is a systems-theoretic approach to modeling. More specifically, it is state-centered formalism. A system consists of interconnected subsystems. A subsystem is a system. Leaf systems (atomic DEVSes) are state machines. Such a view on systems structure seems to be static - DEVS in its original form does not consider evolution of the structure. Only states of the state machines can evolve. Nevertheles, several DEVS modificactions allow for structural changes. But in fact, DEVS seems to be more usable for mostly static structure systems modeling. Dynamic parts of the system is obviously better to encapsulate in atomic DEVSes where the subsystems dynamicity is modeled as a state evolution. Inside an atomic DEVS, arbitray formalism or programming language can be used. This way, the DEVS can be viewed as a framework unifiyng a number of other formalisms in a consistent, systems theoretic, state centered fashion.

References:
	- Bernard P. Zeigler, Herbert Praehofer, Tag Gon Kim: ""Theory of Modeling and Simulation. Integrating Discrete Event and Continuous Complex Dynamic Systems"". Second Edition. Acadedemic Press, 2000
	- Python DEVS					http://moncs.cs.mcgill.ca/MSDL/research/projects/DEVS/
	- DEVS implementations 			http://www.sce.carleton.ca/faculty/wainer/standard/tools.htm

Design Notes:
	- Each (sub)model has its own simulator which is inherited from appropriate superclass. Models (together with their simulators) are hierarchically organized. Leafs of the tree are atomic models/simulators. Others are coupled models/coordinators. Top level model/simulator is controlled by a root-solver.
	- Numeric (continuous) simulation support is implemented by subclasses of discrete DEVS (in future, this could be better implemented using mixins or traits). Note that the additional ""N"" in the middle of the appropriate message or class names means they are ""numeric"" counterparts the discrete ones. 
	- Numeric and discrete coordinators of DEV&DESS are glued together in one class - as oposed to Praehofer's STIMS-CLOS design, where numeric clusters are organized independently on discrete coordinators hierarchy.

Examples of DEVS models (for details see appropriate methods on the class side):
	DEVSDocumentation discreteDemo.		""You can watch the simulation in Transcript.""
	DEVSDocumentation continuousDemo.		""Depends on PlotMorph from SqueakMap.""
	DEVSDocumentation realtimeDemo.		""Simulation is synchronized with real time.""
	DEVSDocumentation dynamicDemo.		""Model modifies its structure during simulation.""
	DEVSDocumentation classlessDemo.		""Depends on Prototypes package.""
	DEVSDocumentation multisimulationDemo.	""Several simualtions in a simulation space.""

Current release and future development notes:
	- Classless approach is preferred now. Thus the model example classes in the SmallDEVS-Core-Examples category are going to be obsoleted. The preferred way how to model is demonstrated in SmallDEVS-Examples category.
	- AtomicDEVnDESSPrototype is not implemented yet. So the classless approach is usable only for discrete event simulations now.
	- Simulations are organized hierarchically in MyRepository structure. Multisimulation and nested simulations are interesting topic of future research and experiments. An example is  DEVSDocumentation>>multisimulationDemo.	
	- RT simulators are preferred. Virtual time simulations take place when rtFactor is set to 0.

To do:
	- Documentation, tutorial ...	 
	- SUnit tests
	- AtomicDEVnDESSPrototype - implement using Traits (?)
	- Visualization: Oscilloscopes etc. 
	- Tools for interactive simulations: Potentiometer, Trigger, ... 
	- Adaptive integration method
	- Parallel & Distributed simulation
	- Interoperability with Scilab etc.
	- Soft computing components

"
Class {
	#name : 'DEVSDocumentation',
	#superclass : 'Object',
	#category : 'DEVS-Examples-original',
	#package : 'DEVS-Examples',
	#tag : 'original'
}

{ #category : 'demo' }
DEVSDocumentation class >> continuousDemo [

	"Van Der Pol system specified as atomic model, 
	 one of outputs trigger discrete events (when zero is crossed)"
	DEVSMyContinuousBlock newSimulator simulate: 20.

	"MyContinuousBlock with a plotter connected to it."
	DEVSMyContinuousSystem newSimulator simulate: 20.

	"Van Der Pol system specified as a coupling of integrators and a function"
	DEVSMyContinuousSystem2 newSimulator simulate: 20.


	"Bouncing ball"
	DEVSMyContinuousSystem1 newSimulator simulate: 5


]

{ #category : 'demo' }
DEVSDocumentation class >> discreteDemo [

	"Generator generates jobs of random size, cascade of processors with queues process the jobs."
	DEVSMySystem newSimulator simulate: 100.

	"dtto, one processor, another way of coupled model specification"
	DEVSMySystem2 newSimulator simulate: 100.


]

{ #category : 'demo' }
DEVSDocumentation class >> realtimeDemo [

	| s |
"	[ s := MySystem3 getSimulatorRT. s simulate: 20. ] forkAt: Processor timingPriority.
	(Delay forSeconds: 10) wait.
	s inject: #aaaa to: #in.
"
	[ s := DEVSMySystem3b newSimulatorRT. s simulate: 20. ] forkAt: Processor timingPriority.

]
