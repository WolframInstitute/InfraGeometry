---
Template: Symbol
Name: InfraBaseSpace
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBaseSpace
Keywords: [base space, base graph, quotient, projection]
SeeAlso: [InfraFiberedGraph, InfraTotalSpace, InfraProjection, InfraBaseGraph, InfraFiber]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraBaseSpace]()[*fib*]</code> gives the graph reconstructed from the projection values and the transverse total edges of *fib*.

## Details & Options

- The base is reconstructed, not stored as an independent argument.
- Every projection value is a base vertex. Distinct values are adjacent exactly when some total edge joins their preimages.
- A vertical edge has equal projection values at its endpoints and contributes no base edge.
- Isolated projection values remain in the base. A value absent from the projection cannot be a base vertex.
- The projection is onto this reconstructed vertex set by construction.
- [InfraBaseGraph]() is the compatibility spelling.

## Basic Examples

The third projection value remains an isolated base vertex.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ Graph[ Range[ 5 ], { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 2, 3 ] } ],
    <| 1 -> "a", 2 -> "a", 3 -> "b", 4 -> "b", 5 -> "c" |> ] },
  GraphicsRow[ { InfraFiberedGraphHighlight[ fib ], InfraBaseSpace[ fib ] } ] ]
```
