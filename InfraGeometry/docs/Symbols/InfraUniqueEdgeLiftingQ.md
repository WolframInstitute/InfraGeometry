---
Template: Symbol
Name: InfraUniqueEdgeLiftingQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraUniqueEdgeLiftingQ
Keywords: [unique edge lifting, perfect matching, local bijection]
SeeAlso: [InfraFibrationQ, InfraAtMostOneEdgeLiftQ, InfraCoveringQ, InfraFiberBundleQ, InfraEdgeLiftMultiplicity]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraUniqueEdgeLiftingQ]()[*fib*]</code> tests whether each total vertex has exactly one neighbour over each adjacent base vertex.

## Details & Options

- Over every base edge, the transverse edges are a perfect matching between the two whole fibers.
- The condition is the conjunction of [InfraFibrationQ]() and [InfraAtMostOneEdgeLiftQ]().
- Fiber sizes agree within each connected base component. Different components may have different sizes.
- Vertical edges are allowed. The matching need not preserve their adjacency.
- [InfraFiberBundleQ]() adds mutually isomorphic fibers and adjacency-preserving matchings. [InfraCoveringQ]() requires edgeless fibers instead.
- The empty fibered graph satisfies the condition vacuously.
- A nonempty list is tested by conjunction; an empty list gives False. Unsupported inputs remain unevaluated.

## Basic Examples

A product with a vertical edge has unique transverse lifts, but its fibers are not discrete.

```wl
SeedRandom[ 7 ];
With[ { total = GraphProduct[ CycleGraph[ 4 ], PathGraph[ { 1, 2 } ], "Cartesian" ] },
  { fib = InfraFiberedGraph[ total, First ] },
  { InfraFiberedGraphHighlight[ fib ], InfraUniqueEdgeLiftingQ[ fib ], InfraCoveringQ[ fib ] } ]
```
