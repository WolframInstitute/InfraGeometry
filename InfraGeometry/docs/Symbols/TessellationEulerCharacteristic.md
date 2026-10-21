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

<code>[TessellationEulerCharacteristic]()[*g*, *spec*]</code> gives the Euler characteristic *V − E + F* of the closed map with graph *g* and type *spec*, a symbol {*p*, *q*} or a vertex configuration {*f₁*, …, *fₖ*}.

## Details & Options

The Euler characteristic is *χ = V − E + F*, with *V* and *E* the vertices and edges of *g*. The faces are counted through their corners: every vertex has one corner in each of its faces and a face with *f* sides has *f* corners, so *F = V Σᵢ 1/fᵢ*. A symbol {*p*, *q*} is *q* faces of *p* sides.

A closed orientable surface of genus *γ* has *χ = 2 − 2γ*: 2 on the sphere, 0 on the torus, negative on a hyperbolic surface. Discrete Gauss–Bonnet gives *χ = Vκ*, with *κ* the [TessellationCurvature]() at a vertex.

The count of faces holds on a closed map only, where every vertex has the whole configuration. The type is part of the map: a graph does not determine it.

## Basic Examples

The cube, a square torus and the smallest map of heptagons, three at every vertex:

```wl
With[{specs = {{4, 3}, {4, 4}, {7, 3}}},
  {maps = {TessellationGraph[{4, 3}], TessellationGraph[{4, 4}, 6], TessellationGraph[{7, 3}]}},
  GraphicsRow @ MapThread[Graph[#1, PlotLabel -> TessellationEulerCharacteristic[#1, #2]] &, {maps, specs}]]
```

The first three maps {3, 7}, with 24, 72 and 156 vertices. The Euler characteristic is *−V/6*:

```wl
Table[With[{m = TessellationGraph[{3, 7}, n]}, {VertexCount[m], TessellationEulerCharacteristic[m, {3, 7}]}], {n, 3}]
```

## Scope

A configuration with two face sizes: the truncated icosahedron, a pentagon and two hexagons at each of its 60 vertices:

```wl
With[{g = TessellationGraph[{5, 6, 6}]}, Graph[g, PlotLabel -> TessellationEulerCharacteristic[g, {5, 6, 6}], ImageSize -> Medium]]
```

## Properties and Relations

The Euler characteristic is *Vκ* and *2 − 2γ*, with *γ* the [TessellationGenus]() of the type and the size:

```wl
Table[With[{m = TessellationGraph[spec, 2]},
    {TessellationEulerCharacteristic[m, spec], VertexCount[m] TessellationCurvature[spec], 2 - 2 TessellationGenus[spec, 2]}],
  {spec, {{4, 4}, {3, 7}, {3, 8}}}]
```

## Possible Issues

The type must be the map's. The first map {5, 5}, twelve pentagons on a surface of genus 4, has the graph of the icosahedron; read as {3, 5}, the same graph gives the sphere:

```wl
With[{g = TessellationGraph[{5, 5}]},
  {IsomorphicGraphQ[g, TessellationGraph[{3, 5}]], TessellationEulerCharacteristic[g, {5, 5}], TessellationEulerCharacteristic[g, {3, 5}]}]
```

A ball cut from a tiling is not closed. Its rim vertices have fewer faces than the configuration says, and the value is not the Euler characteristic 1 of the disk:

```wl
TessellationEulerCharacteristic[TessellationNeighborhoodGraph[{4, 4}, 3], {4, 4}]
```
