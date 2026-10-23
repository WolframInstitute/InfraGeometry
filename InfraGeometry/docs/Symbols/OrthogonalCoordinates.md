---
Template: Symbol
Name: OrthogonalCoordinates
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/OrthogonalCoordinates
Keywords: [orthogonal coordinates, Cartesian coordinates, shortest-path projection, signed position, walks, tie, fibration]
SeeAlso: [FindInfraOrthogonalAxes, FindInfraOrthogonalRays, RadarCoordinates, InfraFibration, InfraBaseGraph, FindInfraPerpendicular]
RelatedGuides: [RiemannianInfrageometry]
---

## Usage

<code>[OrthogonalCoordinates]()[*g*, *c*, *walks*]</code> gives the association `<|v -> {x1, x2, …}|>` of the coordinates of every vertex *v* of *g*: the signed position of the projection of *v* on each walk, counted from the projection of *c*.

<code>[OrthogonalCoordinates]()[*g*, *c*, *walks*, *v*]</code> gives the coordinates of the vertex *v*.

## Details & Options

The projection of *v* on a walk is the set of walk vertices nearest to *v*. Its coordinate on the walk is the position of the projection minus the position of the projection of *c*: positive after it, negative before it.

These are Cartesian coordinates read off a frame. The walks are usually a set of [FindInfraOrthogonalAxes]() or [FindInfraOrthogonalRays](), but any vertex lists or walk graphs will do.

On the square grid, with the straight cross of half-length *k* through *c*, the coordinates are the grid coordinates of *v* relative to *c*, clipped to {−*k*, …, *k*}. A vertex beyond the cross projects to its nearest end.

*c* can be a vertex, a vertex list or an association. A centre of several vertices is projected as one set.

A projection of several vertices is reduced to one position by `"SelectCoordinate"`. The same function reduces the projection of *c*, so *c* reads 0 under [Median](), [Mean](), [Min]() or [Max]().

| Option | Default | Values |
|---|---|---|
| `"SelectCoordinate"` | [Median]() | a function of the list of tied positions; `All` keeps the list |

The result is a map from the vertices to the positions, and [InfraFibration]() fibres *g* over it.

## Basic Examples

The vertices whose first coordinate is 0, on the axis of 3 steps through the centre: on the grid the perpendicular line, on the mesh an irregular set:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {axis = First @ FindInfraOrthogonalAxes[g, c, 3]}, {coords = OrthogonalCoordinates[g, c, {axis}]},
    InfraSubstrateHighlight[g, {InfraWalk[axis], Select[VertexList[g], coords[#] == {0} &], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

On the cross of half-length 3 through the centre of the grid the coordinates are the grid coordinates. The centre, two neighbours and a vertex two steps along each axis:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {axes = FindInfraOrthogonalAxes[g, 45, 3]},
  Table[OrthogonalCoordinates[g, 45, axes, v], {v, {45, 46, 55, 67}}]]
```

The level sets of the first coordinate on the cross:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {axes = FindInfraOrthogonalAxes[g, 45, 3]},
  {coords = OrthogonalCoordinates[g, 45, axes]},
  {levels = Table[Select[VertexList[g], coords[#][[1]] == i &], {i, {-2, 0, 3}}]},
  InfraSubstrateHighlight[g, Join[InfraWalk /@ axes, levels], ImageSize -> Medium]]
```

## Scope

On the four rays of the grid frame each vertex has four coordinates, one per ray:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  OrthogonalCoordinates[g, 45, FindInfraOrthogonalRays[g, 45, 2], 67]]
```

A centre of two vertices sits between them:

```wl
OrthogonalCoordinates[PathGraph[Range[5]], {1, 2}, {{1, 2, 3, 4, 5}}]
```

## Options

### SelectCoordinate

On the 4-cycle with the walk 2, 1, 4, the vertex 3 is equally near to 2 and to 4. The rules read the tie differently:

```wl
Table[f -> OrthogonalCoordinates[CycleGraph[4], 1, {{2, 1, 4}}, "SelectCoordinate" -> f][3],
  {f, {Median, Min, Max, All}}]
```

## Properties and Relations

On the cross of half-length 3 the coordinates take the 49 values {−3, …, 3}², and the base of the fibration over them is a 7 × 7 grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {coords = OrthogonalCoordinates[g, 45, FindInfraOrthogonalAxes[g, 45, 3]]},
  {Length @ Union @ Values @ coords, VertexCount @ InfraBaseGraph @ InfraFibration[g, coords]}]
```

## Possible Issues

A vertex beyond the cross projects to the nearest end. On the grid the 8 vertices past the corner of the window all read {3, 3}:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {axes = FindInfraOrthogonalAxes[g, 45, 3]},
  {coords = OrthogonalCoordinates[g, 45, axes]},
  {corner = Select[VertexList[g], coords[#] == {3, 3} &]},
  InfraSubstrateHighlight[g, Append[InfraWalk /@ axes, corner], ImageSize -> Medium]]
```
