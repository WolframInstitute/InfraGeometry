---
Template: Symbol
Name: InfraCoveringQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraCoveringQ
Keywords: [graph covering, discrete fiber, unique edge lifting]
SeeAlso: [InfraUniqueEdgeLiftingQ, InfraFiberBundleQ, InfraEqualFiberSizesQ, InfraHolonomy]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraCoveringQ]()[*fib*]</code> tests whether *fib* has unique edge lifting and edgeless fibers.

## Details & Options

- The projection gives a bijection from the total neighbours of each vertex onto the neighbours of its base vertex.
- The number of sheets is constant on each connected base component. It may differ between disconnected components.
- A covering over a connected base is a graph bundle with a discrete fiber. On a disconnected base, [InfraFiberBundleQ]() additionally requires the same fiber size across components.
- Nontrivial monodromy is allowed. A connected double cover of a cycle is a covering.
- The empty fibered graph satisfies the condition vacuously.
- A nonempty list is tested by conjunction; an empty list gives False. Unsupported inputs remain unevaluated.

## Basic Examples

The hexagon covers the triangle with two sheets.

```wl
SeedRandom[ 7 ];
With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], vertex |-> Mod[ vertex, 3, 1 ] ] },
  { InfraFiberedGraphHighlight[ fib ], InfraCoveringQ[ fib ] } ]
```
