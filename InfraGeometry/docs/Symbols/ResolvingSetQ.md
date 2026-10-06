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

<code>[ResolvingSetQ]()[*g*, *basis*]</code> tests whether every vertex of *g* is determined by its distances to the vertices of *basis*.

## Details & Options

Definition: a list *B* = (*b*₁, …, *b*ₖ) of vertices resolves *g* when the radar map *v* ↦ (*d*(*v*, *b*₁), …, *d*(*v*, *b*ₖ)) is injective on the vertices of *g*: for every two vertices *u* ≠ *v* some *b* in *B* has *d*(*u*, *b*) ≠ *d*(*v*, *b*). The map is [RadarCoordinates]().

A list that contains a resolving set resolves, and so does every list of all the vertices but one. A smallest resolving set is a metric basis, found by [FindResolvingSet](); its size is the [MetricDimension]().

## Basic Examples

Two corners of the square, hexagonal and triangular tilings, red, tell apart only the vertices on the line between them: every other vertex, orange, has a mirror image at the same two distances. Three corners resolve each tiling.

```wl
With[
  {panels = Table[
     With[
       {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
       {stations = First @ FindResolvingSet[g]},
       {twoStations = Take[stations, 2]},
       {unresolved = Catenate @ Select[Values @ GroupBy[VertexList[g], RadarCoordinates[g, twoStations, #] &], Length[#] > 1 &]},
       {InfraSubstrateHighlight[g, {AssociationThread[unresolved, 1] -> StandardOrange, twoStations -> StandardRed}],
        {ResolvingSetQ[g, twoStations], ResolvingSetQ[g, stations]}}],
     {name, {"SquareTilingGraph", "HexagonalTilingGraph", "TriangularTilingGraph"}}]},
  {GraphicsRow[First /@ panels], Last /@ panels}]
```

Two vertices of the 8-cycle resolve it unless they are opposite.

```wl
With[
  {g = CycleGraph[8]},
  {GraphicsRow[Table[InfraSubstrateHighlight[g, {{1, k}}], {k, 2, 5}]], Table[ResolvingSetQ[g, {1, k}], {k, 2, 5}]}]
```

## Properties and Relations

One vertex resolves a path only from an end, and it resolves no other graph.

```wl
With[
  {g = PathGraph[Range[6]]},
  {InfraSubstrateHighlight[g, {Select[VertexList[g], ResolvingSetQ[g, {#}] &]}], Table[ResolvingSetQ[g, {k}], {k, 6}]}]
```

A list resolves exactly when the radar coordinates from it are distinct. Two corners of the hexagonal tiling give 109 vertices 67 coordinates, three corners give them 109.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {stations = First @ FindResolvingSet[g]},
  {InfraSubstrateHighlight[g, {stations}],
   Table[{CountDistinct[Values[RadarCoordinates[g, Take[stations, k]]]], ResolvingSetQ[g, Take[stations, k]]}, {k, 2, 3}]}]
```
