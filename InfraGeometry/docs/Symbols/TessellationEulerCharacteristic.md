---
Template: Symbol
Name: TessellationEulerCharacteristic
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TessellationEulerCharacteristic
Keywords: [Euler characteristic, closed surface, regular map, Gauss-Bonnet, tiling, vertex configuration]
SeeAlso: [TessellationGenus, TessellationCurvature, TessellationGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[TessellationEulerCharacteristic]()[*g*, *spec*]</code> gives the Euler characteristic *V* − *E* + *F* of the closed map with graph *g* and type *spec*: a symbol {*p*, *q*} or a vertex configuration.

<code>[TessellationEulerCharacteristic]()[*g*]</code> reads the type off *g* as for a regular map.

## Details & Options

Definition: *χ = V − E + F*, with *V* and *E* the vertices and edges of *g*. The faces are counted through their corners: when every vertex has faces of *f*₁, …, *f*ₖ sides, each vertex has one corner in each, and a face with *f* sides has *f* corners, so *F = V Σᵢ 1/fᵢ*. A symbol {*p*, *q*} is *q* faces of *p* sides.

The surface of a closed orientable map of genus *g* has *χ* = 2 − 2*g*: 2 on the sphere, 0 on the torus, negative on a hyperbolic surface. It equals *V κ*, *κ* the [TessellationCurvature]() at a vertex.

The count of faces through corners holds on a closed map, where every vertex has the whole configuration.

The graph form takes the type {*p*, *q*} with *p* the girth of *g* and *q* its least degree, as [TessellationCurvature]() does.

## Basic Examples

The cube, a square torus and the smallest map of heptagons, three at every vertex: Euler characteristic 2, 0 and −4.

```wl
With[
  {maps = {TessellationGraph[{4, 3}], TessellationGraph[{4, 4}, 6], TessellationGraph[{7, 3}]}},
  {GraphicsRow[maps], TessellationEulerCharacteristic /@ maps}]
```

## Scope

A map with faces of several sizes, given its configuration: the truncated icosahedron, with a pentagon and two hexagons at every vertex.

```wl
With[
  {g = TessellationGraph[{5, 6, 6}]},
  {g, TessellationEulerCharacteristic[g, {5, 6, 6}]}]
```

The first three maps {3, 7} of [TessellationGraph](), with 24, 156 and 1740 vertices: the Euler characteristic is −*V*/6.

```wl
With[
  {sizes = Table[With[{m = TessellationGraph[{3, 7}, n]}, {VertexCount[m], TessellationEulerCharacteristic[m]}], {n, 3}]},
  {ListPlot[sizes, AxesLabel -> {"vertices", "Euler characteristic"}], sizes}]
```

## Properties and Relations

The Euler characteristic is the number of vertices times the curvature at a vertex.

```wl
With[
  {maps = {TessellationGraph[{3, 4}], TessellationGraph[{3, 6}, 6], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], Table[{TessellationEulerCharacteristic[m], VertexCount[m] TessellationCurvature[m]}, {m, maps}]}]
```

It is 2 − 2*g*, *g* the [TessellationGenus]().

```wl
With[
  {g = TessellationGraph[{3, 7}]},
  {g, TessellationEulerCharacteristic[g] == 2 - 2 TessellationGenus[g]}]
```

## Possible Issues

A map with faces of several sizes needs its configuration. The girth of the truncated icosahedron is 5, and the graph form counts pentagons only.

```wl
With[
  {g = TessellationGraph[{5, 6, 6}]},
  {g, TessellationEulerCharacteristic[g], TessellationEulerCharacteristic[g, {5, 6, 6}]}]
```

A ball cut from a tiling is not closed: its rim vertices have fewer faces than the configuration says, and the value is not the Euler characteristic 1 of the disk.

```wl
With[
  {g = TessellationNeighborhoodGraph[{4, 4}, 3]},
  {g, TessellationEulerCharacteristic[g, {4, 4}]}]
```
