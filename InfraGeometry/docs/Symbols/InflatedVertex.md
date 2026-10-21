---
Template: Symbol
Name: InflatedVertex
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InflatedVertex
Keywords: [inflation, fiber, vertex name, base vertex, projection]
SeeAlso: [InflateGraph, InfraSubstrate]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[InflatedVertex]()[*v*, *i*]</code> is the *i*-th vertex of the fiber over the vertex *v* in a graph made by [InflateGraph]().

## Details & Options

[InflatedVertex]() is inert: it names a vertex and does not evaluate.

The fiber *F(v)* over *v* is the set of the vertices <code>[InflatedVertex]()[*v*, *i*]</code>. The projection *π* onto the base graph sends <code>[InflatedVertex]()[*v*, *i*]</code> to *v* and fixes the vertices of the base.

*π* maps every edge to an edge of the base or to a loop: a spoke and a vertical edge collapse to a loop at *v*, a horizontal edge onto the edge below it.

Inflating an inflated graph nests the names: the fiber over <code>[InflatedVertex]()[*v*, *i*]</code> has the vertices <code>[InflatedVertex]()[[InflatedVertex]()[*v*, *i*], *j*]</code>. Over a vertex of the first base the numbering goes on, so no new vertex takes an old name.

## Basic Examples

The fiber over the centre of the square grid and of the square mesh, two new vertices over every vertex:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {inflated = BlockRandom[InflateGraph[g, 2], RandomSeeding -> 1]},
    InfraSubstrateHighlight[inflated, {Cases[VertexList[inflated], InflatedVertex[c, _]], c}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The neighbours of a new vertex over the centre of the grid: its base vertex, a vertex of its own fiber and new vertices over the neighbours of the centre:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
  {inflated = BlockRandom[InflateGraph[g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2], RandomSeeding -> 1]},
  AdjacencyList[inflated, InflatedVertex[c, 1]]]
```

## Properties and Relations

The projection onto the base gives the grid back, once loops and repeated edges are removed:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = BlockRandom[InflateGraph[g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2], RandomSeeding -> 1]},
  Sort @ EdgeList @ SimpleGraph @ VertexReplace[inflated, InflatedVertex[v_, _] :> v] === Sort @ EdgeList[g]]
```

Inflating twice nests the names over the new vertices and numbers on over the old ones:

```wl
With[{inflated = InflateGraph[InflateGraph[CycleGraph[3]]]},
  {Cases[VertexList[inflated], InflatedVertex[_InflatedVertex, _]], Cases[VertexList[inflated], InflatedVertex[1, _]]}]
```
