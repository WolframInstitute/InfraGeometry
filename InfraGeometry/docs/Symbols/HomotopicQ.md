---
Template: Symbol
Name: HomotopicQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/HomotopicQ
Keywords: [homotopy, homotopic paths, fundamental group, elementary move, filled cycle, combinatorial homotopy]
SeeAlso: [FindInfraHomotopy, NullHomotopicQ, FindInfraHomotopyRepresentative, HomotopyMoveTypes, RandomInfraSegment]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[HomotopicQ]()[*g*, *a*, *b*]</code> gives `True` when homotopy of the walks *a* and *b* is certified, `False` when non-homotopy is certified, and remains unevaluated when undecided.

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
| [Method]() | `Automatic` | exact reductions when available, otherwise bounded witness search; also `"Exhaustive"`, `"Greedy"` |
| `"MaxStates"` | `1000` | maximum search states; explicit `Method -> "Exhaustive"` also permits `Infinity` |

Finding a move chain certifies `True`. A failed bounded search or stalled greedy descent does not certify `False`; the original predicate remains unevaluated. `False` requires an exact obstruction, such as incompatible fixed endpoints or unequal reduced words in the face-free relation. The search limits control computation, not the homotopy relation.

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

Compare the methods on two paths around a ladder whose squares are filled. A heuristic may fail to find a witness. An unresolved predicate is displayed as `"Undecided"`:

```wl
With[{g = Graph[Range[6], {1 <-> 2, 2 <-> 3, 4 <-> 5, 5 <-> 6, 1 <-> 4, 2 <-> 5, 3 <-> 6}]},
  Table[Replace[HomotopicQ[g, {1, 2, 3, 6}, {1, 4, 5, 6}, "NullHomotopicCycles" -> 4, Method -> m],
    _HomotopicQ -> "Undecided"],
    {m, {"Exhaustive", "Greedy"}}]]
```

## Properties and Relations

[FindInfraHomotopy]() gives the chain of moves:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {members = RandomInfraSegment[g, c, RandomInfraPoint[g, InfraShell[c, 2], RandomSeeding -> 1], All]},
  HomotopyMoveTypes @ FindInfraHomotopy[g, First @ members, Last @ members]]
```
