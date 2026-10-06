---
Template: Symbol
Name: MetricDimension
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/MetricDimension
Keywords: [metric dimension, resolving set, metric basis, location number, radar coordinates, trees, hypercube]
SeeAlso: [FindResolvingSet, ResolvingSetQ, RadarCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[MetricDimension]()[*g*]</code> gives the metric dimension of *g*: the least number of vertices whose distances determine every vertex.

## Details & Options

Definition: the metric dimension of *g* is the least size of a resolving set, [ResolvingSetQ](): the length of a metric basis, <code>[Length]()[[First]()[[FindResolvingSet]()[*g*]]]</code>. A metric basis of *k* vertices gives every vertex its own point of ℤᵏ, its [RadarCoordinates]().

The metric dimension is 1 exactly on paths, 2 on cycles and on grids, and *n* − 1 on the complete graph with *n* vertices. On a tree that is not a path, a branch vertex, of degree 3 or more, with *k* legs ending in leaves needs a station on *k* − 1 of them, and these suffice (Slater; Harary and Melter).

The value comes from the exhaustive search of [FindResolvingSet](), which is slow when the metric dimension is large.

## Basic Examples

The metric dimension against the number of vertices: 1 on paths, 2 on cycles, *n* − 1 on the complete graphs, and 1, 2, 3, 4, 4 on the hypercubes of dimension 1 to 5.

```wl
ListLinePlot[
  {Table[{n, MetricDimension[PathGraph[Range[n]]]}, {n, 2, 32}],
   Table[{n, MetricDimension[CycleGraph[n]]}, {n, 3, 32}],
   Table[{n, MetricDimension[CompleteGraph[n]]}, {n, 2, 12}],
   Table[{2^d, MetricDimension[HypercubeGraph[d]]}, {d, 1, 5}]},
  PlotRange -> All, PlotLegends -> {"path", "cycle", "complete graph", "hypercube"}, AxesLabel -> {"vertices", "metric dimension"}]
```

A metric basis of the binary tree of depth 3, one station on a leg of each of the four branch vertices next to the leaves.

```wl
With[
  {g = KaryTree[15]},
  {InfraSubstrateHighlight[g, {First @ FindResolvingSet[g]}], MetricDimension[g]}]
```

## Scope

The square, hexagonal and triangular tilings have metric dimension 3, and so does the discretized plane.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {GraphicsRow[InfraSubstrateHighlight[#, {First @ FindResolvingSet[#]}] & /@ graphs], MetricDimension /@ graphs}]
```

## Properties and Relations

The metric dimension is the size of the first set [FindResolvingSet]() returns, and no smaller set resolves: the Petersen graph has metric dimension 3, and no two of its vertices resolve it.

```wl
With[
  {g = PetersenGraph[]},
  {InfraSubstrateHighlight[g, {First @ FindResolvingSet[g]}], MetricDimension[g], FindResolvingSet[g, 1, {MetricDimension[g] - 1}]}]
```

## Possible Issues

The one-vertex graph gets 1, though the empty set already resolves it and [ResolvingSetQ]() says so: the search starts at size 1.

```wl
With[
  {g = Graph[{1}, {}]},
  {g, MetricDimension[g], ResolvingSetQ[g, {}]}]
```
