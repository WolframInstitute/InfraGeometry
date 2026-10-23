---
Template: Symbol
Name: InfraBallHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBallHull
Keywords: [ball hull, Mazur hull, ball-convex, convex hull, region, symbolic object]
SeeAlso: [InfraConvexHull, InfraBall, InfraTube, InfraMeasurement, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBallHull]()[*S*]</code> is the ball hull of the vertex set *S*: the intersection of all balls that contain *S*.

<code>[InfraBallHull]()[*S*, *r*]</code> uses the balls of radius at most *r*, <code>[InfraBallHull]()[*S*, {*r*}]</code> those of radius exactly *r*, and <code>[InfraBallHull]()[*S*, {*r*, *s*}]</code> those of radius between *r* and *s*.

## Details & Options

The ball hull is *β(S) = ⋂ {Bᵨ(c) : S ⊆ Bᵨ(c)}*, over all centres *c* and the radii *ρ* allowed. When no allowed ball contains *S*, it is the whole graph.

A set equal to its ball hull is ball-convex. The ball hull is the smallest ball-convex set containing *S*.

On the square grid, away from the rim, the ball hull of *S* is the smallest box with sides at 45° containing *S*: the vertices whose *x + y* and *x − y* lie in the ranges these take on *S*. The convex hull is the box with sides parallel to the axes. Neither contains the other: the balls of the grid are not geodesically convex.

The ball hull of radius at most *r* shrinks as *r* grows. The ball hull of radius exactly *r* need not: large balls are blunt, and the hull grows back to the whole graph.

*S* is a vertex, a vertex list, a density, a subgraph, or a geometric object through its vertices.

[InfraBallHull]() is a symbolic object: [InfraMeasurement]() evaluates it on a graph. It has one member, the vertex set.

| Property | Value |
|---|---|
| `"VertexDensity"` | 1 on each vertex of the hull |
| `"Cardinality"` | 1 |
| `"CountingMeasure"` | the number of vertices |
| `"RiemannianMeasure"` | the number of vertices all of whose neighbours lie in the hull |
| `"Subgraph"` | the subgraph induced on the hull |

## Basic Examples

The ball hull of three points of the circle of radius 4, on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraBallHull[pts], pts}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the grid the ball hull is a box at 45°, the convex hull a box along the axes. The labels are their numbers of vertices:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {hull, pts}, PlotLabel -> InfraMeasurement[g, hull, "CountingMeasure"]],
    {hull, {InfraBallHull[pts], InfraConvexHull[pts]}}]]
```

## Scope

Balls of radius exactly 4, 6 and 8 on the mesh. The hull grows with the radius:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {InfraBallHull[pts, {r}], pts}, PlotLabel -> InfraMeasurement[g, InfraBallHull[pts, {r}], "CountingMeasure"]],
    {r, {4, 6, 8}}]]
```

Balls of radius at most *r* on the grid. No ball of radius 3 contains the points, so the hull is the whole graph; from radius 4 on it is the ball hull:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  Table[InfraMeasurement[g, InfraBallHull[pts, r], "CountingMeasure"], {r, 3, 8}]]
```

## Properties and Relations

The hull contains *S* and is its own hull:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  {hull = Keys @ InfraMeasurement[g, InfraBallHull[pts], "VertexDensity"]},
  {SubsetQ[hull, pts], Keys @ InfraMeasurement[g, InfraBallHull[hull], "VertexDensity"] === hull}]
```

On the grid it is the 45° box, read off the coordinates *x + y* and *x − y*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraBall[c, 6], 3, RandomSeeding -> 2]},
  {uw = AssociationThread[VertexList[g], ({{1, 1}, {1, -1}} . #) & /@ Round[GraphEmbedding[g]]]},
  {ranges = MinMax /@ Transpose[uw /@ pts]},
  Select[VertexList[g], And @@ MapThread[IntervalMemberQ[Interval[#2], #1] &, {uw[#], ranges}] &] ===
    Keys @ InfraMeasurement[g, InfraBallHull[pts], "VertexDensity"]]
```

On the grid neither hull contains the other:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  {ball = Keys @ InfraMeasurement[g, InfraBallHull[pts], "VertexDensity"]},
  {convex = Keys @ InfraMeasurement[g, InfraConvexHull[pts], "VertexDensity"]},
  {SubsetQ[ball, convex], SubsetQ[convex, ball]}]
```

A ball hull need not be geodesically convex. On the mesh its convex hull is larger:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {pts = RandomInfraPoint[g, InfraShell[c, 4], 3, RandomSeeding -> 1]},
  {hull = Keys @ InfraMeasurement[g, InfraBallHull[pts], "VertexDensity"]},
  {Length[hull], InfraMeasurement[g, InfraConvexHull[hull], "CountingMeasure"]}]
```
