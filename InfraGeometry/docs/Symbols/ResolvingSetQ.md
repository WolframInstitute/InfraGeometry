---
Template: Symbol
Name: ResolvingSetQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ResolvingSetQ
Keywords: [resolving set, metric basis, metric dimension, radar coordinates, landmarks, locating set]
SeeAlso: [RadarCoordinates, FindResolvingSet, MetricDimension]
RelatedGuides: [Experimental]
---

## Usage

<code>[ResolvingSetQ]()[*g*, {*b1*, …, *bk*}]</code> tests whether every vertex of *g* is determined by its distances to the vertices *b1*, …, *bk*.

## Details & Options

A list *B = (b₁, …, bₖ)* of vertices resolves *g* when the map *v ↦ (d(v, b₁), …, d(v, bₖ))* is injective on the vertices of *g*: for every two vertices *u ≠ v* some *bᵢ* has *d(u, bᵢ) ≠ d(v, bᵢ)*. The map is [RadarCoordinates]().

A list that contains a resolving set resolves. A smallest resolving set is a metric basis, found by [FindResolvingSet](); its size is the [MetricDimension]().

Two vertices at the same distance from every other vertex are twins, and only a list that contains one of them can tell them apart.

The basis must consist of vertices. [RadarCoordinates]() also accepts sets of vertices as stations.

## Basic Examples

Two vertices at distance 4 from the centre do not resolve the square grid or the square mesh. The vertices that share their distances with another vertex are drawn in red:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {stations = RandomInfraPoint[g, InfraShell[c, 4], 2, RandomSeeding -> 1]},
    {classes = GatherBy[VertexList[g], RadarCoordinates[g, stations, #] &]},
    {unresolved = Catenate @ Select[classes, Length[#] > 1 &]},
    InfraSubstrateHighlight[g, {unresolved, stations}, PlotLabel -> ResolvingSetQ[g, stations]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A metric basis of the square mesh has three vertices. Without any one of them it no longer resolves:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {basis = First @ FindResolvingSet[g]},
  InfraSubstrateHighlight[g, {basis},
    PlotLabel -> {ResolvingSetQ[g, basis], Table[ResolvingSetQ[g, Delete[basis, k]], {k, 3}]},
    ImageSize -> Medium]]
```

Two vertices of the 8-cycle resolve it unless they are opposite:

```wl
Table[ResolvingSetQ[CycleGraph[8], {1, k}], {k, 2, 5}]
```

## Properties and Relations

A list resolves exactly when the radar coordinates from it are distinct:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {basis = First @ FindResolvingSet[g]},
  Table[{CountDistinct[Values[RadarCoordinates[g, Take[basis, k]]]], ResolvingSetQ[g, Take[basis, k]]},
    {k, 3}]]
```

One vertex resolves a path exactly when it is an end:

```wl
Table[ResolvingSetQ[PathGraph[Range[6]], {k}], {k, 6}]
```

## Possible Issues

The rim vertices of the square grid are leaves, and the two leaves at a corner are twins. All the other vertices together do not resolve the grid; with one of the two added they do:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {vertexAt = AssociationThread[Round @ GraphEmbedding[g], VertexList[g]]},
  {twins = vertexAt /@ {{1, 2}, {2, 1}}}, {others = Complement[VertexList[g], twins]},
  InfraSubstrateHighlight[g, {twins},
    PlotLabel -> {ResolvingSetQ[g, others], ResolvingSetQ[g, Append[others, First @ twins]]}, ImageSize -> Medium]]
```
