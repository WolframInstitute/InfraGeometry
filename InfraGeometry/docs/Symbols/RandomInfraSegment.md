---
Template: Symbol
Name: RandomInfraSegment
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraSegment
Keywords: [segment, shortest path, Euclid Postulate 1]
SeeAlso: [InfraSegment, RandomInfraSegment, RandomInfraInfiniteLine, InfraMeasurement, UniqueInfraSegmentQ, MetricInterval]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[RandomInfraSegment]()[*g*, *a*, *b*]</code> gives one random shortest path from *a* to *b* in *g*, as a vertex list.

<code>[RandomInfraSegment]()[*g*, *a*, *b*, *n*]</code> gives a `List` of exactly *n* shortest paths, or `{}` when there are fewer; `UpTo[n]` gives up to *n*; `All` gives every shortest path.

## Details & Options

The default draw is random. Seed with `SeedRandom` to reproduce it. Give `"NextVertexFunction" -> Identity` for deterministic descent. `All` with `Automatic` keeps the full enumeration without drawing.

A segment from *a* to *b* is a shortest path: a path whose length realizes $d(a,b)$.

In the Euclidean plane the segment between two points is unique. On a graph it is a **set** of paths, and uniqueness fails generically — a square grid has many shortest paths between two vertices, because any interleaving of the horizontal and vertical steps is one.

The sampler draws from the interval DAG through <code>[RandomInfraSegment]()[*g*, [InfraSegment]()[*a*, *b*], …]</code>. To count the shortest paths without enumerating them, use [InfraMeasurement]().

The count-less call is one random shortest path. There is no `Method` and no `Properties`.

[UniqueInfraSegmentQ]() tests whether the segment is unique, which is the graph-intrinsic shadow of Euclid's first postulate holding sharply.

Corresponding notions in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Euclid | Postulate 1 | To draw a straight-line from any point to any point. |
| Hilbert | I.1, I.2 | Two distinct points determine one and only one line. |
| Tarski | A4, segment construction | Given points, a point can be laid off at a prescribed distance along the segment. |
| Birkhoff | Ruler postulate | The points of a line correspond to the reals, and the segment is a closed coordinate interval. |

## Basic Examples

Every shortest path between two vertices at distance 6, on the discretized plane, the square grid and the hexagonal tiling. The count is the sharpest difference between the substrates: the irregular mesh has four, the square grid fifteen, the hexagonal tiling three.

```wl
SeedRandom[1];
Row[Table[
   With[
     {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
     {a = First @ GraphCenter[g]},
     {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 6 &]},
     {segs = RandomInfraSegment[g, a, b, All]},
     Labeled[
       InfraSubstrateHighlight[g,
         {segs, {a, b}},
         "PointSizeRange" -> 15,
         VertexShapeFunction -> ({AbsolutePointSize[2.2], Point[#]} &),
         ImageSize -> 250],
       Text[name <> ": " <> ToString[Length @ segs] <> " shortest paths"]]],
   {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

The intensity in that picture is the multiplicity: an edge lying on many shortest paths is drawn more strongly than one lying on few, so the bundle shows where the segment is concentrated.

The count-less call is one shortest path; a count gives a list.

```wl
SeedRandom[1];
{RandomInfraSegment[GridGraph[{4, 4}], 1, 11], RandomInfraSegment[GridGraph[{4, 4}], 1, 11, 2]}
```

A strict count that cannot be met gives the empty list.

```wl
SeedRandom[1];
RandomInfraSegment[GridGraph[{4, 4}], 1, 11, 7]
```

## Properties and Relations

The vertices covered by the shortest paths are exactly the metric interval between the endpoints, which is what [MetricInterval]() computes directly.

```wl
SeedRandom[1];
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {a = First @ GraphCenter[g]},
  {b = First @ Sort @ Select[VertexList[g], GraphDistance[g, a, #] == 5 &]},
  Sort[Union @@ RandomInfraSegment[g, a, b, All]] === Sort @ MetricInterval[g, a, b]]
```

The search agrees with the graph of the head.

```wl
SeedRandom[1];
With[
  {g = GridGraph[{5, 5}]},
  Sort @ RandomInfraSegment[g, 1, 19, All] === Sort @ RandomInfraSegment[ g, InfraSegment[1, 19], All ]]
```
