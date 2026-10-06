---
Template: Symbol
Name: TessellationCurvature
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TessellationCurvature
Keywords: [combinatorial curvature, angle defect, Gauss-Bonnet, tiling, regular map, vertex configuration, Schläfli symbol]
SeeAlso: [TessellationEulerCharacteristic, TessellationGenus, TessellationGraph, TessellationNeighborhoodGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[TessellationCurvature]()[{*p*, *q*}]</code> gives the combinatorial curvature at a vertex of the tiling by *p*-gons, *q* at every vertex.

<code>[TessellationCurvature]()[*config*]</code> gives the curvature at a vertex with the vertex configuration *config*.

<code>[TessellationCurvature]()[*g*]</code> reads a regular configuration off the graph *g* of a closed map.

## Details & Options

Definition: at a vertex surrounded by *k* faces with *f*₁, …, *f*ₖ sides, the combinatorial curvature is *κ = Σᵢ 1/fᵢ − (k − 2)/2*. For {*p*, *q*} it is *κ = q/p − (q − 2)/2 = (4 − (p − 2)(q − 2))/(2p)*.

When the faces are regular polygons, 2π*κ* is the angle defect at the vertex: 2π less the sum of the face angles π(1 − 2/*fᵢ*). Its sign says where the tiling lives: *κ* > 0 on the sphere, *κ* = 0 in the plane or on a flat torus, *κ* < 0 in the hyperbolic plane.

On a closed map the curvatures of the vertices add up to the Euler characteristic, a discrete Gauss–Bonnet theorem. Each face has *f* corners, each counted 1/*f*, so the first terms add up to *F*; the degrees add up to 2*E*, so the second terms add up to *E − V*. Hence the curvatures of all the vertices add up to *V − E + F*. When every vertex has the same configuration, *V κ* is the [TessellationEulerCharacteristic]().

The graph form reads the configuration as {*p*, *q*} with *p* the girth of *g*, the length of its shortest cycle, and *q* its least degree. That is right for a regular map whose faces are its shortest cycles.

## Basic Examples

Five, six and seven triangles about a vertex: on the sphere, in the plane and in the hyperbolic plane. The curvature is 1/6, 0 and −1/6, an angle defect of π/3, 0 and −π/3.

```wl
With[
  {stars = Table[With[{g = TessellationNeighborhoodGraph[{3, q}, 2]}, {c = InfraCenter[g]}, InfraSubstrateHighlight[g, {InfraBall[c, 1], c}]], {q, 5, 7}]},
  {GraphicsRow[stars], Table[TessellationCurvature[{3, q}], {q, 5, 7}]}]
```

The graph form on three closed maps: the icosahedron, a triangulated torus and the Klein quartic.

```wl
With[
  {maps = {TessellationGraph[{3, 5}], TessellationGraph[{3, 6}, 6], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], TessellationCurvature /@ maps}]
```

## Scope

The curvature of the regular tilings {*p*, *q*} against *q*. It is positive for the five Platonic solids, zero for {4, 4}, {3, 6} and {6, 3}, and negative everywhere else.

```wl
ListLinePlot[
  Table[Table[{q, TessellationCurvature[{p, q}]}, {q, 3, 10}], {p, 3, 6}],
  PlotLegends -> {"p = 3", "p = 4", "p = 5", "p = 6"}, AxesLabel -> {"q", "curvature"}]
```

The uniform tilings of the plane are flat: the trihexagonal tiling {3, 6, 3, 6}, the truncated trihexagonal tiling {4, 6, 12} and the truncated hexagonal tiling {3, 12, 12}.

```wl
With[
  {configs = {{3, 6, 3, 6}, {4, 6, 12}, {3, 12, 12}}},
  {GraphicsRow[TessellationNeighborhoodGraph[#, 7] & /@ configs], TessellationCurvature /@ configs}]
```

## Properties and Relations

On a closed map in which every vertex looks alike, the number of vertices times the curvature is the Euler characteristic: the cube, the icosahedron, a square torus and the Klein quartic.

```wl
With[
  {maps = {TessellationGraph[{4, 3}], TessellationGraph[{3, 5}], TessellationGraph[{4, 4}, 6], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], Table[{VertexCount[m] TessellationCurvature[m], TessellationEulerCharacteristic[m]}, {m, maps}]}]
```

## Possible Issues

A map with faces of several sizes needs its configuration: the cuboctahedron has two triangles and two squares at every vertex, curvature 1/6, but its girth 3 and degree 4 read as four triangles, 1/3.

```wl
With[
  {g = TessellationGraph[{3, 4, 3, 4}]},
  {g, TessellationCurvature[g], TessellationCurvature[{3, 4, 3, 4}]}]
```

On a small torus a cycle round the torus can be shorter than a face. The 3 × 3 square torus has girth 3, and the graph form reads it as curved.

```wl
With[
  {g = TessellationGraph[{4, 4}, 3]},
  {g, TessellationCurvature[g], TessellationCurvature[{4, 4}]}]
```
