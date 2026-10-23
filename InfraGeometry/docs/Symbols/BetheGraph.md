---
Template: Symbol
Name: BetheGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BetheGraph
Keywords: [Bethe lattice, Cayley tree, regular tree, exponential growth, tree]
SeeAlso: [BranchingSequenceTree, SierpinskiGraph, InfraShell, InfraSubstrate, CompleteKaryTree]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BetheGraph]()[*n*, *z*]</code> gives the Bethe lattice with *n* shells and coordination number *z*: the ball of radius *n* about a vertex of the infinite tree in which every vertex has degree *z*.

## Details & Options

The root has *z* children and every other vertex at depth less than *n* has *z* − 1. Every inner vertex has degree *z*; the leaves, at depth *n*, have degree 1.

The shell at depth *k* ≥ 1 has *z*(*z* − 1)ᵏ⁻¹ vertices, and the graph has *1 + z((z − 1)ⁿ − 1)/(z − 2)* vertices for *z* > 2. For *z* = 2 it is the path with 2*n* + 1 vertices.

The balls grow exponentially, unlike those of a lattice. The leaves are a share of the whole graph that tends to *(z − 2)/(z − 1)* as *n* grows: the boundary of a ball is never small.

The root is the vertex 0. A vertex at depth *k* is the list of the *k* choices on the way down: the first among 1, …, *z*, the others among 1, …, *z* − 1.

The graph is undirected. [DirectedEdges]() -> [True]() orients every edge away from the root; other [Graph]() options are passed on.

[CompleteKaryTree]()[*n*, *k*] differs: its root has degree *k* and its other inner vertices *k* + 1.

## Basic Examples

The Bethe lattices with four shells and coordination numbers 3, 4 and 5, labelled with their numbers of vertices:

```wl
GraphicsRow @ Table[With[{g = BetheGraph[4, z]}, Graph[g, PlotLabel -> VertexCount[g]]], {z, 3, 5}]
```

The shells about the root, of sizes *3·2ᵏ⁻¹*:

```wl
With[{g = BetheGraph[5, 3]}, {shells = Table[InfraShell[0, k], {k, 5}]},
  InfraSubstrateHighlight[g, shells, PlotLabel -> InfraMeasurement[g, shells, "CountingMeasure"], ImageSize -> Medium]]
```

## Scope

The edges oriented away from the root:

```wl
BetheGraph[3, 3, DirectedEdges -> True]
```

## Properties and Relations

Every inner vertex has degree *z*, every leaf degree 1:

```wl
Counts @ VertexDegree @ BetheGraph[4, 3]
```

The number of vertices is *1 + z((z − 1)ⁿ − 1)/(z − 2)*:

```wl
Table[VertexCount @ BetheGraph[n, z] == 1 + z ((z - 1)^n - 1)/(z - 2), {z, 3, 5}, {n, 5}]
```

The balls about the root grow exponentially, those about the centre of the square grid quadratically:

```wl
With[{tree = BetheGraph[8, 3], grid = InfraSubstrate["SquareGridGraph", "Medium"]}, {c = First @ GraphCenter[grid]},
  ListLogPlot[{Table[InfraMeasurement[tree, InfraBall[0, r], "CountingMeasure"], {r, 0, 8}],
    Table[InfraMeasurement[grid, InfraBall[c, r], "CountingMeasure"], {r, 0, 8}]},
    DataRange -> {0, 8}, Joined -> True, PlotMarkers -> Automatic, PlotLegends -> {"BetheGraph[8, 3]", "SquareGridGraph"}]]
```

The share of leaves tends to *(z − 2)/(z − 1)*, here 1/2 and 2/3:

```wl
Table[N[Count[VertexDegree @ BetheGraph[n, z], 1]/VertexCount @ BetheGraph[n, z]], {z, 3, 4}, {n, {2, 4, 8}}]
```

Coordination number 2 gives the path:

```wl
IsomorphicGraphQ[BetheGraph[4, 2], PathGraph[Range[9]]]
```
