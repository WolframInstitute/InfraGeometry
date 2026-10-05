---
Template: Symbol
Name: InfraConvexHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConvexHull
Keywords: [convex hull, geodesic convexity, interval closure, region, inert head]
SeeAlso: [InfraBallHull, InfraSegment, InfraTube, InfraMeasurement, FindInfraRepresentative, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraConvexHull]()[*S*, *k*]</code> is the *k*-th round of the interval closure of *S*: round 0 is *S*, and each round adds every shortest path between two of its vertices. It is inert; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraConvexHull]()[*S*]</code> is the convex hull: the fixed point of the rounds, the smallest set containing *S* and every shortest path between two of its vertices.

## Details & Options

Definition: with the metric interval *I(u, v) = {w : d(u, w) + d(w, v) = d(u, v)}*, round *k + 1* of *S* is the union of the intervals *I(u, v)* over the vertices *u, v* of round *k*. *S* is read as the core of [InfraTube]() is: a vertex, a vertex list, a density, a subgraph, or a Euclidean head through its support.

A set that is its own hull is *geodesically convex*; this is the test that takes the place of a predicate.

The rounds increase and are bounded by the graph, so the convex hull is reached after finitely many. On the substrates below it is reached after two rounds; on the Petersen graph it takes three.

The head computes nothing. A hull has one member, the vertex set. [InfraMeasurement]() reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`, and the two measures; all rounds are read off one distance matrix.

## Basic Examples

The rounds 0, 1 and 2 of the interval closure of three vertices of the shell of radius 5, on the irregular mesh, the square grid and the hexagonal tiling.

```wl
GraphicsGrid @ Table[
  With[
    {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {shell = FindInfraShell[g, c, 5]},
    {seeds = shell[[ {1, Round[Length[shell] / 3], Round[2 Length[shell] / 3]} ]]},
    InfraSubstrateHighlight[g, {InfraConvexHull[seeds, round], seeds}, "PointSizeRange" -> 17]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}},
  {round, {0, 1, 2}}]
```

The sizes of the rounds of three vertices of the Petersen graph.

```wl
With[
  {g = PetersenGraph[]},
  Length @ FindInfraRepresentative[g, InfraConvexHull[{1, 2, 8}, #]] & /@ Range[0, 4]]
```

## Properties and Relations

The hull of two vertices of a path graph is the interval between them, and one round of two vertices is already the interval.

```wl
With[
  {g = PathGraph[Range[10]]},
  Keys @ InfraMeasurement[g, InfraConvexHull[{3, 7}, 1], "VertexDensity"]]
```

The hull is geodesically convex: it is its own hull, and it contains every round.

```wl
With[
  {g = GridGraph[{7, 7}]},
  {hull = FindInfraRepresentative[g, InfraConvexHull[{2, 6, 40}]]},
  {FindInfraRepresentative[g, InfraConvexHull[hull]] === hull, SubsetQ[hull, FindInfraRepresentative[g, InfraConvexHull[{2, 6, 40}, 1]]]}]
```

The convex hull and the ball hull of the same pair on the 7 × 7 grid.

```wl
With[
  {g = GridGraph[{7, 7}]},
  GraphicsRow[InfraSubstrateHighlight[g, {#, {2, 6}}] & /@ {InfraConvexHull[{2, 6}], InfraBallHull[{2, 6}]}]]
```
