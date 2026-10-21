---
Template: Symbol
Name: FindInfraCommonPoint
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraCommonPoint
Keywords: [intersection, common point, meeting point, lines, Hilbert I.1]
SeeAlso: [FindInfraCommonLine, FindClosestInfraPoint, RandomInfraInfiniteLine, InfraIntersection, InfraIntersectQ]
---

## Usage

<code>[FindInfraCommonPoint]()[*g*, {*l1*, *l2*, …}]</code> gives the vertices that lie on every line *li*.

<code>[FindInfraCommonPoint]()[*g*, {*l1*, *l2*, …}, *n*]</code> gives *n* of them.

## Details & Options

The common points are the intersection *l₁ ∩ l₂ ∩ … ∩ lₖ* of the vertex sets, sorted.

A line can be a vertex list or a walk graph. A list of walks, such as the members of a segment, counts as the union of their vertices.

Two lines in the plane meet in at most one point. On a graph two lines can share a run of vertices, and they meet where they touch as well as where they cross.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. Fewer than *n* common points give `{}`.

Corresponding notion in the classical axiom systems:

| System | Name | Statement |
|---|---|---|
| Hilbert | I.1, I.2 | Two distinct lines have at most one point in common. Here they can share several. |

## Basic Examples

Two lines through the centre. On the grid they share two vertices, on the mesh only the centre:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {l1 = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], RandomSeeding -> 1],
     l2 = RandomInfraInfiniteLine[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[g, {InfraWalk[l1], InfraWalk[l2], FindInfraCommonPoint[g, {l1, l2}]},
      PlotLabel -> FindInfraCommonPoint[g, {l1, l2}]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The members of a segment, each its own entry: the common points are the vertices every shortest path passes through. On the grid they are the two endpoints:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], All]},
    InfraSubstrateHighlight[g, {InfraSegment[c, Last @ First @ members], FindInfraCommonPoint[g, members]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

## Possible Issues

A list of walks counts as one line, the union of its members. Each member must be its own entry to intersect them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 5], RandomSeeding -> 1], All]},
  {Length @ FindInfraCommonPoint[g, {members}], FindInfraCommonPoint[g, members]}]
```
