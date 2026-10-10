---
Template: Symbol
Name: FindInfraOrthogonalRays
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraOrthogonalRays
Keywords: [orthogonal frame, perpendicular rays, negative, reflection, projection test, clique, vertex list]
SeeAlso: [FindInfraOrthogonalAxes, OrthogonalCoordinates, RandomInfraRay, RandomInfraLine, InfraPerpendicularQ, FindInfraSpanningAxes, InfraSubstrateHighlight]
RelatedGuides: [Experimental]
---

## Usage

<code>[FindInfraOrthogonalRays]()[*g*, *c*, *len*]</code> gives one maximal set of mutually perpendicular shortest path rays from the vertex *c*, each a vertex list starting at *c*, the straightest set first.

<code>[FindInfraOrthogonalRays]()[*g*, *c*, *len*, *n*]</code> gives a `List` of exactly *n* such sets or `{}`; `UpTo[n]` gives up to *n*; `All` gives every one.

## Details & Options

The problem is well posed. Fix a graph *g*, a vertex *c* and a length *len*.

- A **ray** at *c* is a shortest path from *c*, a vertex list starting at *c* with a length in *len*, maximal there: its last vertex has no neighbour that prolongs it to a longer shortest path from *c* inside *len*. The rays form a finite set in the ball of radius *r* about *c*, *r* the largest length.
- Two rays are **perpendicular** by the test of [FindInfraOrthogonalAxes](): the shortest-path projection of every vertex of each onto the other is *c*, that is `d(v, w) > Max[d(c, v), d(c, w)]` for every vertex *v* of one and *w* of the other, both different from *c*. The relation is symmetric, so the sets of mutually perpendicular rays are the cliques of a finite graph, and the largest number of mutually perpendicular rays at *c* is its clique number.
- A single ray carries no right angle. On the grid `d((2, 0), (0, 2)) = 4 = d((2, 0), (-2, 0))`: the distances do not tell a quarter turn from a half turn. The test therefore passes the **opposite** of a ray as well, the reflection of the ray through *c*, and a frame of the grid `Z^d` is `2 d` rays, the `d` directions each with its negative. A direction is read after identifying each ray with its negative.
- Where the negative of a ray does not exist or is not unique, the two maxima differ: the number of mutually perpendicular lines through *c*, [FindInfraOrthogonalAxes](), and the number of mutually perpendicular rays at *c*. At a path endpoint there is a ray and no line. In Euclidean space both are the dimension, the rays counted up to their negatives.
- An axis splits at *c* into two rays, and a ray extends through *c* to a line with [RandomInfraLine]().
- *len* is `All`, an integer *k*, `UpTo[k]` or `{min, max}` (*max* may be `Infinity`); each ray is maximal inside the range, so `All` never returns a sub-ray of a ray. The count-less call gives the first set, `n` the first *n* sets, `All` every maximal set. The rank is a longer ray first, then fewer vertices in the shortest path interval of its ends, so the straight frame comes first.
- *c* is a vertex or an association `<| v1 -> w1, ... |>` of vertices, as in [FindInfraOrthogonalAxes]().

| Option | Default | Values |
|---|---|---|
| `Properties` | `Automatic` | the class of admissible next rays |
| `"NextVertexFunction"` | `Identity` | the order the candidates are tried in |
| `"RayCount"` | `Automatic` | the number of rays in a set |

`Properties`, `"NextVertexFunction"` and the count act as on [FindInfraOrthogonalAxes](). `"RayCount" -> k` keeps the sets of exactly *k* rays, `UpTo[k]` the sets of *k* rays or fewer if maximal, `All` every clique of any size, `Automatic` the maximal ones.

## Basic Examples

The straight frame at the centre of the square tiling: four rays of 4 steps, each axis read twice.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {rays = FindInfraOrthogonalRays[g, c, 4]},
  {InfraSubstrateHighlight[g, Append[rays, {c}]], Length @ rays}]
```

The frame of the cubic and of the 4-dimensional grid has `2 d` rays.

```wl
Length @ FindInfraOrthogonalRays[GridGraph[Table[5, #]], Ceiling[5^# / 2], 2] & /@ {2, 3, 4}
```

## Scope

At a path endpoint there is one ray and no line; at an interior vertex the rays are the two halves of the one axis.

```wl
{FindInfraOrthogonalRays[PathGraph[Range[5]], 1, All], FindInfraOrthogonalRays[PathGraph[Range[5]], 3, All],
  FindInfraOrthogonalAxes[PathGraph[Range[5]], 1, All]}
```

A star has a ray to every leaf, and any two are perpendicular: the rays number the leaves, the axes at most half of them.

```wl
{Length @ FindInfraOrthogonalRays[StarGraph[6], 1, All], Length @ FindInfraOrthogonalAxes[StarGraph[6], 1, All]}
```

Lengths `{min, max}`: rays of at least 2 and at most 4 steps.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Medium", "KeepCoordinates" -> True]},
  {c = First @ GraphCenter[g]},
  {rays = FindInfraOrthogonalRays[g, c, {2, 4}]},
  InfraSubstrateHighlight[g, Append[rays, {c}]]]
```

## Options

### RayCount

Sets of exactly two rays at scale 2 of the 9 x 9 grid: the first three of them, the straight pair of a line first.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow[InfraSubstrateHighlight[g, Append[#, {41}]] & /@ FindInfraOrthogonalRays[g, 41, 2, 3, "RayCount" -> 2]]]
```

### NextVertexFunction

`RandomChoice` draws the candidates at random, so the count-less call is a random maximal set of rays.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g,
      Append[(SeedRandom[seed]; FindInfraOrthogonalRays[g, 41, 2, "NextVertexFunction" -> RandomChoice]), {41}]],
    {seed, 3}]]
```

## Properties and Relations

The rays of the straight frame are the axes cut at *c*: two axes on the left, four rays on the right.

```wl
With[
  {g = GridGraph[{9, 9}], c = 41},
  {axes = FindInfraOrthogonalAxes[g, c, 3], rays = FindInfraOrthogonalRays[g, c, 3]},
  {GraphicsRow[{InfraSubstrateHighlight[g, Append[axes, {c}]], InfraSubstrateHighlight[g, Append[rays, {c}]]}], Length /@ {axes, rays}}]
```

The frame feeds [OrthogonalCoordinates]() as it stands: each axis is read twice, once as its positive and once as its negative part, and a vertex of the grid has the signed position on each.

```wl
With[
  {g = GridGraph[{5, 5}], c = 13},
  {rays = FindInfraOrthogonalRays[g, c, 2]},
  OrthogonalCoordinates[g, c, rays, 15]]
```

## Possible Issues

The frame of rays is not a basis: the opposite rays are two of its members. Count the directions after identifying each ray with its negative, or take the axes.

The same cost as the axes: the candidates grow like the shortest paths from *c*, so a long length on a large grid is slow.
