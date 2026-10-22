---
Template: Symbol
Name: NullHomotopicQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/NullHomotopicQ
Keywords: [null-homotopic, contractible loop, homotopy, closed walk, fundamental group, face]
SeeAlso: [HomotopicQ, FindInfraHomotopy, FindInfraHomotopyRepresentative, InfraWalkQ, InfraWalk]
---

## Usage

<code>[NullHomotopicQ]()[*g*, *cycle*]</code> gives `True` if the closed walk *cycle* can be contracted to its base point in *g* by elementary moves.

## Details & Options

A graph has no 2-cells of its own, so the moves say which cycles bound a disc. The default moves are:

| Move | Effect on the walk |
|---|---|
| 1 | repeat a vertex, or drop a repeat |
| 2 | insert a step back *v w v*, or remove one |
| *k ≥ 3* | replace one arc of a *k*-cycle of *g* by the other arc |

A closed walk is null-homotopic when a chain of moves turns it into the constant walk at its first vertex. With the default {1, 2, 3}, the triangles are the faces. On the square mesh, whose faces are triangles, every triangle contracts; on the square grid, which has no triangles, not even a unit square does.

*cycle* is a vertex list, read cyclically, a cycle graph, or a list of them, which passes when each one does. A list that repeats its first vertex at the end is read the same.

Options:

| Option | Default | Values |
|---|---|---|
| `"NullHomotopicCycles"` | `{1, 2, 3}` | the move lengths; an integer *k* is {1, …, *k*} |
| `"FreeHomotopy"` | `False` | `True` lets the base point move |
| `"MaxLength"` | `Automatic` | the longest walk a chain may pass through |
| `"MaxMoves"` | [Infinity]() | the longest chain searched |
| [Method]() | `"Exhaustive"` | `"Exhaustive"`, `"Greedy"` |

The exhaustive search grows fast with the length of the cycle. The greedy search moves the walk ever closer to its base point and stops when no move does; its `False` means only that the descent stalled.

## Basic Examples

A unit square of the grid is not null-homotopic with triangles as faces, and is with squares as faces:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {square = {45, 46, 56, 55}},
  InfraSubstrateHighlight[g, {InfraWalk[Append[square, First @ square]]},
    PlotLabel -> {NullHomotopicQ[g, square], NullHomotopicQ[g, square, "NullHomotopicCycles" -> 4]},
    ImageSize -> Medium]]
```

A triangle of the mesh is null-homotopic:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {triangle = {c, 42, 43}},
  InfraSubstrateHighlight[g, {InfraWalk[Append[triangle, c]], c}, PlotLabel -> NullHomotopicQ[g, triangle],
    ImageSize -> Medium]]
```

## Scope

A step back is contracted by the move 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, NullHomotopicQ[g, {45, 46, 45}]]
```

A closed walk round a rectangle of two unit squares, with squares as faces:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  NullHomotopicQ[g, {45, 46, 47, 57, 56, 55}, "NullHomotopicCycles" -> 4]]
```

## Options

### NullHomotopicCycles

The cycle graph has no triangle, and its one cycle is not null-homotopic. Declaring the hexagon a face fills it:

```wl
Table[NullHomotopicQ[CycleGraph[6], Range[6], "NullHomotopicCycles" -> k], {k, {3, 6}}]
```

### Method

The boundary of the ladder of two squares, from the middle of a long side. Each square removed leaves a corner as far from the base point as before, so the greedy descent stalls where the exhaustive search contracts the walk:

```wl
With[{g = Graph[Range[6], {1 <-> 2, 2 <-> 3, 4 <-> 5, 5 <-> 6, 1 <-> 4, 2 <-> 5, 3 <-> 6}]},
  Table[NullHomotopicQ[g, {2, 3, 6, 5, 4, 1}, "NullHomotopicCycles" -> 4, Method -> m],
    {m, {"Exhaustive", "Greedy"}}]]
```
