---
Template: Symbol
Name: InfraFibration
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibration
Keywords: [compatibility, fibered graph, InfraFiberedGraph]
SeeAlso: [InfraFiberedGraph, InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibration]()[*total*, *projection*]</code> is the legacy inert head for a fibered graph.

<code>[InfraFibration]()[*model*]</code> materializes an Experimental construction in the legacy representation.

## Details & Options

- Use [InfraFiberedGraph]() for new code. Both literal heads are accepted by the structural readers, predicates, sections, connections and drawing functions.
- The legacy name imposes no edge-lifting condition. [InfraFibrationQ]() separately tests lift existence.
- [InfraTotalSpace](), [InfraBaseSpace]() and [InfraProjection]() are the canonical readers.
- Existing literal expressions remain inert. The supported graph and projection domain is the same as for [InfraFiberedGraph]().

## Basic Examples

The legacy object still has the same double-covering structure.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFibration[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  InfraFiberedGraphHighlight[ fib, { InfraFiber[ fib, 1 ] } ] ]
```
