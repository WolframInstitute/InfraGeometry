---
Template: Symbol
Name: InflateGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InflateGraph
Keywords: [inflation, fiber, vertical edge, horizontal edge, random graph, perturbation, noise, substrate]
SeeAlso: [InflatedVertex, InfraSubstrate, InfraSubstrateCode, RandomInfraFibration]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InflateGraph]()[*g*, *k*]</code> grows a fiber of *k* new vertices over every vertex of *g*, joins each to its vertex, and adds random edges inside each fiber and between the fibers over each edge of *g*.

<code>[InflateGraph]()[*g*]</code> grows one new vertex over every vertex.

## Details & Options

The fiber *F(v)* over *v* is the set of new vertices <code>[InflatedVertex]()[*v*, 1]</code>, …, <code>[InflatedVertex]()[*v*, *k*]</code>. The count *k* is a number or a range {*kMin*, *kMax*}, drawn for each vertex.

An edge of the result is of one of four kinds:

| Kind | Joins |
|---|---|
| base | the two ends of an edge of *g* |
| spoke | *v* and a vertex of *F(v)* |
| vertical | two vertices of one fiber |
| horizontal | a vertex of *F(u)* and a vertex of *F(v)*, for an edge *uv* of *g* |

The result is a simple graph with *|V| + Σ k(v)* vertices and *|E| + Σ k(v) + Σ m(v) + Σ h(e)* edges, where *m(v)* and *h(e)* are the vertical edges in *F(v)* and the horizontal edges over *e*.

The inflation is a perturbation that keeps the geometry of *g*. A new vertex is at distance 1 from its base vertex, and the distance between two vertices of *g* does not change.

| Option | Default | Values |
|---|---|---|
| `"VerticalEdges"` | 0 | the random pairs of each fiber joined: a number or {*min*, *max*}, drawn for each fiber |
| `"HorizontalEdges"` | 1 | the random pairs of the two fibers over each edge joined, drawn for each edge |

A number larger than the pairs available joins them all. [Graph]() options are passed on.

The construction uses the current random state, so [SeedRandom]() or [BlockRandom]() fixes it. [InfraSubstrate]() inflates any substrate through its option `"Inflate"`.

## Basic Examples

The square grid and the square mesh with two new vertices over every vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    BlockRandom[InflateGraph[g, 2], RandomSeeding -> 1]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The counts follow from the amounts. The grid has 96 vertices and 144 edges; two new vertices over each, one vertical edge per fiber and two horizontal edges per edge give 96 + 192 vertices and 144 + 192 + 96 + 288 edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = BlockRandom[InflateGraph[g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2], RandomSeeding -> 1]},
  InfraSubstrateHighlight[inflated, {VertexList[g]},
    PlotLabel -> {VertexCount[inflated], EdgeCount[inflated]}, ImageSize -> Medium]]
```

## Scope

Fibers of one to three vertices on the mesh, and how many of each size:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = BlockRandom[InflateGraph[g, {1, 3}], RandomSeeding -> 1]},
  InfraSubstrateHighlight[inflated, {VertexList[g]},
    PlotLabel -> KeySort @ Counts[Length /@ GatherBy[Cases[VertexList[inflated], _InflatedVertex], First]], ImageSize -> Medium]]
```

## Options

### VerticalEdges

Three new vertices over every vertex of a 4 × 4 grid, with none, one and all three edges inside each fiber:

```wl
GraphicsRow @ Table[
  With[{g = BlockRandom[InflateGraph[GridGraph[{4, 4}], 3, "VerticalEdges" -> m, "HorizontalEdges" -> 0], RandomSeeding -> 1]},
    Graph[g, PlotLabel -> EdgeCount[g]]],
  {m, {0, 1, 3}}]
```

### HorizontalEdges

Two new vertices over every vertex, with none, one and all four edges between the fibers over each edge:

```wl
GraphicsRow @ Table[
  With[{g = BlockRandom[InflateGraph[GridGraph[{4, 4}], 2, "HorizontalEdges" -> h], RandomSeeding -> 1]},
    Graph[g, PlotLabel -> EdgeCount[g]]],
  {h, {0, 1, 4}}]
```

## Properties and Relations

The distances of *g* do not change. The ball of radius 3 about the centre of the inflated grid meets the grid in the ball of the grid:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {inflated = BlockRandom[InflateGraph[g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2], RandomSeeding -> 1]},
  {ball = Keys @ InfraMeasurement[inflated, InfraBall[c, 3], "VertexDensity"]},
  InfraSubstrateHighlight[inflated, {ball, c},
    PlotLabel -> (Intersection[ball, VertexList[g]] === Sort @ Keys @ InfraMeasurement[g, InfraBall[c, 3], "VertexDensity"]),
    ImageSize -> Medium]]
```

The default inflation is the prism over *g*, the product of *g* with an edge:

```wl
IsomorphicGraphQ[InflateGraph[CycleGraph[6]], GraphProduct[CycleGraph[6], PathGraph[{1, 2}]]]
```

The option `"Inflate"` of [InfraSubstrate]() is this inflation of the substrate:

```wl
With[{opts = Sequence["Default", "KeepCoordinates" -> True]},
  BlockRandom[InfraSubstrate["SquareMeshGraph", "Small", opts, "Inflate" -> {2, "VerticalEdges" -> 1}], RandomSeeding -> 1] ===
    BlockRandom[InflateGraph[InfraSubstrate["SquareMeshGraph", "Small", opts], 2, "VerticalEdges" -> 1], RandomSeeding -> 1]]
```
