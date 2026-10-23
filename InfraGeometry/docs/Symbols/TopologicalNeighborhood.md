---
Template: Symbol
Name: TopologicalNeighborhood
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/TopologicalNeighborhood
Keywords: [neighbourhood, neighborhood, open set, minimal open set, up-set, ball topology, finite topology]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalInterior, TopologicalBoundary, ContinuousMapQ]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[TopologicalNeighborhood]()[*topo*, *s*]</code> gives the smallest open set that contains the vertex list *s* in the topology of the digraph *topo*: the vertices that directed paths from *s* reach.

## Details & Options

In a finite topology the intersection of all open sets containing *s* is open. It is the up-set *U(s) = {q : p ≤ q for some p in s}*, with *≤* the preorder of [TopologicalClosure]().

In <code>[BallTopology]()[*g*, *r*]</code> the smallest open set of a vertex is *U(p) = {q : Bᵣ(q) ⊆ Bᵣ(p)}*, the vertices whose ball lies inside the ball at *p*.

A set is open when it is its own smallest open neighbourhood. The neighbourhood in *topo* is the closure in the reversed digraph, the dual topology.

On a patch of the grid a vertex far from the rim is open: its smallest neighbourhood is the vertex alone.

The result is a sorted vertex list.

## Basic Examples

The smallest open set that contains a ball about the centre coming within two steps of the rim, at radius 2, on the square grid and on the square mesh. It adds the vertices near the rim whose balls lie inside the balls of vertices of the ball:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Medium", "KeepCoordinates" -> True]}, {c = First @ GraphCenter[g]},
    {ball = Keys @ InfraMeasurement[g, InfraBall[c, VertexEccentricity[g, c] - 2], "VertexDensity"]},
    InfraSubstrateHighlight[g, {TopologicalNeighborhood[BallTopology[g, 2], ball], ball}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

A corner of the inner square of the small grid, at radii 1 to 4. At radius 1 its smallest open set holds the two vertices of degree 1 next to it; from radius 2 on, also the next two vertices of degree 1 along the rim:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {v = First @ AdjacencyList[g, First @ Select[VertexList[g], VertexDegree[g, #] == 1 &]]},
  GraphicsRow @ Table[InfraSubstrateHighlight[g, {TopologicalNeighborhood[BallTopology[g, r], {v}], v}, PlotLabel -> r],
    {r, 1, 4}]]
```

## Properties and Relations

The neighbourhood is open, its own interior. It is the closure in the dual topology:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Medium"]}, {topo = BallTopology[g, 2]},
  {ball = Keys @ InfraMeasurement[g, InfraBall[First @ GraphCenter[g], 8], "VertexDensity"]},
  {open = TopologicalNeighborhood[topo, ball]},
  {TopologicalInterior[topo, open] === open, open === TopologicalClosure[BallTopology[g, 2, "Dual" -> True], ball]}]
```

Away from the rim a vertex is open. The centre of the grid is its own smallest neighbourhood up to radius 4:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  Table[TopologicalNeighborhood[BallTopology[g, r], {c}], {r, 1, 4}]]
```
