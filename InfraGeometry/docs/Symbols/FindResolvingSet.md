---
Template: Symbol
Name: FindResolvingSet
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindResolvingSet
Keywords: [resolving set, metric basis, metric dimension, radar coordinates, landmarks, twins, exhaustive search]
SeeAlso: [ResolvingSetQ, MetricDimension, RadarCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindResolvingSet]()[*g*]</code> gives a list holding one smallest resolving set of *g*, a metric basis.

<code>[FindResolvingSet]()[*g*, *n*]</code> gives up to *n* resolving sets in order of size, the smallest first.

<code>[FindResolvingSet]()[*g*, *n*, *m*]</code> takes the sizes of the sets from *m*: [All](), a largest size *k*, {*min*, *max*}, or {*k*} for the size *k* only.

## Details & Options

A set *B* of vertices resolves *g* when every vertex is determined by its distances to the vertices of *B* ([ResolvingSetQ]()). A smallest resolving set is a metric basis, and its size is the [MetricDimension]().

The search is exhaustive. It tests every set of each size in turn, from the empty set on, and stops when it holds *n* sets. A metric basis of *k* vertices out of *N* costs up to *C(N, k)* tests at the size *k*: fast when the metric dimension is small, slow otherwise.

Two vertices with the same neighbours, twins, have the same distance to every other vertex. A resolving set holds one of every pair of twins.

The sets of the smallest size are metric bases; later ones need not be minimal. The empty set resolves only the graph of one vertex. When no set of the sizes *m* resolves *g*, the result is {}.

## Basic Examples

A metric basis of the square mesh, three vertices:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {basis = First @ FindResolvingSet[g]},
  InfraSubstrateHighlight[g, {basis}, PlotLabel -> basis, ImageSize -> Medium]]
```

A metric basis of the 8 × 8 grid graph: two corners of one side. Every vertex is determined by its distances to two corners:

```wl
With[{g = GridGraph[{8, 8}]}, {basis = First @ FindResolvingSet[g]},
  InfraSubstrateHighlight[g, {basis}, PlotLabel -> basis, ImageSize -> Medium]]
```

## Scope

Up to *n* sets of a given size. The 6-cycle has 12 metric bases, every pair of vertices but the three opposite pairs:

```wl
With[{g = CycleGraph[6]}, {bases = FindResolvingSet[g, 20, {2}]},
  {Length[bases], Complement[Subsets[Range[6], {2}], Sort /@ bases]}]
```

The empty set resolves the graph of one vertex and comes first. On two vertices one vertex resolves, and the empty set does not:

```wl
FindResolvingSet[#, 3] & /@ {Graph[{1}, {}], PathGraph[{1, 2}]}
```

## Properties and Relations

Every set found resolves the graph, and the first has [MetricDimension]() vertices. The Petersen graph:

```wl
With[{g = PetersenGraph[]}, {bases = FindResolvingSet[g, 6]},
  {AllTrue[bases, ResolvingSetQ[g, #] &], Length[First @ bases] == MetricDimension[g]}]
```

## Possible Issues

Twins raise the metric dimension. The square grid substrate is the 8 × 8 grid with a pendant vertex at both ends of every row and column, so two pendant vertices hang from each corner. No three vertices resolve it, while one vertex from each of the four pairs of twins does:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {leaves = Select[VertexList[g], VertexDegree[g, #] == 1 &]},
  {twins = Select[Subsets[leaves, {2}], AdjacencyList[g, First[#]] == AdjacencyList[g, Last[#]] &]},
  InfraSubstrateHighlight[g, twins, PlotLabel -> {FindResolvingSet[g, 1, 3], ResolvingSetQ[g, First /@ twins]},
    ImageSize -> Medium]]
```

Past the smallest size the sets need not be minimal. On a path the third set found, {4, 5}, contains the resolving set {5}:

```wl
FindResolvingSet[PathGraph[Range[5]], 3]
```
