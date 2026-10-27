---
Template: Symbol
Name: FindInfraHomotopy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHomotopy
Keywords: [homotopy, chain of moves, deformation, elementary move, filled cycle, combinatorial homotopy]
SeeAlso: [HomotopicQ, HomotopyMoveTypes, FindInfraHomotopyRepresentativeHomotopy, NullHomotopicQ, InfraDeformationSize]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[FindInfraHomotopy]()[*g*, *a*, *b*]</code> gives a chain of elementary moves from the walk *a* to the walk *b*, as the list of walk graphs it passes through.

<code>[FindInfraHomotopy]()[*g*, *a*, *b*, *n*]</code> gives a list of *n* chains.

<code>[FindInfraHomotopy]()[*g*, *walk*, Automatic]</code> finds a chain to a certified shortest representative of *walk*.

## Details & Options

The moves are those of [HomotopicQ](): insert or delete a repeated vertex, insert or delete a backtrack *u v u*, and replace an arc of a filled cycle by the rest of that cycle. Each walk of the chain differs from the next by one move. Exact reductions can construct a witness directly. Otherwise `Method -> "Exhaustive"` explores the bounded state graph breadth first. Returned witnesses are not promised to use the fewest moves.

The call remains unevaluated when bounded search is inconclusive. For a single pair, `{}` certifies that no homotopy exists in the specified relation. Both walks must be open or both closed. Each walk of a chain is a directed path graph, or a directed cycle graph for closed walks, with vertices {*i*, *v*}.

For closed walks with `"FreeHomotopy" -> True`, certificates are taken modulo cyclic reparametrization. The first and last displayed cycles may be rotations of the supplied inputs; even a singleton canonical cycle can certify that two parametrizations represent the same free loop.

The count *n* can be `n`, `UpTo[n]` or `All`. Without a count the result is one chain. For families of input walks, at most one witness is found for each pair of realisations. `All` collects those witnesses; it does not enumerate all possible homotopies between one pair. An exact integer count returns `{}` on a proved shortage of witnesses and remains unevaluated if the shortage is unresolved.

| Option | Default | Values |
|---|---|---|
| [Method]() | `Automatic` | `Automatic`: exact reductions when available, otherwise bounded witness search; `"Exhaustive"`: breadth-first search; `"Greedy"`: descent toward the target |
| `"NullHomotopicCycles"` | `{1, 2, 3}` | the lengths of the filled cycles; an integer *k* for 1, …, *k*; or a list of cycles |
| `"FreeHomotopy"` | `False` | `True` frees the endpoints, or the base point |
| `"MaxLength"` | `Automatic` | the longest walk, in vertices; `Automatic` is the longer walk plus twice the longest filled cycle, at least 3 |
| `"MaxMoves"` | `Infinity` | the most moves |
| `"MaxStates"` | `1000` | the maximum number of search states; `Infinity` is available with explicit `Method -> "Exhaustive"` |

An inert <code>[InfraHomotopy]()[*a*, *b*, *relationOptions*]</code> can replace the separate input walks. Pass search options to the finder. A bounded search can miss a homotopy whose intermediate walks exceed its limits. The search budgets bound face search; exact reduction and free-endpoint constructions can bypass them.

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
