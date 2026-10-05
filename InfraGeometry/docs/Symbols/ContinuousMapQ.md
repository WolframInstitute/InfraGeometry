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

<code>[ContinuousMapQ]()[*f*, *topo1*, *topo2*]</code> tests whether the vertex map *f* is continuous from the topology of the digraph *topo1* to that of *topo2*.

## Details & Options

Definition: a map between finite topologies is continuous exactly when it is monotone for the specialization preorders, *q ≤ p* implies *f(q) ≤ f(p)*. Equivalently, *f(cl(p)) ⊆ cl(f(p))* for every vertex *p*.

The test runs over the edges of *topo1*: each edge *q* → *p* must go to a pair *f(q)*, *f(p)* joined by a directed path of *topo2*. The two topologies may come from different graphs or different radii.

*f* is an [Association](), a list of rules, or a function.

For [BallTopology]() a graph automorphism is continuous at every radius, and so is its inverse. The identity is continuous from radius *r* to any larger radius, since the topology coarsens.

## Basic Examples

The topology of a binary tree coarsens from radius 1 to radius 2. The identity is continuous from the finer to the coarser, not back.

```wl
With[
  {g = KaryTree[31]},
  {fine = BallTopology[g, 1]},
  {coarse = BallTopology[g, 2]},
  {GraphicsRow @ {TopologyGraph[g, fine], TopologyGraph[g, coarse]},
   ContinuousMapQ[Identity, fine, coarse], ContinuousMapQ[Identity, coarse, fine]}]
```

Each of the eight symmetries of the square tiling is continuous in the ball topology of radius 2.

```wl
With[
  {g = InfraSubstrate["SquareTilingGraph", "Small", "KeepCoordinates" -> True]},
  {topo = BallTopology[g, 2]},
  {symmetries = FindGraphIsomorphism[g, g, All]},
  {TopologyGraph[g, topo], Length[symmetries], AllTrue[symmetries, ContinuousMapQ[#, topo, topo] &]}]
```

## Scope

The map may be a function, a list of rules or an association. The reflection of a path is continuous; the rotation by two steps is not.

```wl
With[
  {g = PathGraph[Range[7]]},
  {topo = BallTopology[g, 2]},
  {TopologyGraph[g, topo],
   ContinuousMapQ[v |-> 8 - v, topo, topo],
   ContinuousMapQ[Thread[Range[7] -> Reverse[Range[7]]], topo, topo],
   ContinuousMapQ[AssociationThread[Range[7], Reverse[Range[7]]], topo, topo],
   ContinuousMapQ[v |-> Mod[v + 2, 7, 1], topo, topo]}]
```

## Possible Issues

A constant map is continuous, but the test reports `False` whenever *f* sends both ends of an edge of *topo1* to one vertex. For a constant map it gives `True` only when *topo1* has no edges, as at radius 0.

```wl
With[
  {g = PathGraph[Range[7]]},
  {topo = BallTopology[g, 2]},
  {TopologyGraph[g, topo], ContinuousMapQ[v |-> 4, topo, topo], ContinuousMapQ[v |-> 4, BallTopology[g, 0], topo]}]
```
