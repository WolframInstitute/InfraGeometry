---
Template: Symbol
Name: InfraTotalSpace
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTotalSpace
Keywords: [total space, total graph, fibered graph]
SeeAlso: [InfraFiberedGraph, InfraBaseSpace, InfraProjection, InfraTotalGraph, InfraFiberedGraphHighlight]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraTotalSpace]()[*fib*]</code> gives the total graph of the fibered graph *fib*.

## Details & Options

- For a supported literal [InfraFiberedGraph]() or legacy [InfraFibration](), the result is its first argument.
- This reader extracts the supported total graph without validating its projection. [InfraFiberedGraphQ]() checks the whole literal object.
- For an Experimental construction, the total graph is computed from the model. Materializing it with [InfraFiberedGraph]() avoids repeating that construction.
- Structural evaluation performs no embedding. [InfraFiberedGraphHighlight]() arranges a drawing over the reconstructed base.
- [InfraTotalGraph]() is the compatibility spelling.

## Basic Examples

The total graph and the reconstructed base of a double covering.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ] },
  GraphicsRow[ { InfraTotalSpace[ fib ], InfraBaseSpace[ fib ] } ] ]
```
