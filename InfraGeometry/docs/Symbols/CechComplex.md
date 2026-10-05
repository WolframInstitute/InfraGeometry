---
Template: Symbol
Name: CechComplex
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/CechComplex
Keywords: [Cech complex, nerve, ball cover, simplicial complex, miniball]
SeeAlso: [BallIntersectionComplex, CechFiltration, MiniballRadius, FindBallCover, InfraBall]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[CechComplex]()[*data*, *r*]</code> gives the Čech complex of the closed balls of radius *r* about the points of *data*: a set of balls is a simplex when they have a common point.

## Details & Options

Definition: the Čech complex is the nerve of the balls *B_i*, the sets *σ* of positions with *⋂_(i ∈ σ) B_i ≠ ∅*. It is <code>[BallIntersectionComplex]()[*data*, *r*, [Infinity]()]</code> and takes its options: `"Metric"`, `"IntersectionTest"`, `"MaxDimension"`.

For Euclidean points a set is a simplex when its points fit in a ball of radius *r*, <code>[MiniballRadius]()[*points*] ≤ *r*</code>. With `"Metric"` -> *g* the points are vertices of the graph *g*, and a set is a simplex when some vertex of *g* lies within *r* of each of them.

A simplex is a sorted list of positions in *data*.

## Basic Examples

The Čech complex of sixteen random points in the unit square at radii 0.08, 0.12 and 0.16, drawn over the disks.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  GraphicsRow @ Table[
    With[{complex = CechComplex[points, r]},
      Graphics[{
        {StandardBlue, Opacity[0.15], Disk[#, r] & /@ points},
        {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
        {StandardRed, Line[points[[#]]] & /@ Select[complex, Length[#] == 2 &]},
        Point[points]},
        PlotLabel -> r]],
    {r, {0.08, 0.12, 0.16}}]]
```

The nerve of a smallest cover of the hexagonal tiling by balls of radius 3: an edge joins two centres whose balls meet.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {cover = FindBallCover[g, 3]},
  {nerve = CechComplex[cover, 3, "Metric" -> g]},
  Show[
    InfraSubstrateHighlight[g, InfraBall[#, 3] & /@ cover],
    Graph[cover, UndirectedEdge @@@ (cover[[#]] & /@ Select[nerve, Length[#] == 2 &]),
      VertexCoordinates -> Thread[cover -> GraphEmbedding[g][[VertexIndex[g, #] & /@ cover]]]]]]
```

## Properties and Relations

A set of Euclidean points is a simplex exactly when its smallest enclosing ball has radius at most *r*.

```wl
With[
  {points = (SeedRandom[3]; RandomReal[1, {16, 2}])},
  {complex = CechComplex[points, 0.16]},
  {Graphics[{
     {StandardBlue, Opacity[0.15], Disk[#, 0.16] & /@ points},
     {StandardRed, Opacity[0.3], Polygon[points[[#]]] & /@ Select[complex, Length[#] == 3 &]},
     Point[points]}],
   complex == Select[Subsets[Range[16], {1, 16}], MiniballRadius[points[[#]]] <= 0.16 &]}]
```
