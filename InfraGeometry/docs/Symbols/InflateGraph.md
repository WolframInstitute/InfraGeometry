---
Template: Symbol
Name: InflateGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InflateGraph
Keywords: [inflation, fiber, random graph, perturbation, noise, substrate]
SeeAlso: [InflatedVertex, InfraSubstrate, InfraSubstrateCode]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InflateGraph]()[*g*]</code> grows a fiber of new vertices over every vertex of *g*, joins each new vertex to its base vertex, and adds random edges from every fiber to the vertices nearby.

## Details & Options

Construction: over every vertex *v* of *g*, a fiber of *k* new vertices <code>[InflatedVertex]()[*v*, 1]</code>, …, <code>[InflatedVertex]()[*v*, *k*]</code>, each joined to *v*, with *k* drawn from `"ExtraVertices"`. Inside each fiber, `"ExtraEdges"` random pairs are joined. Then let *N* be the vertices of *g* within `"Radius"` of *v* and *R* the new vertices over them: a random sample of the pairs of a vertex of the fiber of *v* and a vertex of *N* ∪ *R* is joined, of a random size between 0 and *density* |*R*| / |*N*|, rounded.

`"ExtraVertices"` and `"ExtraEdges"` take a number or a range {*min*, *max*}, drawn for each vertex of *g*; `"Radius"` is drawn once.

The base graph is untouched: the subgraph induced on the vertices of *g* is *g*. A new vertex is placed at a random point near its base vertex, within 0.3 of the mean edge length.

The construction draws at random, so [SeedRandom]() fixes the result. [InfraSubstrate]() inflates any substrate through its option `"Inflate"`.

| Option | Default | |
|---|---|---|
| `"ExtraVertices"` | {0, 2} | the size of each fiber |
| `"ExtraEdges"` | 0 | the random edges inside each fiber |
| `"Radius"` | 1 | how far in *g* a fiber reaches |
| `"Density"` | 1 | the scale of the number of random edges from a fiber |

[Graph]() options are passed on to the graph.

## Basic Examples

The discretized plane, the square tiling and the hexagonal tiling with one new vertex over every vertex, the new vertices drawn red.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {inflated = (SeedRandom[1]; InflateGraph[g, "ExtraVertices" -> 1])},
    InfraSubstrateHighlight[inflated, {Cases[VertexList[inflated], _InflatedVertex]}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Scope

The default: between none and two new vertices over every vertex of the 6 × 6 grid.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {inflated = (SeedRandom[1]; InflateGraph[g])},
  {inflated, VertexCount[inflated] - VertexCount[g]}]
```

## Options

### ExtraVertices

One, two and between none and three new vertices over every vertex.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {inflated = Table[SeedRandom[1]; InflateGraph[g, "ExtraVertices" -> amount], {amount, {1, 2, {0, 3}}}]},
  {GraphicsRow[inflated], VertexCount /@ inflated}]
```

### Radius

A larger radius joins the fibers to vertices farther away: radius 1 and 3.

```wl
With[
  {g = GridGraph[{6, 6}]},
  GraphicsRow @ Table[SeedRandom[1]; InflateGraph[g, "ExtraVertices" -> 1, "Radius" -> radius], {radius, {1, 3}}]]
```

### Density

With density 0 a fiber is joined only to its base vertex.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {inflated = Table[SeedRandom[1]; InflateGraph[g, "ExtraVertices" -> 1, "Density" -> density], {density, {0, 1, 3}}]},
  {GraphicsRow[inflated], EdgeCount /@ inflated}]
```

## Properties and Relations

The base graph is the subgraph induced on its vertices.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = (SeedRandom[1]; InflateGraph[g])},
  {InfraSubstrateHighlight[inflated, {VertexList[g]}], Sort[EdgeList[Subgraph[inflated, VertexList[g]]]] === Sort[EdgeList[g]]}]
```

The option `"Inflate"` of [InfraSubstrate]() is this inflation of the substrate.

```wl
With[
  {inflated = (SeedRandom[1]; InfraSubstrate["SquareTilingGraph", "Small", "Default", "KeepCoordinates" -> True, "Inflate" -> 1])},
  {direct = (SeedRandom[1]; InflateGraph[InfraSubstrate["SquareTilingGraph", "Small", "Default", "KeepCoordinates" -> True], "ExtraVertices" -> 1])},
  {inflated, Sort[EdgeList[inflated]] === Sort[EdgeList[direct]]}]
```

## Possible Issues

A random edge can repeat an edge already drawn, so the result can have multiple edges.

```wl
With[
  {inflated = (SeedRandom[1]; InflateGraph[GridGraph[{6, 6}]])},
  {inflated, MultigraphQ[inflated], EdgeCount[inflated], EdgeCount[SimpleGraph[inflated]]}]
```
