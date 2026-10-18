---
Template: Symbol
Name: InfraTotalGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTotalGraph
Keywords: [compatibility, fibered graph, InfraTotalSpace]
SeeAlso: [InfraTotalSpace, InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraTotalGraph]()[*fib*]</code> gives the total graph of *fib* using the compatibility spelling.

## Details & Options

- Use [InfraTotalSpace]() for new code.
- Supported inputs and results are the same as for [InfraTotalSpace]().
- Both canonical [InfraFiberedGraph]() and legacy [InfraFibration]() literals are supported.
- Unsupported graph domains remain unevaluated. Like [InfraTotalSpace](), this reader does not validate the projection.

## Basic Examples

The compatibility reader accepts a canonical fibered graph.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  InfraTotalGraph[ fib ] ]
```
