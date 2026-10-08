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

[InflatedVertex]() is inert: it names a vertex and does not evaluate. Its first argument is the base vertex, its second the position in the fiber.

The fiber over *v* is the set of vertices that match <code>[InflatedVertex]()[*v*, _]</code>, and the projection onto the base graph replaces <code>[InflatedVertex]()[*v*, _]</code> by *v*.

Inflating an inflated graph nests the names: the fiber over <code>[InflatedVertex]()[*v*, *i*]</code> has the vertices <code>[InflatedVertex]()[[InflatedVertex]()[*v*, *i*], *j*]</code>. Over a vertex *v* of the first base the numbering goes on, so no new vertex takes the name of an old one.

## Basic Examples

The fiber over the centre of the discretized plane, the square tiling and the hexagonal tiling, inflated with two new vertices over every vertex.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = First @ GraphCenter[g]},
    {inflated = (SeedRandom[1]; InflateGraph[g, 2])},
    InfraSubstrateHighlight[inflated, {Cases[VertexList[inflated], InflatedVertex[c, _]], c}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

## Scope

The fiber sizes, drawn between none and three.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = (SeedRandom[1]; InflateGraph[g, {0, 3}])},
  {sizes = Table[Length @ Cases[VertexList[inflated], InflatedVertex[v, _]], {v, VertexList[g]}]},
  {Histogram[sizes, {1}, AxesLabel -> {"fiber size", "vertices"}], Counts[sizes] // KeySort // Normal}]
```

The neighbours of a new vertex over a vertex of the 6 × 6 grid: its base vertex, a vertex of its own fiber, and new vertices over the neighbours of its base vertex, drawn at random.

```wl
With[
  {inflated = (SeedRandom[1]; InflateGraph[GridGraph[{6, 6}], 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2])},
  {neighbours = AdjacencyList[inflated, InflatedVertex[15, 1]]},
  {InfraSubstrateHighlight[inflated, {neighbours, InflatedVertex[15, 1]}], neighbours}]
```

## Properties and Relations

The name does not evaluate; its arguments are the base vertex and the position in the fiber.

```wl
With[
  {g = CycleGraph[6]},
  {inflated = InflateGraph[g]},
  {inflated, InflatedVertex[1, 1], First /@ Cases[VertexList[inflated], _InflatedVertex]}]
```

Collapsing every fiber onto its base vertex gives the base graph back, up to loops and repeated edges: a spoke and a vertical edge collapse to a loop, a horizontal edge onto the edge below it.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {inflated = (SeedRandom[1]; InflateGraph[g, 2, "VerticalEdges" -> 1, "HorizontalEdges" -> 2])},
  {collapsed = SimpleGraph @ VertexReplace[inflated, InflatedVertex[v_, _] :> v]},
  {collapsed, Sort[EdgeList[collapsed]] === Sort[EdgeList[g]]}]
```

Inflating twice nests the names over the new vertices and numbers on over the vertices of the triangle.

```wl
With[
  {inflated = InflateGraph[InflateGraph[CycleGraph[3]]]},
  {inflated, Cases[VertexList[inflated], InflatedVertex[_InflatedVertex, _]], Cases[VertexList[inflated], InflatedVertex[1, _]]}]
```
