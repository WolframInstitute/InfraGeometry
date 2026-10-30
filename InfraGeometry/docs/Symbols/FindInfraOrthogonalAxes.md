---
Template: Symbol
Name: FindInfraOrthogonalAxes
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraOrthogonalAxes
Keywords: [orthogonal axes, perpendicular lines, frame, projection test, clique, dimension, vertex list]
SeeAlso: [FindInfraOrthogonalRays, OrthogonalCoordinates, InfraPerpendicularQ, FindInfraPerpendicular, FindInfraSpanningAxes, InfraFiberedGraph]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraOrthogonalAxes]()[*g*, *c*, *len*]</code> gives a maximal set of mutually perpendicular axes through the vertex *c*, each a vertex list, the straightest set first.

<code>[FindInfraOrthogonalAxes]()[*g*, *c*, *len*, *n*]</code> gives a list of *n* such sets.

## Details & Options

An axis at *c* is a shortest path through *c* whose two halves have lengths in *len*, maximal: neither end extends to a longer shortest path through *c* within *len*.

Two axes are perpendicular when every vertex of each has *c* as its only nearest vertex on the other: *d(v, w) > max(d(c, v), d(c, w))* for all *v* on one and *w* on the other, both different from *c*.

The sets returned are maximal: no further axis is perpendicular to all of them. The largest number of perpendicular axes through *c* is a reading of the dimension at *c*: *d* at the centre of a *d*-dimensional grid.

The test cannot tell a right angle from a straight one. On the grid the vertices 2 steps along the two axes, and 2 steps either way along one axis, are both 4 apart.

A bent shortest path through *c* is an axis as well, ranked after the straight ones. Some bent axes pair into a cross that turns at *c*; others have no perpendicular partner and form a set of their own.

On a triangulated mesh the exact test is hard to meet: two axes of length 1 need four pairwise non-adjacent neighbours of *c*, and at the centre of the square mesh there is no perpendicular pair of length 1 or 2.

*len* is `All`, *k* (both halves *k* steps), `UpTo[k]` (each half 1 to *k* steps) or {*min*, *max*}. The count *n* can be `n`, `UpTo[n]` or `All`. *c* can be an association of vertices, for a point realised by several vertices.

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `Automatic` | `Automatic`, the exact test; a `Method` of [InfraPerpendicularQ](), checked against each chosen axis; or a predicate on the list of chosen axes |
| `"NextVertexFunction"` | `Identity` | the order the candidate axes are tried in; `RandomChoice` gives a random maximal set |
| `"AxisCount"` | `Automatic` | `Automatic` (maximal sets), *k* (sets of exactly *k* axes), `UpTo[k]`, `All` |

## Basic Examples

The axes of 3 steps through the centre. On the grid, the straight cross; on the mesh, one line, since the exact test admits no second axis:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, Append[InfraWalk /@ FindInfraOrthogonalAxes[g, c, 3], c]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of perpendicular axes at the centre of the grids of dimension 2, 3 and 4 is the dimension:

```wl
Table[Length @ FindInfraOrthogonalAxes[GridGraph[Table[5, d]], Ceiling[5^d/2], 2], {d, 2, 4}]
```

The first three sets at length 2 on the grid: the straight cross, then two bent axes alone:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {sets = FindInfraOrthogonalAxes[g, 45, 2, 3]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, Append[InfraWalk /@ set, 45]], {set, sets}]]
```

## Scope

Halves of 2 to 4 steps, on the medium grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  InfraSubstrateHighlight[g, Append[InfraWalk /@ FindInfraOrthogonalAxes[g, c, {2, 4}], c], ImageSize -> Medium]]
```

A point realised by two adjacent vertices, given as an association. Each axis passes through one of them:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  InfraSubstrateHighlight[g, Append[InfraWalk /@ FindInfraOrthogonalAxes[g, <|45 -> 1, 46 -> 1|>, 2], {45, 46}],
    ImageSize -> Medium]]
```

## Options

### Properties

A predicate on the list of chosen axes. Admitting at most one axis makes every set a single axis, one set per axis:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {sets = FindInfraOrthogonalAxes[g, 45, 2, All, Properties -> (Length[#] <= 1 &)]},
  {Length[sets], Union[Length /@ sets]}]
```

The `"Projection"` method of [InfraPerpendicularQ](). Perpendicular lines meet in one vertex, so the axes meet only at *c*; at length 2 on the grid the set is the straight cross:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {axes = FindInfraOrthogonalAxes[g, 45, 2, Properties -> "Projection"]},
  InfraSubstrateHighlight[g, Append[InfraWalk /@ axes, 45], PlotLabel -> Length[axes], ImageSize -> Medium]]
```

### AxisCount

The sets of exactly two axes of length 2 on the grid: the straight cross and two crosses that turn at the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {sets = FindInfraOrthogonalAxes[g, 45, 2, All, "AxisCount" -> 2]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, Append[InfraWalk /@ set, 45]], {set, sets}]]
```

## Properties and Relations

Any two axes of a set pass the perpendicularity test:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[g]},
  {axes = FindInfraOrthogonalAxes[g, c, 4]},
  And @@ Flatten @ Table[GraphDistance[g, v, w] > Max[GraphDistance[g, c, v], GraphDistance[g, c, w]],
    {v, DeleteCases[axes[[1]], c]}, {w, DeleteCases[axes[[2]], c]}]]
```

An axis is two rays from *c*: the cross of the grid is 2 axes and 4 rays of [FindInfraOrthogonalRays]():

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  Length /@ {FindInfraOrthogonalAxes[g, 45, 3], FindInfraOrthogonalRays[g, 45, 3]}]
```

## Possible Issues

A right angle and a straight angle look the same to the test. From the centre 45 of the grid, 65 is 2 steps along one axis, 47 2 steps along the other and 25 2 steps back along the first:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {GraphDistance[g, 65, 47], GraphDistance[g, 65, 25]}]
```
