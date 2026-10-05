---
Template: Symbol
Name: TopologyGraph
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologyGraph
Keywords: [ball topology, specialization preorder, Hasse diagram, drawing, visualization]
SeeAlso: [BallTopology, TopologicalClosure, InfraSubstrateHighlight]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologyGraph]()[*g*, *topo*]</code> draws the graph *g* with the edges of the digraph *topo* as arrows on top.

## Details & Options

The edges of *g* are drawn faint and the arrows of *topo* in full, at the vertex coordinates of *g*. A substrate drawn with `"KeepCoordinates"` -> `True` keeps its own layout; a graph without coordinates is placed by its spring layout.

*topo* is any digraph on the vertices of *g*: the Hasse diagram of [BallTopology](), its dual, or its transitive closure. The drawing is a picture only; the topological operators read *topo* itself.

## Basic Examples

The ball topology of the hexagonal tiling at radii 1, 2 and 3. Every arrow ends near the rim.

```wl
With[
  {g = InfraSubstrate["HexagonalTilingGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[TopologyGraph[g, BallTopology[g, r]], {r, 1, 3}]]
```

The Hasse diagram and every comparable pair, its transitive closure, on a binary tree at radius 2.

```wl
With[
  {g = KaryTree[31]},
  {topo = BallTopology[g, 2]},
  GraphicsRow @ {TopologyGraph[g, topo], TopologyGraph[g, TransitiveClosureGraph[topo]]}]
```

## Scope

A substrate without coordinates is drawn by its spring layout.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small"]},
  TopologyGraph[g, BallTopology[g, 1]]]
```
