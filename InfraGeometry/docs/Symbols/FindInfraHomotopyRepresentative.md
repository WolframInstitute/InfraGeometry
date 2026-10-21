---
Template: Symbol
Name: FindInfraHomotopyRepresentative
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopyRepresentative
Keywords: [homotopy class, shortest representative, reduced walk, geodesic in a homotopy class, fundamental group]
SeeAlso: [FindInfraHomotopyRepresentativeHomotopy, FindInfraHomotopy, HomotopicQ, NullHomotopicQ]
---

## Usage

<code>[FindInfraHomotopyRepresentative]()[*g*, *walk*]</code> gives the shortest walks homotopic to *walk*, as walk graphs.

<code>[FindInfraHomotopyRepresentative]()[*g*, *walk*, *n*]</code> gives *n* of them.

## Details & Options

The homotopy class of a walk is the set of walks reached from it by the elementary moves of [HomotopicQ](). An open walk keeps its endpoints, a closed walk its base point. The result is the walks of fewest vertices in the class, among those of at most `"MaxLength"` vertices.

In the plane the shortest path in the class of a path is unique. On a graph there can be several, and a hole in the graph can keep a walk from shrinking.

The search visits every walk of the class up to `"MaxLength"`, so a small `"MaxLength"` keeps it fast.

The count *n* can be `n`, `UpTo[n]` or `All`, the default. The options are those of [HomotopicQ]().

## Basic Examples

A loop from the centre around a square of the grid and around two triangles of the mesh, with its shortest representative as the label. On the grid the square is a hole and the loop does not shrink; on the mesh it shrinks to its base point:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
    {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
    InfraSubstrateHighlight[g, {InfraWalk[loop], c},
      PlotLabel -> Last /@ VertexList[First @ FindInfraHomotopyRepresentative[g, loop, "MaxLength" -> 5]]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Filling the squares of the grid lets the loop shrink:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, loop, "NullHomotopicCycles" -> 4, "MaxLength" -> 5], {2}]]
```

## Scope

With the squares filled, a shortest path across a square has two representatives, the two sides of the square:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, First @ members, "NullHomotopicCycles" -> 4, "MaxLength" -> 5], {2}]]
```

A walk with a backtrack reduces to the walk without it:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {n = First @ AdjacencyList[g, c], m = Last @ AdjacencyList[g, c]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentative[g, {n, c, m, c}, "MaxLength" -> 4], {2}]]
```

## Properties and Relations

[FindInfraHomotopyRepresentativeHomotopy]() gives a chain of moves to a representative; its last walk is one:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
  MemberQ[FindInfraHomotopyRepresentative[g, loop, "NullHomotopicCycles" -> 4, "MaxLength" -> 5],
    Last @ FindInfraHomotopyRepresentativeHomotopy[g, loop, "NullHomotopicCycles" -> 4, "MaxLength" -> 5]]]
```
