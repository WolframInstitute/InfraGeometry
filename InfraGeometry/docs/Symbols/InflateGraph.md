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

<code>[InflateGraph]()[*g*, *k*]</code> grows a fiber of *k* new vertices over every vertex of *g*, joins each new vertex to its vertex, and adds random edges inside each fiber and between the fibers over each edge of *g*.

<code>[InflateGraph]()[*g*]</code> grows one new vertex over every vertex.

## Details & Options

Construction: over every vertex *v* of *g*, a fiber of new vertices <code>[InflatedVertex]()[*v*, 1]</code>, …, <code>[InflatedVertex]()[*v*, *k*]</code>, each joined to *v*. *k* is a number or a range {*min*, *max*}, drawn for each vertex.

An edge of the result is of one of four kinds:

- an edge of *g*
- a spoke, from a vertex to a vertex of its fiber
- a vertical edge, between two vertices of one fiber
- a horizontal edge, between the fibers over the two ends of an edge of *g*

`"VerticalEdges"` random pairs of each fiber are joined, and `"HorizontalEdges"` random pairs of the two fibers over each edge. Each is a number or a range {*min*, *max*}, drawn for each fiber and for each edge. A number larger than the pairs available joins them all.

The result is a simple graph. With *k*(*v*) new vertices over *v*, *m*(*v*) vertical edges in its fiber and *h*(*e*) horizontal edges over the edge *e*, it has |*V*| + Σ *k*(*v*) vertices and |*E*| + Σ *k*(*v*) + Σ *m*(*v*) + Σ *h*(*e*) edges.

The base graph is untouched: the subgraph induced on the vertices of *g* is *g*, and a new vertex is joined to no vertex of *g* but its own.

The fiber over *v* lies on a circle about *v* whose radius is a third of the shortest edge of *g*, in the dimension of the embedding of *g*.

The construction draws at random, so [SeedRandom]() fixes the result. [InfraSubstrate]() inflates any substrate through its option `"Inflate"`.

| Option | Default | |
|---|---|---|
| `"VerticalEdges"` | 0 | the random edges inside each fiber |
| `"HorizontalEdges"` | 1 | the random edges between the fibers over each edge |

[Graph]() options are passed on to the graph.

## Basic Examples

The discretized plane, the square tiling and the hexagonal tiling with two new vertices over every vertex: each vertex sits between the two vertices of its fiber, and the fibers over the ends of every edge are joined by one random edge.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    (SeedRandom[1]; InflateGraph[g, 2])],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Scope

The default: one new vertex over every vertex of the 6 × 6 grid, and one horizontal edge over every edge.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {inflated = InflateGraph[g]},
  {inflated, {VertexCount[inflated], EdgeCount[inflated]}}]
