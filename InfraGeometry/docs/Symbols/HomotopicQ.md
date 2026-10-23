---
Template: Symbol
Name: HomotopicQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/HomotopicQ
Keywords: [homotopy, homotopic paths, fundamental group, elementary move, filled cycle, combinatorial homotopy]
SeeAlso: [FindInfraHomotopy, NullHomotopicQ, FindInfraHomotopyRepresentative, HomotopyMoveTypes, RandomInfraSegment]
---

## Usage

<code>[HomotopicQ]()[*g*, *a*, *b*]</code> gives `True` if the walks *a* and *b* are homotopic in *g*, and `False` otherwise.

## Details & Options

Two walks are homotopic when a chain of elementary moves turns one into the other:

| Move | Change |
|---|---|
| stutter | insert or delete a repeated vertex: *… u …* ↔ *… u u …* |
| backtrack | insert or delete a step out and back: *… u …* ↔ *… u v u …* |
| face | replace an arc of a filled cycle by the rest of that cycle |

An open walk keeps its endpoints fixed; a closed walk keeps its base point. Both walks must be open or both closed. A vertex list is an open walk, a cycle graph a closed one.

By default the filled cycles are the triangles. The square mesh is triangulated, and two paths that bound a pair of its triangles are homotopic. The square grid has no triangles: every square is a hole, and two sides of a square are not homotopic until `"NullHomotopicCycles" -> 4` fills the squares.

A family of walks, such as a list of walk graphs, gives `True` when every pair from the two families is homotopic.

| Option | Default | Values |
|---|---|---|
| `"NullHomotopicCycles"` | `{1, 2, 3}` | the lengths of the filled cycles: 1 the stutters, 2 the backtracks, *k* ≥ 3 the *k*-cycles of *g*; an integer *k* for 1, …, *k*; or a list of cycles |
| `"FreeHomotopy"` | `False` | `True` frees the endpoints of an open walk, the base point of a closed one |
| `"MaxLength"` | `Automatic` | the longest walk, in vertices, the search visits; `Automatic` is the longer walk plus twice the longest filled cycle, at least 3 |
| `"MaxMoves"` | `Infinity` | the most moves in a chain |
| [Method]() | `"Exhaustive"` | `"Exhaustive"`, `"Greedy"` |

The exhaustive search is breadth first over all walks up to `"MaxLength"`, so `False` means no chain within that length. The greedy search takes the move that brings the walk closest to the target, in the Hausdorff distance, and stops when no move brings it closer; its `False` means only that the descent stalled.

## Basic Examples

The two shortest paths from the centre to a vertex at distance 2. On the grid the square between them is a hole; on the mesh it is two triangles:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
    InfraSubstrateHighlight[g, {InfraWalk[First @ members], InfraWalk[Last @ members]},
      PlotLabel -> HomotopicQ[g, First @ members, Last @ members]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

Filling the squares of the grid makes the two paths homotopic:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  Table[HomotopicQ[g, First @ members, Last @ members, "NullHomotopicCycles" -> k], {k, {3, 4}}]]
```

## Options

### FreeHomotopy

With free endpoints every two walks of a connected graph are homotopic, as two paths in the plane are:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopicQ[g, First @ members, Last @ members, "FreeHomotopy" -> True]]
```

### Method

On the ladder of two squares, with the squares filled, the two paths round the ladder are homotopic. The greedy descent stalls at once, since every move keeps a vertex at distance 1 from the other path:

```wl
With[{g = Graph[Range[6], {1 <-> 2, 2 <-> 3, 4 <-> 5, 5 <-> 6, 1 <-> 4, 2 <-> 5, 3 <-> 6}]},
  Table[HomotopicQ[g, {1, 2, 3, 6}, {1, 4, 5, 6}, "NullHomotopicCycles" -> 4, Method -> m],
    {m, {"Exhaustive", "Greedy"}}]]
```

## Properties and Relations

[FindInfraHomotopy]() gives the chain of moves:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopyMoveTypes @ FindInfraHomotopy[g, First @ members, Last @ members]]
```
