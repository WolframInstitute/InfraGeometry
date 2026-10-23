---
Template: Symbol
Name: InfraFiberBundleQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFiberBundleQ
Keywords: [fiber bundle, graph bundle, Cartesian graph bundle, isomorphic fibers, covering, twist, predicate]
SeeAlso: [InfraFiberedGraph, InfraIsomorphicFibersQ, InfraUniqueEdgeLiftingQ, InfraCoveringQ, InfraFlatConnectionQ, InfraHolonomy, InfraFibers]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFiberBundleQ]()[*fib*]</code> gives `True` if *fib* is a fiber bundle: its fibers are copies of one graph, and over every base edge the transverse edges match the two fibers by a graph isomorphism.

## Details & Options

The conditions are:

| Condition | Test |
|---|---|
| all fibers isomorphic to one graph *F* | [InfraIsomorphicFibersQ]() |
| at every vertex over *p*, exactly one lift of each base edge *pq* | [InfraUniqueEdgeLiftingQ]() |
| the matching *F(p) → F(q)* maps the edges of *F(p)* onto the edges of *F(q)* | |

Over each base edge the bundle is then a product: the part over *pq* is the Cartesian product of the edge with *F*.

The product need not be global. Composing the matchings around a base cycle gives a permutation of a fiber, the holonomy, which [InfraHolonomy]() computes; it can be nontrivial. The prism and the Moebius ladder are both bundles over a cycle with fiber an edge.

A bundle with fibers without edges is a covering ([InfraCoveringQ]()). A covering whose base components carry different numbers of sheets is not a bundle, since its fibers are not all isomorphic.

The empty fibered graph is a bundle. A list of objects gives `True` when every member is a bundle; the empty list gives `False`.

## Basic Examples

The prism and the Moebius ladder over the cycle of length 8. Both are bundles with an edge as fiber. They differ only by a twist over one base edge, which [InfraHolonomy]() detects:

```wl
GraphicsRow @ Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]},
    InfraFiberedGraphHighlight[fib, PlotLabel -> InfraFiberBundleQ[fib]]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

A random double covering of the square grid, drawn over the grid. Where two edges cross, the sheets are exchanged:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, Properties -> {"FiberBundle"},
    RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, "BaseVertexCoordinates" -> GraphEmbedding[g],
    PlotLabel -> InfraFiberBundleQ[fib], ImageSize -> Medium]]
```

## Scope

The products and the coverings of the catalogue are bundles, the branched fibrations are not:

```wl
Table[name -> InfraFiberBundleQ @ InfraFiberedSubstrate[name, "Small"],
  {name, Join @@ Lookup[InfraFiberedSubstrate[], {"Trivial", "Covering", "NonBundle"}]}]
```

## Properties and Relations

Isomorphic fibers and unique lifting are not enough. Here the fiber is a path *a − b − c*, and the matching sends *a, b, c* to *a, c, b*, which breaks the edge *ab*:

```wl
With[{fib = InfraFiberedGraph[Graph[{
    {"p", "a"} <-> {"p", "b"}, {"p", "b"} <-> {"p", "c"}, {"q", "a"} <-> {"q", "b"}, {"q", "b"} <-> {"q", "c"},
    {"p", "a"} <-> {"q", "a"}, {"p", "b"} <-> {"q", "c"}, {"p", "c"} <-> {"q", "b"}}], First]},
  InfraFiberedGraphHighlight[fib, ImageSize -> Medium,
    PlotLabel -> {InfraIsomorphicFibersQ[fib], InfraUniqueEdgeLiftingQ[fib], InfraFiberBundleQ[fib]}]]
```

## Possible Issues

The displacement bundles are fibrations but not bundles. Over the grid the fibers differ in size; over the triangular torus they agree, but a base edge has several lifts at a vertex:

```wl
Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]},
    name -> {InfraEqualFiberSizesQ[fib], InfraUniqueEdgeLiftingQ[fib], InfraFiberBundleQ[fib]}],
  {name, {"GridDisplacementBundle", "TriangularTorusDisplacementBundle"}}]
```