```

Between one and three new vertices over every vertex, drawn for each vertex.

```wl
With[
  {g = GridGraph[{6, 6}]},
  {inflated = (SeedRandom[1]; InflateGraph[g, {1, 3}])},
  {inflated, Counts[Length /@ GatherBy[Cases[VertexList[inflated], _InflatedVertex], First]] // KeySort}]
```

## Options

### VerticalEdges

Three new vertices over every vertex, with none, two and all three of the edges inside each fiber.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {inflated = Table[SeedRandom[1]; InflateGraph[g, 3, "VerticalEdges" -> m, "HorizontalEdges" -> 0], {m, {0, 2, 3}}]},
  {GraphicsRow[inflated], EdgeCount /@ inflated}]
```

A range is drawn for each fiber: between none and three edges.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {inflated = (SeedRandom[1]; InflateGraph[g, 3, "VerticalEdges" -> {0, 3}, "HorizontalEdges" -> 0])},
  {vertical = Cases[EdgeList[inflated], UndirectedEdge[InflatedVertex[v_, _], InflatedVertex[v_, _]] :> v]},
  {inflated, Lookup[Counts[vertical], VertexList[g], 0] // Counts // KeySort}]
```

### HorizontalEdges

Two new vertices over every vertex, with none, one and all four of the edges between the fibers over each edge.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {inflated = Table[SeedRandom[1]; InflateGraph[g, 2, "HorizontalEdges" -> h], {h, {0, 1, 4}}]},
  {GraphicsRow[inflated], EdgeCount /@ inflated}]
```

A range is drawn for each edge: between none and two edges.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {inflated = (SeedRandom[1]; InflateGraph[g, 2, "HorizontalEdges" -> {0, 2}])},
  {horizontal = Cases[EdgeList[inflated], UndirectedEdge[InflatedVertex[p_, _], InflatedVertex[q_, _]] /; p =!= q :> Sort[{p, q}]]},
  {inflated, Lookup[Counts[horizontal], Sort /@ List @@@ EdgeList[g], 0] // Counts // KeySort}]
```

## Properties and Relations

The base graph is the subgraph induced on its vertices.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = (SeedRandom[1]; InflateGraph[g, 2, "VerticalEdges" -> 1])},
  {InfraSubstrateHighlight[inflated, {VertexList[g]}], Sort[EdgeList[Subgraph[inflated, VertexList[g]]]] === Sort[EdgeList[g]]}]
```

The counts follow from the amounts: on the 3 × 3 grid, two new vertices over each of the 9 vertices, one vertical edge in each fiber and two horizontal edges over each of the 12 edges give 9 + 18 vertices and 12 + 18 + 9 + 24 edges.

```wl
With[
  {inflated = (SeedRandom[1]; InflateGraph[GridGraph[{3, 3}], 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2])},
  {inflated, {VertexCount[inflated], EdgeCount[inflated]}, SimpleGraphQ[inflated]}]
```

The default inflation is the prism over *g*, the product of *g* with an edge.

```wl
With[
  {g = CycleGraph[6]},
  {inflated = InflateGraph[g]},
  {inflated, IsomorphicGraphQ[inflated, GraphProduct[g, PathGraph[{1, 2}]]]}]
```

[RandomInfraFibration]() grows fibers with vertical edges too, but it keeps no base and no spokes, and its horizontal edges are a matching, not a draw. With one vertex over every vertex the two agree: the new vertices of the inflation span a copy of *g*, as the total graph of the fibration does.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {fibers = VertexDelete[InflateGraph[g], VertexList[g]]},
  {total = InfraTotalGraph[RandomInfraFibration[g]]},
  {GraphicsRow[{fibers, total}], IsomorphicGraphQ[fibers, total]}]
```

With two vertices over every vertex they differ: at its defaults the fibration joins vertex *i* over one end of an edge to vertex *i* over the other, while the inflation draws its horizontal edges at random.

```wl
With[
  {g = CycleGraph[8]},
  {fibers = (SeedRandom[1]; VertexDelete[InflateGraph[g, 2, "HorizontalEdges" -> 2], VertexList[g]])},
  {total = (SeedRandom[1]; InfraTotalGraph[RandomInfraFibration[g, "VerticalVertices" -> 2]])},
  GraphicsRow[{fibers, total}]]
```

The option `"Inflate"` of [InfraSubstrate]() is this inflation of the substrate: `"Inflate"` -> *k* is <code>[InflateGraph]()[*g*, *k*]</code>, and `"Inflate"` -> {*k*, *opts*} passes the options.

```wl
With[
  {inflated = (SeedRandom[1]; InfraSubstrate["SquareTilingGraph", "Small", "Default", "KeepCoordinates" -> True, "Inflate" -> {2, "VerticalEdges" -> 1}])},
  {direct = (SeedRandom[1]; InflateGraph[InfraSubstrate["SquareTilingGraph", "Small", "Default", "KeepCoordinates" -> True], 2, "VerticalEdges" -> 1])},
  {inflated, Sort[EdgeList[inflated]] === Sort[EdgeList[direct]]}]
```
