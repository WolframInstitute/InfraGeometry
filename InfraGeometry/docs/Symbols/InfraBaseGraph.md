---
Template: Symbol
Name: InfraBaseGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBaseGraph
Keywords: [compatibility, fibered graph, InfraBaseSpace]
SeeAlso: [InfraBaseSpace, InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace, InfraProjection]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraBaseGraph]()[*fib*]</code> gives the reconstructed base graph of *fib* using the compatibility spelling.

## Details & Options

- Use [InfraBaseSpace]() for new code.
- Supported inputs and results are the same as for [InfraBaseSpace]().
- Both canonical [InfraFiberedGraph]() and legacy [InfraFibration]() literals are supported.
- Unsupported graph domains and malformed projections remain unevaluated.

## Basic Examples

The compatibility reader accepts a canonical fibered graph.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  InfraBaseGraph[ fib ] ]
```
