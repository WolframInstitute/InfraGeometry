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

<code>[TessellationCurvature]()[{*f₁*, …, *fₖ*}]</code> gives the curvature at a vertex surrounded by faces with *f₁*, …, *fₖ* sides.

## Details & Options

At a vertex with faces of *f₁*, …, *fₖ* sides the combinatorial curvature is *κ = Σᵢ 1/fᵢ − (k − 2)/2*. For {*p*, *q*} it is *κ = (4 − (p − 2)(q − 2))/(2p)*.

When the faces are regular polygons, *2πκ* is the angle defect at the vertex: 2π less the sum of the face angles *π(1 − 2/fᵢ)*. The sign says where the tiling lives:

| *κ* | Geometry | Regular types |
|---|---|---|
| > 0 | sphere | the five Platonic solids |
| = 0 | plane, flat torus | {4, 4}, {3, 6}, {6, 3} |
| < 0 | hyperbolic plane | all others |

Discrete Gauss–Bonnet: on a closed map the curvatures of all vertices add up to the Euler characteristic *V − E + F*. When every vertex has the same configuration, *Vκ* is the [TessellationEulerCharacteristic]().

The curvature is a function of the configuration, not of a graph: one graph can carry maps of different types.

## Basic Examples

Five, six and seven triangles about a vertex, on the sphere, in the plane and in the hyperbolic plane:

```wl
GraphicsRow @ Table[
  With[{g = TessellationNeighborhoodGraph[{3, q}, 2]}, {c = First @ GraphCenter[g]},
    InfraSubstrateHighlight[g, {InfraBall[c, 1], c}, PlotLabel -> TessellationCurvature[{3, q}]]],
  {q, 5, 7}]
```

The curvature of the regular types {*p*, *q*} against *q*. It is *1 − q(1/2 − 1/p)*, linear in *q*, and zero only at {3, 6}, {4, 4} and {6, 3}:

```wl
ListLinePlot[Table[Table[{q, TessellationCurvature[{p, q}]}, {q, 3, 10}], {p, 3, 6}],
  PlotMarkers -> Automatic, PlotLegends -> {"p = 3", "p = 4", "p = 5", "p = 6"}, AxesLabel -> {"q", "κ"}]
```

## Scope

A configuration with two face sizes: two triangles and two squares at every vertex of the cuboctahedron:

```wl
Graph[TessellationGraph[{3, 4, 3, 4}], PlotLabel -> TessellationCurvature[{3, 4, 3, 4}], ImageSize -> Medium]
```

The uniform tilings {3, 6, 3, 6}, {4, 6, 12} and {3, 12, 12} of the plane are flat:

```wl
GraphicsRow @ Table[Graph[TessellationNeighborhoodGraph[config, 7], PlotLabel -> TessellationCurvature[config]],
  {config, {{3, 6, 3, 6}, {4, 6, 12}, {3, 12, 12}}}]
```

## Properties and Relations

Gauss–Bonnet: on the cube, the icosahedron, a square torus and the Klein quartic, the number of vertices times the curvature is the Euler characteristic, 2, 2, 0 and −4:

```wl
With[{specs = {{4, 3}, {3, 5}, {4, 4}, {3, 7}}},
  {maps = {TessellationGraph[{4, 3}], TessellationGraph[{3, 5}], TessellationGraph[{4, 4}, 6], TessellationGraph[{3, 7}]}},
  GraphicsRow @ MapThread[
    Graph[#1, PlotLabel -> {VertexCount[#1] TessellationCurvature[#2], TessellationEulerCharacteristic[#1, #2]}] &, {maps, specs}]]
```

So the genus is *1 − Vκ/2*: 3 for the Klein quartic, 24 vertices of curvature −1/6:

```wl
With[{g = TessellationGraph[{3, 7}]}, {VertexCount[g], 1 - VertexCount[g] TessellationCurvature[{3, 7}]/2, TessellationGenus[{3, 7}]}]
```

## Possible Issues

A list of two numbers is a symbol {*p*, *q*}, never a configuration of two faces. {5, 2} is the dihedron, two pentagons at every vertex, and {5, 5} five pentagons at every vertex:

```wl
{TessellationCurvature[{5, 2}], TessellationCurvature[{5, 5}]}
```
