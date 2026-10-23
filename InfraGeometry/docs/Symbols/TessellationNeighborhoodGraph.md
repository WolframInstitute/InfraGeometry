---
Template: Symbol
Name: TessellationNeighborhoodGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TessellationNeighborhoodGraph
Keywords: [tiling, tessellation, ball, patch, hyperbolic plane, Poincaré disk, sphere, uniform tiling, Archimedean tiling, Schläfli symbol]
SeeAlso: [TessellationGraph, TorusTessellation, InfraSubstrate, BoundarylessGraph, TessellationCurvature]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[TessellationNeighborhoodGraph]()[{*p*, *q*}, *r*]</code> gives the ball of radius *r* about a vertex of the regular tiling by *p*-gons, *q* at every vertex, with the coordinates of the tiling.

<code>[TessellationNeighborhoodGraph]()[{*f₁*, …, *fₖ*}, *r*]</code> gives the ball of radius *r* in the uniform tiling with that vertex configuration.

<code>[TessellationNeighborhoodGraph]()[{*p*, *q*}, {*m*, *n*}]</code> gives the patch of *m* × *n* cells of a Euclidean tiling.

<code>[TessellationNeighborhoodGraph]()[*spec*]</code> takes *r* = 3.

## Details & Options

With *T* the 1-skeleton of the infinite tiling and *v₀* the vertex nearest the origin, the result is the subgraph of *T* induced on *Bᵣ(v₀) = {v : d(v₀, v) ≤ r}*.

The tiling lies on the surface its [TessellationCurvature]() selects:

| (*p* − 2)(*q* − 2) | Surface | Coordinates |
|---|---|---|
| < 4 | sphere | the unit sphere in space |
| = 4 | plane | the plane, all edges of length 1 |
| > 4 | hyperbolic plane | the Poincaré disk |

On the sphere the tiling is finite, and from the diameter of the solid on the ball is the whole Platonic solid. In the plane the ball grows quadratically, in the hyperbolic plane exponentially.

The ball has a rim, where a vertex has fewer than *q* neighbours, and it does not wrap round as the closed maps of [TessellationGraph]() do. The tilings of [InfraSubstrate]() are such balls with the contour removed by [BoundarylessGraph]().

The Euclidean configurations {3, 6, 3, 6}, {3, 4, 6, 4}, {4, 6, 12}, {4, 8, 8}, {3, 12, 12} and the hyperbolic ones are built; a spherical one gives a ball of the Archimedean solid. Snub and elongated tilings are not built. [Graph]() options are passed on.

## Basic Examples

The ball of radius 3 in the tilings by triangles, five, six and seven at every vertex. On the sphere it is the whole icosahedron:

```wl
GraphicsRow @ Table[With[{g = TessellationNeighborhoodGraph[{3, q}, 3]}, Graph[g, PlotLabel -> VertexCount[g]]], {q, 5, 7}]
```

In the plane the balls grow like the square of the radius, in the hyperbolic plane exponentially:

```wl
ListLogPlot[Table[Table[VertexCount @ TessellationNeighborhoodGraph[{3, q}, r], {r, 6}], {q, {6, 7}}],
  Joined -> True, PlotMarkers -> Automatic, PlotLegends -> {"{3, 6}", "{3, 7}"}, AxesLabel -> {"r", "vertices"}]
```

## Scope

Balls of radius 5 in the rhombitrihexagonal tiling {3, 4, 6, 4}, the truncated square tiling {4, 8, 8} and the hyperbolic tiling {3, 4, 7, 4}:

```wl
GraphicsRow @ Table[TessellationNeighborhoodGraph[config, 5], {config, {{3, 4, 6, 4}, {4, 8, 8}, {3, 4, 7, 4}}}]
```

Patches of 4 × 3 cells: squares, rhombi of two triangles, hexagons:

```wl
GraphicsRow @ Table[TessellationNeighborhoodGraph[type, {4, 3}], {type, {{4, 4}, {3, 6}, {6, 3}}}]
```

## Properties and Relations

In the plane the ball has *2r² + 2r + 1* vertices for squares, *3r² + 3r + 1* for triangles and *3r(r + 1)/2 + 1* for hexagons:

```wl
Table[VertexCount @ TessellationNeighborhoodGraph[type, r], {type, {{4, 4}, {3, 6}, {6, 3}}}, {r, 6}] ==
  Transpose @ Table[{2 r^2 + 2 r + 1, 3 r^2 + 3 r + 1, 3 r (r + 1)/2 + 1}, {r, 6}]
```

From the diameter 5 of the dodecahedron on, the spherical ball is the dodecahedron:

```wl
IsomorphicGraphQ[TessellationNeighborhoodGraph[{5, 3}, 5], TessellationGraph[{5, 3}]]
```

## Possible Issues

In the hyperbolic plane the ball is about a corner of the tile at the centre of the disk, so it lies off the centre of the drawing:

```wl
Graph[TessellationNeighborhoodGraph[{4, 5}, 4], ImageSize -> Medium]
```

The snub and elongated tilings are not built, and the call stays unevaluated:

```wl
TessellationNeighborhoodGraph[{3, 3, 3, 4, 4}, 3]
```
