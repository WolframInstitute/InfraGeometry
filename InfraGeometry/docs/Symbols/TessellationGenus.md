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

<code>[TessellationGenus]()[*spec*, *k*]</code> gives the genus of the surface of the *k*-th map of type *spec*, a symbol {*p*, *q*} or a vertex configuration, from the type and the size of the map alone.

<code>[TessellationGenus]()[*spec*]</code> gives the genus of the first map.

<code>[TessellationGenus]()[*g*, *spec*]</code> gives the genus of the orientable closed surface that carries the map with graph *g* and type *spec*.

## Details & Options

Definition: the genus is (2 − *χ*)/2, *χ* the [TessellationEulerCharacteristic]() of the map: 0 for the sphere, 1 for the torus, the number of handles in general.

The maps of a type are counted as in [TessellationGraph](), so the *k*-th map is the map of [TessellationGraph]()[*spec*, *k*]. When every vertex has the configuration (*f*₁, …, *f*ₖ), *χ* = *V κ* with *κ* the [TessellationCurvature](), so the genus is 1 − *V κ*/2 and depends on the type and the number of vertices only.

For a symbol {*p*, *q*} the *k*-th map is a quotient *G* of the triangle group, with *V* = |*G*|/*q* vertices, so its genus is *g* = 1 + |*G*| (*pq* − 2*p* − 2*q*)/(4*pq*). The order |*G*| is all the sized form takes from the enumeration of the normal subgroups. A map of a Euclidean type is a torus, of genus 1 at every size; a spherical type has one map, of genus 0.

A uniform map is built on the *k*-th map of a regular parent type by rectification and truncation. These operations keep the surface, so the uniform map has the genus of its parent.

It is the genus of the surface of this map, which can exceed the least genus of a surface on which *g* can be drawn without crossings.

The formula presumes an orientable surface. Every map of [TessellationGraph]() is orientable.

## Basic Examples

The dodecahedron, a hexagonal torus and the Klein quartic: genus 0, 1 and 3, from the type and the size.

```wl
With[
  {maps = {TessellationGraph[{5, 3}], TessellationGraph[{6, 3}, 4], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], {TessellationGenus[{5, 3}], TessellationGenus[{6, 3}, 4], TessellationGenus[{3, 7}]}}]
```

The same genera read off the graphs with their types.

```wl
With[
  {specs = {{5, 3}, {6, 3}, {3, 7}}},
  {maps = {TessellationGraph[{5, 3}], TessellationGraph[{6, 3}, 4], TessellationGraph[{3, 7}]}},
  MapThread[TessellationGenus, {maps, specs}]]
```

## Scope

The first maps of seven to ten triangles at a vertex.

```wl
With[
  {genera = Table[{q, TessellationGenus[{3, q}]}, {q, 7, 10}]},
  {ListPlot[genera, AxesLabel -> {"q", "genus"}], genera}]
```

The first three maps {3, 7}, with 24, 72 and 156 vertices, have genus 3, 7 and 14.

```wl
With[
  {sizes = Table[{VertexCount @ TessellationGraph[{3, 7}, k], TessellationGenus[{3, 7}, k]}, {k, 3}]},
  {ListPlot[sizes, AxesLabel -> {"vertices", "genus"}], sizes}]
```

A uniform map lies on the surface of the map it is built on: the uniform maps {3, 7, 3, 7}, {3, 14, 14} and {4, 6, 14}, built on the first maps {3, 7} and {7, 3}, all lie on the Klein quartic, of genus 3.

```wl
With[
  {configs = {{3, 7, 3, 7}, {3, 14, 14}, {4, 6, 14}}},
  {GraphicsRow[TessellationGraph /@ configs], TessellationGenus /@ configs}]
```

## Properties and Relations

The genus of the *k*-th map is 1 − *V κ*/2: the first map {4, 6, 14} has 336 vertices of curvature −1/84.

```wl
With[
  {g = TessellationGraph[{4, 6, 14}]},
  {VertexCount[g], TessellationCurvature[{4, 6, 14}], 1 - VertexCount[g] TessellationCurvature[{4, 6, 14}]/2, TessellationGenus[{4, 6, 14}]}]
```

The genus is 1 − *χ*/2.

```wl
With[
  {g = TessellationGraph[{6, 3}, 4]},
  {g, TessellationGenus[g, {6, 3}] == 1 - TessellationEulerCharacteristic[g, {6, 3}]/2}]
```

## Possible Issues

A graph does not determine its map, so the type must be the map's. The first map {5, 5} has the graph of the icosahedron: read as {5, 5} it has genus 4, read as {3, 5} genus 0.

```wl
With[
  {g = TessellationGraph[{5, 5}]},
  {g, IsomorphicGraphQ[g, TessellationGraph[{3, 5}]], TessellationGenus[g, {5, 5}], TessellationGenus[g, {3, 5}]}]
```

The sized form counts the maps of [TessellationGraph](): past the order 1100 of the group, and past the one map of a spherical type, it stays unevaluated.

```wl
{TessellationGenus[{3, 7}, 5], TessellationGenus[{3, 7}, 6], TessellationGenus[{3, 5}, 2]}
```

The genus can exist where the graph does not. The truncation of the 2 × 2 square torus is a map on the torus, but its parent has multiple edges, and [TessellationGraph]() does not build it.

```wl
{TessellationGenus[{4, 8, 8}, 2], TessellationGraph[{4, 8, 8}, 2]}
```

On a surface that is not orientable the value is not the number of handles. The complete graph on six vertices is the graph of the hemi-icosahedron, a {3, 5} map on the projective plane, of Euler characteristic 1.

```wl
With[
  {g = CompleteGraph[6]},
  {g, TessellationEulerCharacteristic[g, {3, 5}], TessellationGenus[g, {3, 5}]}]
```
