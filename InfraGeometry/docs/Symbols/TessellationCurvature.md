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

## Details & Options

Definition: at a vertex surrounded by *k* faces with *f*₁, …, *f*ₖ sides, the combinatorial curvature is *κ = Σᵢ 1/fᵢ − (k − 2)/2*. For {*p*, *q*} it is *κ = q/p − (q − 2)/2 = (4 − (p − 2)(q − 2))/(2p)*.

When the faces are regular polygons, 2π*κ* is the angle defect at the vertex: 2π less the sum of the face angles π(1 − 2/*fᵢ*). Its sign says where the tiling lives: *κ* > 0 on the sphere, *κ* = 0 in the plane or on a flat torus, *κ* < 0 in the hyperbolic plane.

On a closed map the curvatures of the vertices add up to the Euler characteristic, a discrete Gauss–Bonnet theorem. Each face has *f* corners, each counted 1/*f*, so the first terms add up to *F*; the degrees add up to 2*E*, so the second terms add up to *E − V*. Hence the curvatures of all the vertices add up to *V − E + F*. When every vertex has the same configuration, *V κ* is the [TessellationEulerCharacteristic]().

The curvature is a function of the configuration. It is not read off a graph, since one graph can carry maps of different types.

## Basic Examples

Five, six and seven triangles about a vertex: on the sphere, in the plane and in the hyperbolic plane. The curvature is 1/6, 0 and −1/6, an angle defect of π/3, 0 and −π/3.

```wl
With[
  {stars = Table[With[{g = TessellationNeighborhoodGraph[{3, q}, 2]}, {c = First @ GraphCenter[g]}, InfraSubstrateHighlight[g, {InfraBall[c, 1], c}]], {q, 5, 7}]},
  {GraphicsRow[stars], Table[TessellationCurvature[{3, q}], {q, 5, 7}]}]
```

A vertex configuration with two face sizes: two triangles and two squares at every vertex of the cuboctahedron, curvature 1/6.

```wl
With[
  {g = TessellationGraph[{3, 4, 3, 4}]},
  {g, TessellationCurvature[{3, 4, 3, 4}]}]
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
  {specs = {{4, 3}, {3, 5}, {4, 4}, {3, 7}}},
  {maps = {TessellationGraph[{4, 3}], TessellationGraph[{3, 5}], TessellationGraph[{4, 4}, 6], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], MapThread[{VertexCount[#1] TessellationCurvature[#2], TessellationEulerCharacteristic[#1, #2]} &, {maps, specs}]}]
```

So the genus of a map is 1 − *V κ*/2, the [TessellationGenus]() of its type and size: 3 for the Klein quartic, 24 vertices of curvature −1/6.

```wl
With[
  {g = TessellationGraph[{3, 7}]},
  {g, 1 - VertexCount[g] TessellationCurvature[{3, 7}]/2, TessellationGenus[{3, 7}, 1]}]
```

## Possible Issues

A list of two numbers is a symbol {*p*, *q*}, never a configuration of two faces. The dihedron {5, 2} has two pentagons at every vertex, while {5, 5} is the type with five pentagons at every vertex.

```wl
With[
  {g = TessellationGraph[{5, 2}]},
  {g, TessellationCurvature[{5, 2}], TessellationCurvature[{5, 5}]}]
```
