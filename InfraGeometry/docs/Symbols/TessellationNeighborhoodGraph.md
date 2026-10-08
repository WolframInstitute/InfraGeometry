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

<code>[TessellationNeighborhoodGraph]()[*config*, *r*]</code> gives the ball of radius *r* in the uniform tiling with vertex configuration *config*.

<code>[TessellationNeighborhoodGraph]()[{*p*, *q*}, {*m*, *n*}]</code> gives an *m* × *n* patch of a Euclidean tiling.

<code>[TessellationNeighborhoodGraph]()[{*p*, *q*}]</code> takes *r* = 3.

## Details & Options

Definition: let *T* be the 1-skeleton of the infinite tiling and *v₀* the vertex nearest the point the construction starts from, the origin of the plane or the disk, the north pole of the sphere. The result is the subgraph of *T* induced on the ball *B*ᵣ(*v₀*) = {*v* : *d*(*v₀*, *v*) ≤ *r*}, *d* the graph distance of *T*.

The tiling lies on the surface its curvature selects:

| (*p* − 2)(*q* − 2) | Surface | Coordinates |
|---|---|---|
| < 4 | the sphere | points of the unit sphere in space |
| = 4 | the plane | points of the plane, edges of one length |
| > 4 | the hyperbolic plane | points of the Poincaré disk |

On the sphere the tiling is finite. From the diameter of the solid on, the ball is the whole Platonic solid, the map <code>[TessellationGraph]()[{*p*, *q*}]</code>.

The ball has a rim: a vertex at distance *r* has fewer than *q* neighbours. Unlike the closed maps of [TessellationGraph](), it does not wrap round. The tilings `"SquareTilingGraph"`, `"TriangularTilingGraph"`, `"HexagonalTilingGraph"` and `"HyperbolicTilingGraph"` of [InfraSubstrate]() are such balls with the rim contour removed by [BoundarylessGraph]().

A vertex configuration lists the faces around a vertex in cyclic order: {3, 4, 6, 4} is the rhombitrihexagonal tiling. The Euclidean configurations {3, 6, 3, 6}, {3, 4, 6, 4}, {4, 6, 12}, {4, 8, 8}, {3, 12, 12} and the hyperbolic ones are built face by face around each vertex; a spherical one gives a ball of the Archimedean solid. The snub and elongated tilings are not built.

The rectangular form exists for the three Euclidean tilings. [Graph]() options are passed on to the graph.

## Basic Examples

The ball of radius 3 in the tilings by triangles, five, six and seven at every vertex: on the sphere it is the whole icosahedron, in the hyperbolic plane it has the most vertices.

```wl
With[
  {balls = Table[TessellationNeighborhoodGraph[{3, q}, 3], {q, 5, 7}]},
  {GraphicsRow[balls], VertexCount /@ balls}]
```

## Scope

Balls of radius 5 in the rhombitrihexagonal tiling {3, 4, 6, 4}, the truncated square tiling {4, 8, 8} and the hyperbolic tiling {3, 4, 7, 4}.

```wl
GraphicsRow @ Table[TessellationNeighborhoodGraph[config, 5], {config, {{3, 4, 6, 4}, {4, 8, 8}, {3, 4, 7, 4}}}]
```

On the sphere the ball closes up: radius 1, 2 and 3 in the icosahedral tiling.

```wl
With[
  {caps = Table[TessellationNeighborhoodGraph[{3, 5}, radius], {radius, 3}]},
  {GraphicsRow[caps], VertexCount /@ caps}]
```

## Properties and Relations

In the plane the ball grows like the square of the radius, in the hyperbolic plane exponentially. The vertex counts of the triangular tilings with six and seven triangles at a vertex:

```wl
ListLogPlot[
  Table[Table[{radius, VertexCount @ TessellationNeighborhoodGraph[{3, q}, radius]}, {radius, 5}], {q, {6, 7}}],
  Joined -> True, PlotLegends -> {"{3, 6}", "{3, 7}"}, AxesLabel -> {"r", "vertices"}]
```

In the plane the counts are 2*r*² + 2*r* + 1 for squares, 3*r*² + 3*r* + 1 for triangles and 3*r*(*r* + 1)/2 + 1 for hexagons.

```wl
With[
  {counts = Table[VertexCount @ TessellationNeighborhoodGraph[type, radius], {type, {{4, 4}, {3, 6}, {6, 3}}}, {radius, 6}]},
  {ListLinePlot[counts, PlotLegends -> {"{4, 4}", "{3, 6}", "{6, 3}"}, AxesLabel -> {"r", "vertices"}],
   counts == Transpose @ Table[{2 radius^2 + 2 radius + 1, 3 radius^2 + 3 radius + 1, 3 radius (radius + 1)/2 + 1}, {radius, 6}]}]
```

From the diameter of the solid on, the spherical ball is the Platonic solid of [TessellationGraph]().

```wl
With[
  {ball = TessellationNeighborhoodGraph[{5, 3}, 5]},
  {ball, IsomorphicGraphQ[ball, TessellationGraph[{5, 3}]]}]
```

The square tiling substrate is the ball of radius 7 with the rim contour removed.

```wl
With[
  {window = BoundarylessGraph[TessellationNeighborhoodGraph[{4, 4}, 7]]},
  {window, Sort[EdgeList[window]] === Sort[EdgeList @ InfraSubstrate["SquareTilingGraph", "Small"]]}]
```

## Possible Issues

In the hyperbolic plane the ball is about a corner of the tile at the centre of the disk, so it lies off the centre of the drawing.

```wl
TessellationNeighborhoodGraph[{4, 5}, 4]
```

The snub and elongated tilings are not built, and the call stays unevaluated.

```wl
TessellationNeighborhoodGraph[{3, 3, 3, 4, 4}, 3]
```

The rectangular patches count differently: the square patch has *m* × *n* vertices, the triangular and hexagonal patches *m* × *n* cells. The patches for {4, 3}:

```wl
With[
  {patches = Table[TessellationNeighborhoodGraph[type, {4, 3}], {type, {{4, 4}, {3, 6}, {6, 3}}}]},
  {GraphicsRow[patches], VertexCount /@ patches}]
```
