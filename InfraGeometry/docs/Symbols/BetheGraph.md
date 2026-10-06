---
Template: Symbol
Name: BetheGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/BetheGraph
Keywords: [Bethe lattice, Cayley tree, regular tree, exponential growth, tree]
SeeAlso: [BranchingSequenceTree, SierpinskiGraph, FindInfraShell, InfraSubstrate]
RelatedGuides: [InfraSubstrates]
---

## Usage

<code>[BetheGraph]()[*n*, *z*]</code> gives the Bethe lattice of coordination number *z* with *n* shells: the ball of radius *n* about a vertex of the tree in which every vertex has degree *z*.

## Details & Options

Definition: the root has *z* children, and every other vertex at depth less than *n* has *z* − 1. So every vertex inside has degree *z*, and the leaves, at depth *n*, have degree 1.

The shell at depth *k* ≥ 1 has *z*(*z* − 1)^(*k* − 1) vertices, and the graph has 1 + *z*((*z* − 1)^*n* − 1)/(*z* − 2) of them for *z* > 2. For *z* = 2 it is the path with 2*n* + 1 vertices. The balls grow exponentially, unlike those of a lattice.

The root is the vertex 0. A vertex at depth *k* is the list of the *k* choices on the way down from the root: the first among 1, …, *z*, the others among 1, …, *z* − 1.

The graph is undirected; [DirectedEdges]() -> [True]() orients every edge away from the root. Other [Graph]() options are passed on to the graph.

<code>[CompleteKaryTree]()[*n*, *k*]</code> is the rooted tree in which every inner vertex has *k* children, so its root has degree *k* and its other inner vertices *k* + 1.

## Basic Examples

The Bethe lattices with four shells and coordination numbers 3, 4 and 5, and their numbers of vertices.

```wl
With[
  {trees = Table[BetheGraph[4, z], {z, 3, 5}]},
  {GraphicsRow[trees], VertexCount /@ trees}]
```

## Scope

The edges oriented away from the root.

```wl
BetheGraph[3, 3, DirectedEdges -> True]
```

## Properties and Relations

The shells about the root, each in its colour, and their sizes 3·2^(*k* − 1).

```wl
With[
  {g = BetheGraph[4, 3]},
  {shells = Table[FindInfraShell[g, 0, k], {k, 4}]},
  {InfraSubstrateHighlight[g, shells], Length /@ shells}]
```

Every vertex inside has degree *z*: the counts of the degrees.

```wl
With[
  {g = BetheGraph[4, 3]},
  {g, Normal @ KeySort @ Counts[VertexDegree[g]]}]
```

The number of vertices is 1 + *z*((*z* − 1)^*n* − 1)/(*z* − 2).

```wl
With[
  {counts = Table[VertexCount @ BetheGraph[n, z], {z, 3, 5}, {n, 5}]},
  {ListLogPlot[counts, Joined -> True, PlotLegends -> {"z = 3", "z = 4", "z = 5"}, AxesLabel -> {"n", "vertices"}],
   counts == Table[1 + z ((z - 1)^n - 1)/(z - 2), {z, 3, 5}, {n, 5}]}]
```

Coordination number 2 gives the path.

```wl
With[
  {g = BetheGraph[4, 2]},
  {g, IsomorphicGraphQ[g, PathGraph[Range[9]]]}]
```
