# PharoDEVS
An Pharo based implementation of [Discrete Event System Specification](https://en.wikipedia.org/wiki/DEVS) - formalism for modelling and simulation by B. Ziegler.

## Loading project
Install [Pharo latest stable version](https://pharo.org/download) e.g. from command line:  
`wget -O- https://get.pharo.org/64 | bash` 

Run in Pharo Playground:
```
Metacello new
 baseline: 'PharoDEVS';
 repository: 'github://ApptiveGrid/PharoDEVS:main/src';
 load
```

## Running examples
TODO

## History
Current implementation is Pharo port and continuation of original [SmallDEVS library](http://perchta.fit.vutbr.cz:8000/projekty/10) implemented in Squeak 4.3 at [Department of Intelligent Systems on FIT BUT](https://www.fit.vut.cz/units/uits/staff/.en) (namely doc. Ing. Vladimír Janoušek Ph.D., Ing. Elöd Kironský).

## Overview of changes  
This is list of changes compared to original SmallDEVS implementation:
- removed all squeak and repository/proto object code
- cleaned core and made class prefixes etc. consistent
- removed all SIXX and storage dependencies
- added a project baseline
- initial unit tests added, fixed bugs/inconsistencies 
- added github actions to run tests on commits
- added a simple traffic system simulation that enabled me to understand
- removed all Transcript based logging and introduced events 
- inspector extension for a simulation logger can be used to have a decent log of everything happened

## TODOs and next steps, open questions
- separate roles of solver, model and coordinator 
- clarify DEVSnDESS code that is there
- parallel stuff looks too naive and needs improvement
- Bloc based UI? 

---
# Key Differences between DES and DEVS
- **DES** is more straightforward and is widely used for simpler systems where events are the primary drivers of change.  
- **DEVS** is a more rigorous and flexible framework, suitable for complex systems requiring modularity and hierarchical organization.  

**DES (Discrete Event Simulation)** and **DEVS (Discrete Event System Specification)** are both approaches to modeling and simulation, but they have different focuses and structures:  


| Aspect              | DES                                           | DEVS                                       |
|---------------------|----------------------------------------------|---------------------------------------------|
| **Focus**           | Event scheduling and processing.              | Modular, hierarchical system specification. |
| **Time Management** | Event-driven (time jumps between events).     | Event-driven with explicit time advance functions. |
| **Modeling Approach** | Informal, system-specific implementations.  | Formal, mathematical framework.             |
| **Structure**       | Flat, centralized event list.                 | Hierarchical composition of atomic and coupled models. |
| **Reusability**     | Limited modularity, typically system-specific.| High modularity and reusability.             |
| **Applications**    | Queueing, logistics, manufacturing systems.   | Complex, hierarchical systems like distributed simulations. |


## Discrete Event Simulation (DES)  
- **Concept:**  
  - DES is a simulation approach where the state of the system changes only at specific points in time, triggered by events.  
  - Time advances by jumping from one event to the next (event-driven).  
- **Characteristics:**  
  - Events are instantaneous and cause state transitions.  
  - Typically used to model queueing systems, manufacturing processes, and other systems where changes occur at discrete points (e.g., arrival of a customer, completion of a task).  
  - Often implemented using event lists, where events are processed chronologically.  
- **Example Applications:**  
  - Customer service systems (banks, call centers).  
  - Production lines in factories.  
  - Computer network packet transfers.  

---

## DEVS (Discrete Event System Specification)
- **Concept:**  
  - DEVS is a formal modeling framework for discrete event systems, developed by Bernard Zeigler.  
  - It provides a modular and hierarchical way to specify systems using a well-defined mathematical structure.  
- **Characteristics:**  
  - Consists of two main types of models:
    - **Atomic Models:** The basic building blocks defining state variables, inputs, outputs, internal and external transitions, and time advances.  
    - **Coupled Models:** Compositions of multiple atomic and/or coupled models, defining how they interact.  
  - Supports modularity and reusability, making it easier to build complex systems from simpler components.  
  - Formalism allows rigorous analysis, validation, and verification of the models.  
- **Example Applications:**  
  - Complex system simulations, such as transportation systems, military simulations, and distributed systems.  
  - Hierarchical and modular systems, e.g., smart cities, IoT systems.  
