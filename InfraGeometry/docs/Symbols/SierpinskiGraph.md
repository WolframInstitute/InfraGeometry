---
Template: Symbol
Name: SierpinskiGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/SierpinskiGraph
Keywords: [Sierpinski, fractal, truncation, trivalent, cubic graph, self-similar, truncated tetrahedron]
SeeAlso: [BetheGraph, BranchingSequenceTree, InfraSubstrate, TessellationGraph]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[SierpinskiGraph]()[*n*]</code> gives the trivalent Sierpinski graph of generation *n*.

## Details & Options

Construction: generation 1 is the complete graph on four vertices, the tetrahedron. Generation *n* cuts every corner of generation *n* − 1: each vertex becomes a triangle, and its three edges are attached to the three corners of the triangle. On a graph in which every vertex has degree 3 this is truncation, so every generation has degree 3 at every vertex.

Generation *n* has 4·3^(*n* − 1) vertices and 6·3^(*n* − 1) edges. Generation 2 is the truncated tetrahedron.

A vertex of generation *n* is a pair {*v*, *i*}: *v* a vertex of generation *n* − 1 and *i* = 1, 2, 3 a corner of its triangle. Generation 1 has the vertices 1, 2, 3, 4.

The graph has no coordinates; its layout is the default. [Graph]() options are passed on to the graph, and [Graph3D]() draws it in space.

The graph differs from the substrate `"SierpinskiTriangleGraph"` of [InfraSubstrate](), the mesh of the Sierpinski triangle, whose junctions have degree 4.

## Basic Examples

Generations 2, 3 and 4, and their numbers of vertices.

```wl
With[
  {generations = Table[SierpinskiGraph[n], {n, 2, 4}]},
  {GraphicsRow[generations], VertexCount /@ generations}]
```

## Scope

The vertices of generation 2: each vertex of the tetrahedron and a corner of its triangle.

```wl
SierpinskiGraph[2, VertexLabels -> Automatic]
```

Generation 4 in space.

```wl
Graph3D @ SierpinskiGraph[4]
```

## Properties and Relations

Generation 2 is the truncated tetrahedron, the uniform map {3, 6, 6} of [TessellationGraph]().

```wl
With[
  {g = SierpinskiGraph[2]},
  {g, IsomorphicGraphQ[g, TessellationGraph[{3, 6, 6}]]}]
```

The number of vertices of generation *n* is 4·3^(*n* − 1), and for *n* = 1, …, 6 the diameter is 2^*n* − 1. Where both hold, the vertex count grows like the diameter to the power log 3 / log 2 ≈ 1.585, the dimension of the Sierpinski triangle.

```wl
With[
  {sizes = Table[{GraphDiameter[SierpinskiGraph[n]], VertexCount[SierpinskiGraph[n]]}, {n, 6}]},
  {ListLogLogPlot[sizes, Joined -> True, AxesLabel -> {"diameter", "vertices"}], sizes == Table[{2^n - 1, 4 3^(n - 1)}, {n, 6}]}]
```

Every vertex has degree 3. The substrate `"SierpinskiTriangleGraph"` has vertices of degree 2 and 4.

```wl
With[
  {graphs = {SierpinskiGraph[4], InfraSubstrate["SierpinskiTriangleGraph", "Small"]}},
  {GraphicsRow[graphs], Union @ VertexDegree[#] & /@ graphs}]
```
