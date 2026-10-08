---
Template: Symbol
Name: OrthogonalCoordinates
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/OrthogonalCoordinates
Keywords: [orthogonal coordinates, Cartesian coordinates, shortest-path projection, signed position, walks, tie, fibration]
SeeAlso: [FindInfraOrthogonalAxes, FindInfraOrthogonalRays, RadarCoordinates, ResistanceCoordinates, InfraFibration, InfraBaseGraph, FindInfraPerpendicular]
RelatedGuides: [Experimental]
---

## Usage

<code>[OrthogonalCoordinates]()[*g*, *c*, *walks*]</code> gives the association `<|v -> {i, j, ...}|>` over the vertices of *g*: the signed position of the shortest-path projection of *v* on each walk, counted from the projection of *c*.

<code>[OrthogonalCoordinates]()[*g*, *c*, *walks*, *v*]</code> gives the coordinates `{i, j, ...}` of the vertex *v*.

## Details & Options

- A **walk** is a vertex list `{w0, w1, ..., wk}`, such as a set of [FindInfraOrthogonalAxes]() or [FindInfraOrthogonalRays](); a walk graph is read as its vertex sequence. The walks need not be perpendicular, and need not pass through *c*: the coordinates are defined for any list of walks.
- The **projection** of a vertex *v* on a walk is the set of walk vertices nearest to *v* by the shortest-path distance. The coordinate of *v* on the walk is the position of its projection, counted from the projection of *c*, with the order of the walk as the sign: a position after the projection of *c* is positive, a position before it negative, and reversing a walk flips the sign.
- *c* is a vertex, a vertex list or an association `<| v1 -> w1, ... |>` with the weights ignored. Its support is projected like a vertex, the distance to a walk vertex being the least over the support. The centre of two vertices on a walk sits between them: on the walk `{1, 2, 3}` the centre `{1, 2}` is at `1/2` and the vertex 3 at `3/2`.
- On the walks of one set of [FindInfraOrthogonalAxes]() a vertex of one walk has the coordinate 0 on every other walk, with no tie, since *c* is the only nearest vertex of each walk to the other. A vertex off the walks can still have a tie, near a bent axis.
- The result is a map from the vertices of *g* to the grid of positions. It is a projection for [InfraFibration](): `InfraFibration[g, OrthogonalCoordinates[g, c, walks]]` fibres *g* over the positions that occur, and `InfraBaseGraph` of it is the grid.
- One `GraphDistance` row per walk vertex is computed; the projections are read off those rows.

| Option | Default | Values |
|---|---|---|
| `"SelectCoordinate"` | `Median` | the function that reduces a tied projection to one position; `All` keeps them |

The projection of a vertex can have several vertices. `"SelectCoordinate" -> f` applies *f* to the list of their positions, and the same *f* reduces the projection of the centre, so the centre reads 0 under every translation-equivariant *f*: `Median`, `Mean`, `Min`, `Max`, `First`, `Last`. `All` keeps the positions, so a coordinate is a list of them.

## Basic Examples

The coordinates of the 9 x 9 grid on the straight cross through its centre: the centre 41 reads `{0, 0}`, the vertex 42 `{0, 1}` and the vertex 50 `{1, 0}`.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axes = FindInfraOrthogonalAxes[g, 41, 4]},
  {coords = OrthogonalCoordinates[g, 41, axes]},
  {{coords[41], coords[42], coords[50]}, Union @ Values @ coords === Tuples[Range[-4, 4], 2]}]
```

The same, for one vertex.

```wl
With[
  {g = GridGraph[{9, 9}]},
  OrthogonalCoordinates[g, 41, FindInfraOrthogonalAxes[g, 41, 4], 52]]
```

The level sets of the first coordinate: the vertices with the same position on the first axis, a line of the grid.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {axes = FindInfraOrthogonalAxes[g, 41, 4]},
  {coords = OrthogonalCoordinates[g, 41, axes]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {Append[axes, {41}], Select[VertexList @ g, coords[#][[1]] == i &]}],
    {i, {-2, 0, 3}}]]
```

## Scope

Any list of walks: two walks that cross at a vertex other than *c*, or are not perpendicular, give coordinates all the same, here a skew pair on the 9 x 9 grid.

```wl
With[
  {g = GridGraph[{9, 9}]},
  {walks = {{41, 42, 43, 44, 45}, {41, 50, 59, 68, 77}}},
  OrthogonalCoordinates[g, 41, walks][[{1, 41, 45, 81}]]]
```

The coordinates of the rays: each axis is read twice, as its positive and its negative part, and a vertex keeps its own position on each.

```wl
With[
  {g = GridGraph[{5, 5}]},
  {rays = FindInfraOrthogonalRays[g, 13, 2]},
  OrthogonalCoordinates[g, 13, rays, 15]]
```

A centre of two vertices: the origin on a walk is the projection of the whole support.

```wl
OrthogonalCoordinates[PathGraph[Range[5]], {1, 2}, {{1, 2, 3, 4, 5}}]
```

## Options

### SelectCoordinate

On the 4-cycle the walk through the vertex 1 is `{2, 1, 4}`, and the antipode 3 is at the same distance from 2 and from 4. `Median` puts it at 0, with the centre, as does `Mean`; `Min` and `Max` put it at an end; `All` shows the tie. A rule symmetric under reversing the walk identifies the antipode with the centre: the tie is a property of the cycle, not of the rule.

```wl
Table[
  OrthogonalCoordinates[CycleGraph[4], 1, {{2, 1, 4}}, "SelectCoordinate" -> f][3],
  {f, {Median, Min, Max, All}}]
```

A vertex nearest to two neighbouring walk vertices has a half-integer coordinate under `Median`: the vertex 4 of the 4-cycle is nearest to 3 and to 1 on the walk `{3, 1, 2}`.

```wl
OrthogonalCoordinates[CycleGraph[4], 1, {{3, 1, 2}}][4]
```

## Properties and Relations

The coordinates over the cross of half-length 4 are a bijection of the 9 x 9 grid onto `{-4, ..., 4}^2`, so the fibration over them has the grid as its base and is trivial. Over the cross of half-length 2 a vertex beyond the window projects to the nearest end: the base is the 5 x 5 grid and its fibres are 3 x 3 blocks over the corners.

```wl
With[
  {g = GridGraph[{9, 9}]},
  GraphicsRow @ Table[
    With[
      {fib = InfraFibration[g, OrthogonalCoordinates[g, 41, FindInfraOrthogonalAxes[g, 41, len]]]},
      Labeled[InfraBaseGraph @ fib, VertexCount @ InfraBaseGraph @ fib]],
    {len, {4, 2}}]]
```

[RadarCoordinates]() are distances to a basis, positive and unsigned; the orthogonal coordinates are signed positions along walks. On a path with the endpoint as the walk they agree.

```wl
With[
  {g = PathGraph[Range[6]]},
  {OrthogonalCoordinates[g, 1, {Range[6]}], RadarCoordinates[g, {1}]}]
```

## Possible Issues

The coordinates of a vertex off every walk are the positions of its nearest walk vertices, not of a point in a geometric chart; a vertex far from the walks is projected onto the walls of the cross, and the fibres over the boundary of the grid are large.

On a graph with several shortest paths from *v* to the walk, the projection is the set of nearest walk vertices, not of the paths; that is the tie of `"SelectCoordinate"`.
