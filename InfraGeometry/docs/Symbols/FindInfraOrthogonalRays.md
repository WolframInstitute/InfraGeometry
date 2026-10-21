---
Template: Symbol
Name: FindInfraOrthogonalRays
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraOrthogonalRays
Keywords: [orthogonal frame, perpendicular rays, projection test, clique, vertex list]
SeeAlso: [FindInfraOrthogonalAxes, OrthogonalCoordinates, RandomInfraHalfLine, RandomInfraInfiniteLine, InfraPerpendicularQ, FindInfraSpanningAxes]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[FindInfraOrthogonalRays]()[*g*, *c*, *len*]</code> gives a maximal set of mutually perpendicular rays from the vertex *c*, each a vertex list starting at *c*, the straightest set first.

<code>[FindInfraOrthogonalRays]()[*g*, *c*, *len*, *n*]</code> gives a list of *n* such sets.

## Details & Options

A ray at *c* is a shortest path from *c* with a length in *len*, maximal: its last vertex has no neighbour that prolongs it to a longer shortest path from *c* within *len*.

Two rays are perpendicular by the test of [FindInfraOrthogonalAxes](): *d(v, w) > max(d(c, v), d(c, w))* for all *v* on one and *w* on the other, both different from *c*.

The test cannot tell a right angle from a straight one, so a ray and its opposite pass it. The frame of the *d*-dimensional grid is *2d* rays, each direction with its negative.

At a path endpoint there is a ray and no axis. Two edges at *c* are perpendicular rays of length 1 exactly when their ends are not adjacent; at the centre of a star all edges are.

*len* is `All`, *k*, `UpTo[k]` or {*min*, *max*}. The count *n* can be `n`, `UpTo[n]` or `All`. *c* can be an association of vertices, as in [FindInfraOrthogonalAxes]().

Options:

| Option | Default | Values |
|---|---|---|
| [Properties]() | `Automatic` | as in [FindInfraOrthogonalAxes]() |
| `"NextVertexFunction"` | `Identity` | as in [FindInfraOrthogonalAxes]() |
| `"RayCount"` | `Automatic` | `Automatic` (maximal sets), *k* (sets of exactly *k* rays), `UpTo[k]`, `All` |

## Basic Examples

The rays of 3 steps from the centre. On the grid, the four rays of the straight frame; on the mesh, two rays:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {rays = FindInfraOrthogonalRays[g, c, 3]},
    InfraSubstrateHighlight[g, Append[InfraWalk /@ rays, c], PlotLabel -> Length[rays]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The frame of the grid of dimension *d* has *2d* rays:

```wl
Table[Length @ FindInfraOrthogonalRays[GridGraph[Table[5, d]], Ceiling[5^d/2], 2], {d, 2, 4}]
```

## Scope

At the endpoint of a path there is one ray and no axis; at an interior vertex the two rays are the halves of the one axis:

```wl
{FindInfraOrthogonalRays[PathGraph[Range[5]], 1, All], FindInfraOrthogonalAxes[PathGraph[Range[5]], 1, All],
 FindInfraOrthogonalRays[PathGraph[Range[5]], 3, All]}
```

At the centre of a star with 5 leaves, the 5 edges are perpendicular rays, and the axes are 2 pairs of them:

```wl
{FindInfraOrthogonalRays[StarGraph[6], 1, All], FindInfraOrthogonalAxes[StarGraph[6], 1, All]}
```

## Options

### RayCount

Sets of exactly two rays of length 2 at the centre of the grid, the first three:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {sets = FindInfraOrthogonalRays[g, 45, 2, 3, "RayCount" -> 2]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, Append[InfraWalk /@ set, 45]], {set, sets}]]
```

## Properties and Relations

The rays of the straight frame are the axes cut at *c*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {axes = FindInfraOrthogonalAxes[g, 45, 3], rays = FindInfraOrthogonalRays[g, 45, 3]},
  GraphicsRow[{InfraSubstrateHighlight[g, Append[InfraWalk /@ axes, 45], PlotLabel -> Length[axes]],
    InfraSubstrateHighlight[g, Append[InfraWalk /@ rays, 45], PlotLabel -> Length[rays]]}]]
```

The frame gives [OrthogonalCoordinates]() one coordinate per ray. The vertex 67, two steps along each axis from the centre, reads 2 on two rays and 0 on their opposites:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  OrthogonalCoordinates[g, 45, FindInfraOrthogonalRays[g, 45, 2], 67]]
```

## Possible Issues

The frame is not a basis: opposite rays are both members. The grid frame has 4 rays for 2 directions.
