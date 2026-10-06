---
Template: Symbol
Name: FindResolvingSet
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindResolvingSet
Keywords: [resolving set, metric basis, metric dimension, radar coordinates, landmarks, exhaustive search]
SeeAlso: [ResolvingSetQ, MetricDimension, RadarCoordinates]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindResolvingSet]()[*g*]</code> gives a list holding one smallest resolving set of *g*, a metric basis.

<code>[FindResolvingSet]()[*g*, *n*]</code> gives up to *n* resolving sets, the smallest first.

<code>[FindResolvingSet]()[*g*, *n*, *m*]</code> takes the sizes of the sets from *m*: [All](), a largest size *k*, {*min*, *max*}, or {*k*} for the size *k* only.

## Details & Options

Definition: a set *B* of vertices resolves *g* when every vertex is determined by its distances to the vertices of *B*, [ResolvingSetQ](). A smallest resolving set is a metric basis, and its size is the [MetricDimension]().

The search is exhaustive. It tries every set of each size in turn, from the smallest size on, and stops once it holds *n* sets. A metric basis of *k* vertices out of *N* is found after at most (*N* choose *k*) tests at the size *k*, so the search is fast when the metric dimension is small, and slow otherwise.

After the sets of the smallest size come larger ones, and those may contain smaller resolving sets. When no set of the sizes *m* resolves *g*, the result is {}.

## Basic Examples

A metric basis of the square, hexagonal and triangular tilings: three corners.

```wl
With[
  {graphs = InfraSubstrate[#, "Small", "KeepCoordinates" -> True] & /@ {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}},
  {bases = First @ FindResolvingSet[#] & /@ graphs},
  {GraphicsRow[MapThread[InfraSubstrateHighlight[#1, {#2}] &, {graphs, bases}]], bases}]
```

A metric basis of a path, a cycle, a grid and the Petersen graph: one end, two neighbours, two corners of one side and three vertices.

```wl
With[
  {graphs = {PathGraph[Range[6]], CycleGraph[8], GridGraph[{4, 4}], PetersenGraph[]}},
  {bases = First @ FindResolvingSet[#] & /@ graphs},
  {GraphicsRow[MapThread[InfraSubstrateHighlight[#1, {#2}] &, {graphs, bases}]], Length /@ bases}]
```

## Scope

Up to *n* sets: the 6-cycle has twelve metric bases, every pair of vertices except the three opposite pairs.

```wl
With[
  {g = CycleGraph[6]},
  {bases = FindResolvingSet[g, 20, {2}]},
  {GraphicsGrid[Partition[InfraSubstrateHighlight[g, {#}] & /@ bases, 4]], Length[bases]}]
```

The sizes: no two vertices resolve the square tiling, and 728 sets of three do. Three of them, chosen at random, are drawn.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {pairs = FindResolvingSet[g, 1000, {2}], triples = FindResolvingSet[g, 1000, {3}]},
  {GraphicsRow[InfraSubstrateHighlight[g, {#}] & /@ (SeedRandom[1]; RandomSample[triples, 3])], Length[pairs], Length[triples]}]
```

## Properties and Relations

Every set found resolves the graph, and the first has [MetricDimension]() vertices.

```wl
With[
  {g = PetersenGraph[]},
  {bases = FindResolvingSet[g, 6]},
  {GraphicsRow[InfraSubstrateHighlight[g, {#}] & /@ bases],
   AllTrue[bases, ResolvingSetQ[g, #] &], Length[First[bases]] == MetricDimension[g]}]
```

## Possible Issues

Past the smallest size the sets need not be minimal. On a path the third set found, {4, 5}, contains the resolving set {5}.

```wl
With[
  {g = PathGraph[Range[5]]},
  {sets = FindResolvingSet[g, 3]},
  {GraphicsRow[InfraSubstrateHighlight[g, {#}] & /@ sets], sets}]
```
