---
Template: Symbol
Name: TessellationGenus
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TessellationGenus
Keywords: [genus, closed surface, orientable surface, regular map, Euler characteristic, Klein quartic, Hurwitz surface]
SeeAlso: [TessellationEulerCharacteristic, TessellationCurvature, TessellationGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[TessellationGenus]()[*spec*, *k*]</code> gives the genus of the surface of the *k*-th map of type *spec*, a symbol {*p*, *q*} or a vertex configuration, as counted by [TessellationGraph]().

<code>[TessellationGenus]()[*spec*]</code> gives the genus of the first map.

<code>[TessellationGenus]()[*g*, *spec*]</code> gives *(2 − χ)/2* for the map with graph *g* and type *spec*: the genus of its surface when the surface is orientable.

## Details & Options

The genus is *γ = (2 − χ)/2*, with *χ* the [TessellationEulerCharacteristic]() of the map: 0 for the sphere, 1 for the torus, the number of handles in general.

With every vertex of curvature *κ*, *χ = Vκ*, so *γ = 1 − Vκ/2*. For {*p*, *q*} the *k*-th map comes from a quotient *G* of the (2, *p*, *q*) triangle group, with *V = |G|/q*, and *γ = 1 + |G|(pq − 2p − 2q)/(4pq)*.

| Type | Maps |
|---|---|
| spherical, *κ* > 0 | one map, genus 0 |
| Euclidean, *κ* = 0 | the *k* × *k* torus, genus 1 at every size |
| hyperbolic, *κ* < 0 | the quotients of order at most 1100, in increasing order |

A uniform map is built on a map of its regular parent type by rectification and truncation. These keep the surface, so the uniform map has the genus of its parent.

The genus of the map can exceed the least genus of a surface on which *g* embeds.

The form with a graph sees only *V*, *E* and *spec*, not whether the surface is orientable. On a non-orientable surface of Euler characteristic *χ* the value *(2 − χ)/2* is half its non-orientable genus *2 − χ*: a half-integer when that genus is odd, an integer, read like an orientable genus, when it is even.

## Basic Examples

The dodecahedron, a hexagonal torus and the Klein quartic:

```wl
GraphicsRow @ Table[Graph[TessellationGraph @@ m, PlotLabel -> TessellationGenus @@ m], {m, {{{5, 3}}, {{6, 3}, 4}, {{3, 7}}}}]
```

The same genera read off the graphs with their types:

```wl
MapThread[TessellationGenus,
  {{TessellationGraph[{5, 3}], TessellationGraph[{6, 3}, 4], TessellationGraph[{3, 7}]}, {{5, 3}, {6, 3}, {3, 7}}}]
```

## Scope

The first maps of seven to ten triangles at a vertex:

```wl
Table[{q, TessellationGenus[{3, q}]}, {q, 7, 10}]
```

The first maps {3, 7} have 24, 72 and 156 vertices and genus 3, 7 and 14:

```wl
Table[{VertexCount @ TessellationGraph[{3, 7}, k], TessellationGenus[{3, 7}, k]}, {k, 3}]
```

The uniform maps {3, 7, 3, 7}, {3, 14, 14} and {4, 6, 14} are built on the first map {3, 7} or {7, 3}, so they all lie on the Klein quartic:

```wl
GraphicsRow @ Table[Graph[TessellationGraph[config], PlotLabel -> TessellationGenus[config]],
  {config, {{3, 7, 3, 7}, {3, 14, 14}, {4, 6, 14}}}]
```

## Properties and Relations

The genus is *1 − Vκ/2*: the first map {4, 6, 14} has 336 vertices of curvature −1/84:

```wl
With[{g = TessellationGraph[{4, 6, 14}]}, {k = TessellationCurvature[{4, 6, 14}]},
  {VertexCount[g], k, 1 - VertexCount[g] k/2, TessellationGenus[{4, 6, 14}]}]
```

## Possible Issues

A graph does not determine its map. The first map {5, 5} has the graph of the icosahedron: read as {5, 5} it has genus 4, as {3, 5} genus 0:

```wl
With[{g = TessellationGraph[{5, 5}]},
  {IsomorphicGraphQ[g, TessellationGraph[{3, 5}]], TessellationGenus[g, {5, 5}], TessellationGenus[g, {3, 5}]}]
```

The sized form counts the maps of [TessellationGraph](). Past the one map of a spherical type it stays unevaluated:

```wl
TessellationGenus[{3, 5}, 2]
```

The genus can exist where the graph does not. The truncation of the 2 × 2 square torus lies on the torus, but its parent has multiple edges and [TessellationGraph]() does not build it:

```wl
{TessellationGenus[{4, 8, 8}, 2], TessellationGraph[{4, 8, 8}, 2]}
```

On a surface that is not orientable the value is not a number of handles. The complete graph on six vertices carries the hemi-icosahedron, a {3, 5} map on the projective plane, of Euler characteristic 1 and non-orientable genus 1, and the value is 1/2:

```wl
{TessellationEulerCharacteristic[CompleteGraph[6], {3, 5}], TessellationGenus[CompleteGraph[6], {3, 5}]}
```
