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

<code>[InfraUniqueEdgeLiftingQ]()[*fib*]</code> gives [True]() if every total vertex has exactly one neighbour over each base neighbour of its base vertex, and [False]() otherwise.

<code>[InfraUniqueEdgeLiftingQ]()[{*fib₁*, *fib₂*, …}]</code> gives [True]() if every *fibᵢ* has unique edge lifting.

## Details & Options

The condition is: for every total vertex *x* over *p* and every base edge *pq* there is exactly one total edge *xy* with *y* over *q*. Equivalently, over every base edge *pq* the transverse edges are a perfect matching between the fibers *Fₚ* and *F_q*.

It is the conjunction of [InfraFibrationQ]() (at least one lift) and [InfraAtMostOneEdgeLiftQ]() (at most one lift). Then every base walk has exactly one lift from each start, as for a covering map.

Neighbouring fibers have equal size, so the fiber size is constant on each connected component of the base. Different components may have different sizes.

Vertical edges are allowed, and the matchings need not preserve them. [InfraCoveringQ]() asks for no vertical edges, [InfraFiberBundleQ]() for isomorphic fibers and matchings that preserve the fiber edges.

The empty fibered graph has unique edge lifting. An empty list gives [False]().

## Basic Examples

A random double covering of the 4 × 4 grid has unique edge lifting. A random fibered graph with fibers of the same size does not:

```wl
GraphicsRow @ Table[
  With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], Properties -> props, "VerticalVertexCount" -> {2},
      RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, PlotLabel -> InfraUniqueEdgeLiftingQ[fib]]],
  {props, {{"Covering"}, {}}}]
```

The number of neighbours of a total vertex over a base neighbour is always 1 for the covering, and 0, 1 or 2 for the random fibered graph:

```wl
Table[
  With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}], Properties -> props, "VerticalVertexCount" -> {2},
      RandomSeeding -> 1]},
    Counts @ Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]]],
  {props, {{"Covering"}, {}}}]
```

## Scope

Vertical edges are allowed. The product of the grid with an edge has unique edge lifting and is a fiber bundle, but not a covering:

```wl
With[{fib = InfraFiberedGraph[GraphProduct[GridGraph[{4, 4}], PathGraph[{1, 2}], "Cartesian"], First]},
  {InfraUniqueEdgeLiftingQ[fib], InfraFiberBundleQ[fib], InfraCoveringQ[fib]}]
```

## Properties and Relations

The fiber size is constant on each component of the base. Two copies of a square, with fibers of 2 or 3 vertices:

```wl
With[{fib = RandomInfraFiberedGraph[GraphDisjointUnion[GridGraph[{2, 2}], GridGraph[{2, 2}]],
    Properties -> {"UniqueEdgeLifting"}, "VerticalVertexCount" -> {2, 3}, RandomSeeding -> 2]},
  {InfraUniqueEdgeLiftingQ[fib], VertexCount /@ InfraFibers[fib]}]
```

Unique edge lifting is lift existence together with lift uniqueness:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{4, 4}],
    Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {InfraFibrationQ[fib], InfraAtMostOneEdgeLiftQ[fib], InfraUniqueEdgeLiftingQ[fib]}]
```

The tangent bundle of the grid is a fibration without unique edge lifting: a ray has several neighbours over a base edge:

```wl
With[{fib = InfraTangentBundle[GridGraph[{4, 4}], 2]},
  {InfraFibrationQ[fib], InfraUniqueEdgeLiftingQ[fib]}]
```
