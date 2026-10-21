---
Template: Symbol
Name: FindClosestInfraPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindClosestInfraPoint
Keywords: [closest point, foot, projection, distance to a line, nearest vertex]
SeeAlso: [FindInfraPerpendicular, FindInfraCommonPoint, RandomInfraInfiniteLine, InfraRegionNearest, InfraDistance]
---

## Usage

<code>[FindClosestInfraPoint]()[*g*, *line*, *p*]</code> gives the vertices of *line* closest to the point *p*.

<code>[FindClosestInfraPoint]()[*g*, *line*, *p*, *n*]</code> gives *n* of them.

## Details & Options

The closest vertices are the feet *{v ∈ l : d(p, v) = d(p, l)}*, with *d(p, l) = min d(p, v)* over the vertices *v* of the line *l*.

A line can be a vertex list, a walk graph or a list of walk graphs. A list of walks gives the feet on each of them, pooled.

The point can be a vertex or a region. A region gives the feet of each of its vertices, pooled.

In the plane the foot of a point on a line is unique. On a graph there can be several, all at the same distance.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* feet give `{}`.

## Basic Examples

A line through the centre and a point at distance 3 from the centre. The label is the distance from the point to each foot; on the mesh there are two feet:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {line = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1],
     p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 3]},
    {feet = FindClosestInfraPoint[g, line, p]},
    InfraSubstrateHighlight[g, {InfraWalk[line], p, feet}, PlotLabel -> (GraphDistance[g, p, #] & /@ feet)]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A point on the line is its own foot:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {line = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1]},
  FindClosestInfraPoint[g, line, c] == {c}]
```

## Scope

The members of a segment as walk graphs. Each member has its own feet at its own distance, and the result pools them. The label is the set of those distances:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {b = RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], p = RandomInfraPoint[g, InfraShell[c, 3], RandomSeeding -> 1]},
  {members = PathGraph[#, DirectedEdges -> True] & /@ RandomInfraSegment[g, c, b, All]},
  {feet = FindClosestInfraPoint[g, members, p]},
  InfraSubstrateHighlight[g, {members, p, feet}, PlotLabel -> Union[GraphDistance[g, p, #] & /@ feet], ImageSize -> Medium]]
```
