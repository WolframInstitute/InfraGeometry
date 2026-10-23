---
Template: Symbol
Name: FindInfraHomotopy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopy
Keywords: [homotopy, chain of moves, deformation, elementary move, filled cycle, combinatorial homotopy]
SeeAlso: [HomotopicQ, HomotopyMoveTypes, FindInfraHomotopyRepresentativeHomotopy, NullHomotopicQ, InfraDeformationSize]
---

## Usage

<code>[FindInfraHomotopy]()[*g*, *a*, *b*]</code> gives a chain of elementary moves from the walk *a* to the walk *b*, as the list of walk graphs it passes through.

<code>[FindInfraHomotopy]()[*g*, *a*, *b*, *n*]</code> gives a list of *n* chains.

## Details & Options

The moves are those of [HomotopicQ](): insert or delete a repeated vertex, insert or delete a backtrack *u v u*, and replace an arc of a filled cycle by the rest of that cycle. Each walk of the chain differs from the next by one move. With the default method the chain has the fewest moves.

The result is `{}` when there is no chain within `"MaxLength"`. Both walks must be open or both closed. Each walk of a chain is a directed path graph, or a directed cycle graph for closed walks, with vertices {*i*, *v*}.

The count *n* can be `n`, `UpTo[n]` or `All`. Without a count the result is one chain.

| Option | Default | Values |
|---|---|---|
| [Method]() | `"Exhaustive"` | `"Exhaustive"`: breadth-first search; `"Greedy"`: always the move that brings the walk's vertices closest to the target's, stopping when none does |
| `"NullHomotopicCycles"` | `{1, 2, 3}` | the lengths of the filled cycles; an integer *k* for 1, …, *k*; or a list of cycles |
| `"FreeHomotopy"` | `False` | `True` frees the endpoints, or the base point |
| `"MaxLength"` | `Automatic` | the longest walk, in vertices; `Automatic` is the longer walk plus twice the longest filled cycle, at least 3 |
| `"MaxMoves"` | `Infinity` | the most moves |

## Basic Examples

The chain between the two shortest paths from the centre to a vertex at distance 2 on the mesh. It crosses one triangle out and the other back:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  GraphicsRow @ Map[InfraSubstrateHighlight[g, {#}] &, FindInfraHomotopy[g, First @ members, Last @ members]]]
```

On the grid there is no chain until the squares are filled; then one move swaps the two sides of the square:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  {FindInfraHomotopy[g, First @ members, Last @ members],
   Map[Last, VertexList /@ FindInfraHomotopy[g, First @ members, Last @ members, "NullHomotopicCycles" -> 4], {2}]}]
```

## Options

### Method

The greedy search finds the same one-move chain on the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  Length @ FindInfraHomotopy[g, First @ members, Last @ members, Method -> "Greedy", "NullHomotopicCycles" -> 4]]
```

## Properties and Relations

The moves of the mesh chain lengthen the walk and then shorten it:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopyMoveTypes @ FindInfraHomotopy[g, First @ members, Last @ members]]
```
