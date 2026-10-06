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

<code>[TessellationGenus]()[*g*, *spec*]</code> gives the genus of the orientable closed surface that carries the map with graph *g* and type *spec*: a symbol {*p*, *q*} or a vertex configuration.

<code>[TessellationGenus]()[*g*]</code> reads the type off *g* as for a regular map.

## Details & Options

Definition: the genus is (2 − *χ*)/2, *χ* the [TessellationEulerCharacteristic]() of the map: 0 for the sphere, 1 for the torus, the number of handles in general.

It is the genus of the surface of this map, which can exceed the least genus of a surface on which *g* can be drawn without crossings.

The formula presumes an orientable surface. Every map of [TessellationGraph]() is orientable.

The graph form takes the type {*p*, *q*} with *p* the girth of *g* and *q* its least degree, as [TessellationCurvature]() does.

## Basic Examples

The dodecahedron, a hexagonal torus and the Klein quartic: genus 0, 1 and 3.

```wl
With[
  {maps = {TessellationGraph[{5, 3}], TessellationGraph[{6, 3}, 4], TessellationGraph[{3, 7}]}},
  {GraphicsRow[maps], TessellationGenus /@ maps}]
```

## Scope

The smallest maps of seven to ten triangles at a vertex.

```wl
With[
  {genera = Table[{q, TessellationGenus @ TessellationGraph[{3, q}]}, {q, 7, 10}]},
  {ListPlot[genera, AxesLabel -> {"q", "genus"}], genera}]
```

The first three maps {3, 7} of [TessellationGraph](), with 24, 156 and 1740 vertices, have genus 3, 14 and 146.

```wl
With[
  {sizes = Table[With[{m = TessellationGraph[{3, 7}, n]}, {VertexCount[m], TessellationGenus[m]}], {n, 3}]},
  {ListLogLogPlot[sizes, AxesLabel -> {"vertices", "genus"}], sizes}]
```

## Properties and Relations

The genus is 1 − *χ*/2.

```wl
With[
  {g = TessellationGraph[{6, 3}, 4]},
  {g, TessellationGenus[g] == 1 - TessellationEulerCharacteristic[g]/2}]
```

## Possible Issues

A graph does not determine its map. The smallest map {5, 5}, of genus 4, has the graph of the icosahedron, whose girth 3 reads as triangles and genus 0.

```wl
With[
  {g = TessellationGraph[{5, 5}]},
  {g, IsomorphicGraphQ[g, TessellationGraph[{3, 5}]], TessellationGenus[g], TessellationGenus[g, {5, 5}]}]
```

On a surface that is not orientable the value is not the number of handles. The complete graph on six vertices is the graph of the hemi-icosahedron, a {3, 5} map on the projective plane, of Euler characteristic 1.

```wl
With[
  {g = CompleteGraph[6]},
  {g, TessellationEulerCharacteristic[g, {3, 5}], TessellationGenus[g, {3, 5}]}]
```
