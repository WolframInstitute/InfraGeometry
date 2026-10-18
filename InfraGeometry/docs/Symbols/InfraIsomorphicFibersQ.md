---
Template: Symbol
Name: InfraIsomorphicFibersQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraIsomorphicFibersQ
Keywords: [isomorphic fibers, common fiber graph, predicate]
SeeAlso: [InfraEqualFiberSizesQ, InfraFiberBundleQ, InfraFibers, RandomInfraFiberedGraph]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraIsomorphicFibersQ]()[*fib*]</code> tests whether the induced fiber graphs of *fib* are mutually isomorphic.

## Details & Options

- The comparison includes every fiber, including fibers over different connected base components.
- Isomorphism is a property of the vertical fiber graphs. It imposes no lifting condition on transverse edges.
- [InfraFiberBundleQ]() also requires unique transverse matchings that preserve fiber adjacency.
- The empty fibered graph satisfies the condition vacuously.
- A nonempty list is tested by conjunction; an empty list gives False. Unsupported inputs remain unevaluated.

## Basic Examples

All fibers share a graph, while one transverse edge per base edge need not cover the whole fiber.

```wl
SeedRandom[ 7 ];
With[ { fib = RandomInfraFiberedGraph[ CycleGraph[ 4 ], Properties -> { "IsomorphicFibers" },
    "VerticalVertexCount" -> { 4 }, "VerticalEdgeCount" -> { 3 }, "HorizontalEdgeCount" -> { 1 } ] },
  InfraFiberedGraphHighlight[ fib ] ]
```
