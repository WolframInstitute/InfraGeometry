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

<code>[TopologicalNeighborhood]()[*topo*, *s*]</code> gives the smallest open set containing the vertex list *s* in the topology of the digraph *topo*: the vertices that directed paths from *s* reach.

## Details & Options

Definition: in a finite topology the intersection of all open sets containing *s* is open. It is the up-set of *s*: *s* and every vertex *q* with a directed path from a vertex of *s* to *q*.

For <code>[BallTopology]()[*g*, *r*]</code> it is the set of vertices whose ball lies inside the ball of a vertex of *s*.

A set is open when it equals its neighbourhood. The neighbourhood in *topo* is the closure in the reversed digraph, the dual topology.

The result is a sorted vertex list.

## Basic Examples

The smallest open set containing a ball about the centre that reaches within two steps of the rim, at radius 2, on the discretized plane, the square tiling and the hexagonal tiling. The ball is green. The neighbourhood adds the red vertices near the rim, whose balls lie inside the balls of the ball's vertices.

```wl
GraphicsRow @ Table[
  With[
    {g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {c = InfraCenter[g]},
    {region = FindInfraRepresentative[g, InfraBall[c, VertexEccentricity[g, c] - 2]]},
    {open = TopologicalNeighborhood[BallTopology[g, 2], region]},
    InfraSubstrateHighlight[g, {region -> StandardGreen, Complement[open, region] -> StandardRed}]],
  {name, {"SquareMeshGraph", "SquareTilingGraph", "HexagonalTilingGraph"}}]
```

On a binary tree, a child of the root is an open point at radii 1 and 2. At radius 3 its ball holds the ball of every vertex below it, and its smallest open neighbourhood is its whole branch.

```wl
With[
  {g = KaryTree[31]},
  GraphicsRow @ Table[
    InfraSubstrateHighlight[g, {3 -> StandardBlue, Complement[TopologicalNeighborhood[BallTopology[g, r], {3}], {3}] -> StandardRed}],
    {r, 1, 3}]]
```

## Properties and Relations

The neighbourhood is open, its own interior. It is the closure in the dual topology, the reversed digraph.

```wl
With[
  {g = InfraSubstrate["SquareMeshGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  {ball = FindInfraRepresentative[g, InfraBall[InfraCenter[g], 4]]},
  {open = TopologicalNeighborhood[topo, ball]},
  {InfraSubstrateHighlight[g, {ball -> StandardGreen, Complement[open, ball] -> StandardRed}],
   TopologicalInterior[topo, open] == open,
   open == TopologicalClosure[BallTopology[g, 2, "Dual" -> True], ball]}]
```
