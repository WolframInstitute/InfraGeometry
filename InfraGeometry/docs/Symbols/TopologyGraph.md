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

The edges of *g* are drawn faint and the arrows of *topo* in full, at the vertex coordinates of *g*. A substrate made with `"KeepCoordinates" -> True` keeps its own layout; a graph without coordinates is drawn with its default layout.

The digraph *topo* is any digraph on the vertices of *g*: the Hasse diagram of [BallTopology](), its dual, or its transitive closure. The drawing is a picture only; the topological operators take *topo* itself.

## Basic Examples

The ball topology of radius 3 on the square grid and on the square mesh:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]}, TopologyGraph[g, BallTopology[g, 3]]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The ball topology of the mesh at radii 1, 2 and 3. The arrows stay at the rim, and there are more of them as the radius grows, 40, 62 and 81:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[TopologyGraph[g, BallTopology[g, r]], {r, 1, 3}]]
```

## Scope

The Hasse diagram and its transitive closure, every comparable pair, on the grid at radius 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]}, {topo = BallTopology[g, 2]},
  GraphicsRow @ {TopologyGraph[g, topo], TopologyGraph[g, TransitiveClosureGraph @ topo]}]
```

A graph without coordinates is drawn with its default layout:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, TopologyGraph[g, BallTopology[g, 1]]]
```
