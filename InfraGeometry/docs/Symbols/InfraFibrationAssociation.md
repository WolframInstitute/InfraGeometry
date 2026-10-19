---
Template: Symbol
Name: InfraFibrationAssociation
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFibrationAssociation
Keywords: [compatibility, fibered graph, InfraProjection]
SeeAlso: [InfraProjection, InfraFiberedGraph, InfraTotalSpace, InfraBaseSpace]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFibrationAssociation]()[*fib*]</code> gives the projection association of *fib* using the compatibility spelling.

## Details & Options

- Use [InfraProjection]() for new code.
- Supported inputs and results are the same as for [InfraProjection]().
- Both canonical [InfraFiberedGraph]() and legacy [InfraFibration]() literals are supported.
- Unsupported graph domains and malformed projections remain unevaluated.

## Basic Examples

The compatibility reader accepts a canonical fibered graph.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  InfraFibrationAssociation[ fib ] ]
```
