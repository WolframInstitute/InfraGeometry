---
Template: Symbol
Name: InfraConvexHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConvexHull
Keywords: [convex hull, geodesic convexity, interval closure, region, symbolic object]
SeeAlso: [InfraBallHull, InfraSegment, InfraTube, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraConvexHull]()[*S*]</code> is the convex hull of the vertex set *S*: the smallest set that contains *S* and every shortest path between two of its vertices.

<code>[InfraConvexHull]()[*S*, *k*]</code> is the *k*-th round of the interval closure of *S*.

## Details & Options

With the interval *I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)}*, round 0 is *S* and round *k + 1* is the union of the intervals *I(u, v)* over the vertices *u*, *v* of round *k*. The rounds grow until they stop; the last one is the convex hull.

A set equal to its convex hull is geodesically convex.

On the square grid, away from the rim, the convex hull of *S* is the smallest box with sides parallel to the axes that contains *S*. On other graphs the hull can need several rounds, and it can jump: a few points of the mesh have a thin hull, one more point a thick one.

*S* is a vertex, a vertex list, a density, a subgraph, or a geometric object through its vertices.

[InfraConvexHull]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph. It has one member, the vertex set.

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on each vertex of the hull |
| `"Cardinality"` | 1 |
| `"CountingMeasure"` | the number of vertices |
| `"RiemannianMeasure"` | the number of vertices all of whose neighbours lie in the hull |
| `"Subgraph"` | the subgraph induced on the hull |

## Basic Examples

The convex hull of four points of the circle of radius 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pts = RandomInfraPoint[g, InfraShell[c, 4], 4, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraConvexHull[pts], pts}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The rounds 0, 1 and 2 on the mesh. Round 2 adds two vertices, and later rounds add none:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 4, RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraConvexHull[pts, k], pts}, PlotLabel -> InfraMeasurement[g, InfraConvexHull[pts, k], "CountingMeasure"]],
    {k, 0, 2}]]
```

## Scope

On the Petersen graph three vertices need three rounds, and the hull is the whole graph:

```wl
Table[InfraMeasurement[PetersenGraph[], InfraConvexHull[{1, 2, 8}, k], "CountingMeasure"], {k, 0, 4}]
```

## Properties and Relations

The sizes of the hulls of 2 to 5 points of the circle of radius 4. On the mesh the hull of three points is thin, the hull of four thick:

```wl
Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    Table[InfraMeasurement[g, InfraConvexHull[RandomInfraPoint[g, InfraShell[c, 4], k, RandomSeeding -> 1]], "CountingMeasure"], {k, 2, 5}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the hull is the bounding box of the points:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraBall[c, 6], 3, RandomSeeding -> 2]},
  {xy = AssociationThread[VertexList[g], Round[GraphEmbedding[g]]]}, {ranges = MinMax /@ Transpose[xy /@ pts]},
  Select[VertexList[g], And @@ MapThread[IntervalMemberQ[Interval[#2], #1] &, {xy[#], ranges}] &] ===
    Keys @ InfraMeasurement[g, InfraConvexHull[pts], "VertexDensity"]]
```

The hull is its own hull and contains every round:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 4, RandomSeeding -> 1]},
  {hull = Keys @ InfraMeasurement[g, InfraConvexHull[pts], "VertexDensity"]},
  {Keys @ InfraMeasurement[g, InfraConvexHull[hull], "VertexDensity"] === hull,
   AllTrue[Range[0, 3], SubsetQ[hull, Keys @ InfraMeasurement[g, InfraConvexHull[pts, #], "VertexDensity"]] &]}]
```

The ball hull and the convex hull of the same points; see [InfraBallHull]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {hull, pts}], {hull, {InfraConvexHull[pts], InfraBallHull[pts]}}]]
```
