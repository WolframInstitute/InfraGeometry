---
Template: Symbol
Name: ContinuousMapQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/ContinuousMapQ
Keywords: [continuous map, monotone map, finite topology, ball topology, specialization preorder, homeomorphism]
SeeAlso: [BallTopology, TopologicalClosure, TopologicalNeighborhood, TopologyGraph]
RelatedGuides: [InfraTopology]
---

## Usage

<code>[ContinuousMapQ]()[*f*, *topo1*, *topo2*]</code> gives `True` if the vertex map *f* is continuous from the topology of the digraph *topo1* to that of *topo2*.

## Details & Options

A map between finite topologies is continuous exactly when it keeps the specialization preorder: *q ≤ p* implies *f(q) ≤ f(p)*. Equivalently *f(cl(p)) ⊆ cl(f(p))* for every vertex *p*.

So each edge *q* → *p* of *topo1* must go to two equal vertices or to a pair *f(q)*, *f(p)* joined by a directed path of *topo2*. The two topologies may come from different graphs or different radii.

The map *f* is an [Association](), a list of rules or a function.

For [BallTopology]() every automorphism of the graph is continuous at every radius. The identity is continuous from radius *r* to every larger radius, since the topology gets coarser. Every map is continuous from the discrete topology of radius 0, and every constant map is continuous.

## Basic Examples

The ball topologies of radius 1 and 2 on the square grid. Every pair comparable at radius 1 is comparable at radius 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  GraphicsRow @ Table[TopologyGraph[g, BallTopology[g, r]], {r, 1, 2}]]
```

So the identity of the small grid is continuous from radius 1 to radius 2, not back:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {fine = BallTopology[g, 1], coarse = BallTopology[g, 2]},
  {ContinuousMapQ[Identity, fine, coarse], ContinuousMapQ[Identity, coarse, fine]}]
```

The small grid has 128 automorphisms: the 8 symmetries of the square, and at each of the four corners the swap of its two vertices of degree 1. All are continuous at radius 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {topo = BallTopology[g, 2]},
  {symmetries = FindGraphIsomorphism[g, g, All]},
  {Length[symmetries], AllTrue[symmetries, ContinuousMapQ[#, topo, topo] &]}]
```

## Scope

The map can be a function, a list of rules or an association. The reflection of a path is continuous; the rotation of its vertices by two steps is not:

```wl
With[{topo = BallTopology[PathGraph[Range[7]], 2]},
  {ContinuousMapQ[v |-> 8 - v, topo, topo], ContinuousMapQ[Thread[Range[7] -> Reverse @ Range[7]], topo, topo],
   ContinuousMapQ[AssociationThread[Range[7], Reverse @ Range[7]], topo, topo],
   ContinuousMapQ[v |-> Mod[v + 2, 7, 1], topo, topo]}]
```

## Properties and Relations

Swapping a vertex *e* of degree 1 with its neighbour *n* is not continuous at radius 1: the ball of *n* contains the ball of *e*, not the other way round. Sending *e* to *n* and fixing the rest is continuous:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {topo = BallTopology[g, 1]},
  {e = First @ Select[VertexList[g], VertexDegree[g, #] == 1 &]}, {n = First @ AdjacencyList[g, e]},
  {ContinuousMapQ[v |-> Replace[v, {e -> n, n -> e}], topo, topo], ContinuousMapQ[v |-> Replace[v, e -> n], topo, topo]}]
```

Every map from the discrete topology of radius 0 is continuous, and so is a constant map:

```wl
With[{g = InfraSubstrate["SquareMeshGraph", "Small"]}, {topo = BallTopology[g, 2]},
  {f = AssociationThread[VertexList[g], RandomInfraPoint[g, VertexCount[g], RandomSeeding -> 1]]},
  {ContinuousMapQ[f, BallTopology[g, 0], topo],
   ContinuousMapQ[v |-> First @ GraphCenter[g], topo, topo]}]
```
