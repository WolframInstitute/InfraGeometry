---
Template: Symbol
Name: FindInfraSegment
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/FindInfraSegment
Keywords: [segment, geodesic, shortest path, Euclid Postulate 1]
SeeAlso: [InfraSegment, InfraVertexList, FindInfraLine, FindInfraMidpoint, UniqueInfraSegmentQ, MetricInterval]
RelatedGuides: [EuclideanGeometryGuide]
---

## Usage

<code>[FindInfraSegment]()[*g*, *a*, *b*]</code> gives one geodesic — a shortest path — from *a* to *b* in *g*, as a vertex list.

<code>[FindInfraSegment]()[*g*, *a*, *b*, *n*]</code> gives a `List` of exactly *n* geodesics or `$Failed`; `UpTo[n]` gives up to *n*; `All` gives every geodesic.

## Details & Options

A segment from *a* to *b* is a geodesic: a path whose length realizes $d(a,b)$.

In the Euclidean plane the segment between two points is unique. On a graph it is a **set** of paths, and uniqueness fails generically — a square grid has many geodesics between two vertices, because any interleaving of the horizontal and vertical steps is one.

The search runs on the substrate directly, with `FindPath` at the geodesic length. It does not read the graph of <code>[InfraSegment]()[*a*, *b*]</code>, so it is the check on that graph, and it returns exactly the shapes <code>[InfraVertexList]()[*g*, [InfraSegment]()[*a*, *b*], …]</code> gives. To count the geodesics without enumerating them, use [InfraMeasurement]().

The count-less call is one geodesic, deterministic. There is no `Method` and no `Properties`.

[UniqueInfraSegmentQ]() tests whether the segment is unique, which is the graph-intrinsic shadow of Euclid's first postulate holding sharply.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 1 | To draw a straight-line from any point to any point. |
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. |
| Tarski | A4, segment construction | Given points, a point can be laid off at a prescribed distance along the segment. |
| Birkhoff | Ruler postulate | The points of a line correspond to the reals, and the segment is a closed coordinate interval. |

## Basic Examples

Every geodesic between two vertices at distance 6, on the discretized plane, the square grid and the hexagonal tiling. The count is the sharpest difference between the substrates: the irregular mesh has four, the square grid fifteen, the hexagonal tiling three.

```wl
Row[Table[
   With[
     {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
     {segs = FindInfraSegment[g, a, b, All]},
     Labeled[
       InfraHighlightGraph[g,
         {segs -> $InfraSegmentColor, {a, b} -> $InfraPointColor},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ segs] <> " geodesics"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The intensity in that picture is the multiplicity: an edge lying on many geodesics is drawn more strongly than one lying on few, so the bundle shows where the segment is concentrated.

The count-less call is one geodesic; a count gives a list.

```wl
{FindInfraSegment[GridGraph[{4, 4}], 1, 11], FindInfraSegment[GridGraph[{4, 4}], 1, 11, 2]}
```

A strict count that cannot be met is `$Failed`.

```wl
FindInfraSegment[GridGraph[{4, 4}], 1, 11, 7]
```

## Properties and Relations

The vertices covered by the geodesics are exactly the metric interval between the endpoints, which is what [MetricInterval]() computes directly.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  Sort[Union @@ FindInfraSegment[g, a, b, All]] === Sort @ MetricInterval[g, a, b]]
```

The search agrees with the graph of the head.

```wl
With[
  {g = GridGraph[{5, 5}]},
  Sort @ FindInfraSegment[g, 1, 19, All] === Sort @ InfraVertexList[g, InfraSegment[1, 19], All]]
```
