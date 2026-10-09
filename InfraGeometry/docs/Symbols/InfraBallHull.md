---
Template: Symbol
Name: InfraBallHull
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraBallHull
Keywords: [ball hull, Mazur hull, ball-convex, convex hull, region, symbolic object, covering]
SeeAlso: [InfraConvexHull, InfraBall, InfraTube, InfraMeasurement, FindInfraRepresentative, InfraMemberQ]
RelatedGuides: [EuclideanInfrageometry]
---

## Usage

<code>[InfraBallHull]()[*S*, *r*]</code> is the intersection of the closed balls of radius at most *r* that contain *S*, and the whole graph if there is none. It is a symbolic object; [InfraMeasurement]() and [FindInfraRepresentative]() evaluate it on a graph.

<code>[InfraBallHull]()[*S*, {*r*}]</code> takes the balls of radius exactly *r*, and <code>[InfraBallHull]()[*S*, {*r*, *s*}]</code> those of radius between *r* and *s*.

<code>[InfraBallHull]()[*S*]</code> takes every radius: the ball hull, the smallest ball-convex superset of *S*.

## Details & Options

Definition: the ball hull of *S* is the intersection of all closed balls *B_r(c)* with *S ⊆ B_r(c)*, over all centres *c*; the radius form restricts the radii. *S* is read as the core of [InfraTube]() is: a vertex, a vertex list, a density, a subgraph, or a Euclidean head through its support.

The radius is spelled as the radius of [InfraBall](): *r* means at most *r*, *{r}* exactly *r*, and *{r, s}* between *r* and *s*. The hull of *at most r* shrinks as *r* grows, since more balls cut it. The hull of *exactly r* is not monotone in *r*, and is the whole graph once every ball of radius *r* is: past the diameter of a component it is that component.

A set that is its own hull is *ball-convex*; this is the test that takes the place of a predicate. The hull of a set contained in a ball of radius *r* lies in that ball, and the hull of three vertices of a shell is smaller than the shell.

The head computes nothing. A hull has one member, the vertex set. [InfraMeasurement]() reads `"VertexDensity"`, `"EdgeDensity"`, `"Cardinality"`, `"Faithful"` and `"Subgraph"`, and the two measures; all radii are read off one distance matrix.

## Basic Examples

The ball hull of three vertices of the shell of radius 5, on the irregular mesh, the square grid and the hexagonal tiling, inside the ball they lie on.

```wl
Row[Table[
  With[
    {g = InfraSubstrate[name, "Large", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {shell = FindInfraShell[g, c, 5]},
    {seeds = shell[[ {1, Round[Length[shell] / 3], Round[2 Length[shell] / 3]} ]]},
    {hull = FindInfraRepresentative[g, InfraBallHull[seeds]]},
    Labeled[
      InfraSubstrateHighlight[g, {InfraBall[c, 5], hull, seeds}, "PointSizeRange" -> 17],
      Text[name <> ": " <> ToString[Length @ hull] <> " of " <> ToString[Length @ FindInfraRepresentative[g, InfraBall[c, 5]]] <> " vertices"]]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]]
```

On the 7 × 7 grid the hull of two vertices of the bottom row, with the balls of radius exactly 2, 6 and 8. The exact hull is not monotone in the radius, and is the whole grid at the diameter, 12.

```wl
With[
  {g = GridGraph[{7, 7}]},
  GraphicsRow[InfraSubstrateHighlight[g, {InfraBallHull[{2, 6}, {#}], {2, 6}}] & /@ {2, 6, 8}]]
```

## Properties and Relations

The hull contains the set, and it is ball-convex: it is its own hull.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Large", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {shell = FindInfraShell[g, c, 5]},
  {seeds = shell[[ {1, Round[Length[shell] / 3], Round[2 Length[shell] / 3]} ]]},
  {hull = FindInfraRepresentative[g, InfraBallHull[seeds]]},
  {SubsetQ[hull, seeds], FindInfraRepresentative[g, InfraBallHull[hull]] === hull}]
```

The hull of at most *r* shrinks as *r* grows. On a path graph no ball of radius 1 contains 3 and 7, so the hull is the whole path; from radius 2 it is the interval.

```wl
With[
  {g = PathGraph[Range[10]]},
  Keys @ InfraMeasurement[g, InfraBallHull[{3, 7}, #], "VertexDensity"] & /@ {1, 2, Infinity}]
```

The ball hull and the convex hull of the same pair on the 7 × 7 grid.

```wl
With[
  {g = GridGraph[{7, 7}]},
  GraphicsRow[InfraSubstrateHighlight[g, {#, {2, 6}}] & /@ {InfraBallHull[{2, 6}], InfraConvexHull[{2, 6}]}]]
```
