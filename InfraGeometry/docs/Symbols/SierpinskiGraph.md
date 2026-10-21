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

<code>[SierpinskiGraph]()[*n*]</code> gives the trivalent Sierpinski graph of generation *n*: the tetrahedron truncated *n* − 1 times.

## Details & Options

Generation 1 is the complete graph on four vertices. Generation *n* replaces every vertex of generation *n* − 1 by a triangle and attaches its three edges to the three corners. Every generation is 3-regular.

Generation *n* has *4·3ⁿ⁻¹* vertices and *6·3ⁿ⁻¹* edges, and for *n* ≤ 6 its diameter is *2ⁿ − 1*. So the number of vertices grows like the diameter to the power *log 3/log 2 ≈ 1.585*, the Hausdorff dimension of the Sierpinski triangle.

Generation 2 is the truncated tetrahedron. From generation 2 on, every vertex lies on exactly one triangle.

A vertex of generation *n* is a pair {*v*, *i*}: *v* a vertex of generation *n* − 1 and *i* = 1, 2, 3 a corner of its triangle. Generation 1 has the vertices 1, 2, 3, 4.

The graph has no coordinates. [Graph]() options are passed on, and [Graph3D]() draws it in space.

It differs from the substrate `"SierpinskiTriangleGraph"` of [InfraSubstrate](), the mesh of the Sierpinski triangle, whose junctions have degree 4.

## Basic Examples

Generations 2, 3 and 4, labelled with their numbers of vertices:

```wl
GraphicsRow @ Table[With[{g = SierpinskiGraph[n]}, Graph[g, PlotLabel -> VertexCount[g]]], {n, 2, 4}]
```

Generation 4 in space:

```wl
Graph3D[SierpinskiGraph[4], ImageSize -> Medium]
```

## Scope

The vertices of generation 2, a vertex of the tetrahedron and a corner of its triangle:

```wl
SierpinskiGraph[2, VertexLabels -> Automatic]
```

## Properties and Relations

Generation 2 is the truncated tetrahedron, the uniform map {3, 6, 6} of [TessellationGraph]():

```wl
IsomorphicGraphQ[SierpinskiGraph[2], TessellationGraph[{3, 6, 6}]]
```

Diameter and number of vertices are *2ⁿ − 1* and *4·3ⁿ⁻¹*. On log-log axes the slope tends to *log 3/log 2*:

```wl
With[{sizes = Table[{GraphDiameter[SierpinskiGraph[n]], VertexCount[SierpinskiGraph[n]]}, {n, 6}]},
  ListLogLogPlot[sizes, Joined -> True, PlotMarkers -> Automatic, PlotLabel -> (sizes == Table[{2^n - 1, 4 3^(n - 1)}, {n, 6}])]]
```

The triangles of generation 3, one through every vertex:

```wl
With[{g = SierpinskiGraph[3]}, {triangles = FindCycle[g, {3}, All]},
  InfraSubstrateHighlight[g, Subgraph[g, #] & /@ triangles, PlotLabel -> Length[triangles], ImageSize -> Medium]]
```

Every vertex has degree 3. The substrate `"SierpinskiTriangleGraph"` has degrees 2 and 4:

```wl
With[{graphs = {SierpinskiGraph[4], InfraSubstrate["SierpinskiTriangleGraph", "Small"]}},
  GraphicsRow[Graph[#, PlotLabel -> Union @ VertexDegree[#]] & /@ graphs]]
```
