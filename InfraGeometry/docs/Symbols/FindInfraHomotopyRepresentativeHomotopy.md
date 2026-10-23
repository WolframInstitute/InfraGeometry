---
Template: Symbol
Name: FindInfraHomotopyRepresentativeHomotopy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopyRepresentativeHomotopy
Keywords: [homotopy, reduction, shortest representative, chain of moves, contraction]
SeeAlso: [FindInfraHomotopyRepresentative, FindInfraHomotopy, HomotopyMoveTypes, HomotopicQ]
---

## Usage

<code>[FindInfraHomotopyRepresentativeHomotopy]()[*g*, *walk*]</code> gives a chain of elementary moves from *walk* to a shortest walk homotopic to it, as the list of walk graphs it passes through.

<code>[FindInfraHomotopyRepresentativeHomotopy]()[*g*, *walk*, *n*]</code> gives a list of *n* chains, one for each shortest walk reached.

## Details & Options

The chain is a shortest chain of the moves of [HomotopicQ]() from *walk* to a walk of [FindInfraHomotopyRepresentative](). Its first walk is *walk*, its last a representative.

The search visits every walk of the homotopy class up to `"MaxLength"` vertices, so a small `"MaxLength"` keeps it fast.

The count *n* can be `n`, `UpTo[n]` or `All`. Without a count the result is one chain. The options are those of [HomotopicQ]().

## Basic Examples

A loop from the centre around two triangles of the mesh, shrunk to its base point in two moves:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
  GraphicsRow @ Map[InfraSubstrateHighlight[g, {#, c}] &, FindInfraHomotopyRepresentativeHomotopy[g, loop, "MaxLength" -> 5]]]
```

Both moves shorten the walk:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
  HomotopyMoveTypes @ FindInfraHomotopyRepresentativeHomotopy[g, loop, "MaxLength" -> 5]]
```

## Scope

On the grid with the squares filled, the loop around a square shrinks in one move:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {loop = Join[First @ members, Rest @ Reverse @ Last @ members]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentativeHomotopy[g, loop, "NullHomotopicCycles" -> 4, "MaxLength" -> 5], {2}]]
```

## Properties and Relations

A walk that is already shortest gives the chain of that walk alone:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Map[Last, VertexList /@ FindInfraHomotopyRepresentativeHomotopy[g, {c, First @ AdjacencyList[g, c]}, "MaxLength" -> 4], {2}]]
```
