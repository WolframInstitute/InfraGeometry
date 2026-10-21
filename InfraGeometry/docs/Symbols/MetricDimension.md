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

The metric dimension is *dim(g) = min |B|* over the resolving sets *B* of *g*, [ResolvingSetQ](). A smallest resolving set is a metric basis, found by [FindResolvingSet](). A basis of *k* vertices gives every vertex its own point of *ℤᵏ*, its [RadarCoordinates]().

Known values:

| Graph | Metric dimension |
|---|---|
| one vertex | 0 |
| path | 1, and only paths have 1 |
| cycle, grid graph *m × n* | 2 |
| complete graph *Kₙ* | *n − 1* |
| hypercube of dimension 1, …, 5 | 1, 2, 3, 4, 4 |

On a tree that is not a path, a vertex of degree at least 3 with *k* legs ending in leaves needs a vertex on *k − 1* of them, and these suffice (Slater; Harary and Melter).

Two vertices at the same distance from every other vertex are twins. A resolving set contains one of every two twins.

The value comes from an exhaustive search over the vertex sets of increasing size, which is slow when the metric dimension is large.

## Basic Examples

A metric basis of the 8 × 8 grid graph, two corners of one side, and of the square mesh:

```wl
GraphicsRow @ Table[
  InfraSubstrateHighlight[g, {First @ FindResolvingSet[g]}, PlotLabel -> MetricDimension[g]],
  {g, {GridGraph[{8, 8}], InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}}]
```

The metric dimension against the number of vertices: 1 on paths, 2 on cycles, *n − 1* on complete graphs, and 1, 2, 3, 4, 4 on the hypercubes:

```wl
ListLinePlot[
  {Table[{n, MetricDimension[PathGraph[Range[n]]]}, {n, 2, 32}],
   Table[{n, MetricDimension[CycleGraph[n]]}, {n, 3, 32}],
   Table[{n, MetricDimension[CompleteGraph[n]]}, {n, 2, 12}],
   Table[{2^d, MetricDimension[HypercubeGraph[d]]}, {d, 5}]},
  PlotMarkers -> Automatic, PlotLegends -> {"path", "cycle", "complete graph", "hypercube"}]
```

## Scope

On the binary tree of depth 3 each of the four vertices above the leaves has two legs and needs a vertex on one of them:

```wl
With[{g = KaryTree[15]},
  InfraSubstrateHighlight[g, {First @ FindResolvingSet[g]}, PlotLabel -> MetricDimension[g], ImageSize -> Medium]]
```

The square grid has metric dimension 4, not 2: its rim vertices are leaves, and the two leaves at each corner are twins. One leaf of each pair resolves the graph:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {leaves = Pick[VertexList[g], VertexDegree[g], 1]},
  {twins = Select[Subsets[leaves, {2}], pair |-> AllTrue[Complement[VertexList[g], pair],
    w |-> GraphDistance[g, pair[[1]], w] == GraphDistance[g, pair[[2]], w]]]},
  InfraSubstrateHighlight[g, {Catenate[twins], First /@ twins},
    PlotLabel -> ResolvingSetQ[g, First /@ twins], ImageSize -> Medium]]
```

## Properties and Relations

The Petersen graph has metric dimension 3, and no two of its vertices resolve it:

```wl
With[{g = PetersenGraph[]},
  {MetricDimension[g], FindResolvingSet[g, 1, {2}], Select[Subsets[VertexList[g], {2}], ResolvingSetQ[g, #] &]}]
```

The one-vertex graph has metric dimension 0: the empty set resolves it.

```wl
With[{g = Graph[{1}, {}]}, {MetricDimension[g], ResolvingSetQ[g, {}]}]
```
