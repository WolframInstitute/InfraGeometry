---
Template: Symbol
Name: InfraAtMostOneEdgeLiftQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraAtMostOneEdgeLiftQ
Keywords: [local injectivity, partial matching, edge lifting, lift multiplicity]
SeeAlso: [InfraFibrationQ, InfraUniqueEdgeLiftingQ, InfraEdgeLiftMultiplicity, InfraCoveringQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraAtMostOneEdgeLiftQ]()[*fib*]</code> gives [True]() if every total vertex of the fibered graph *fib* has at most one neighbour over each neighbour of its base vertex.

## Details & Options

The condition is *|N(x) ∩ F(q)| ≤ 1* for every total vertex *x* over *p* and every base neighbour *q* of *p*, with *N(x)* the neighbours of *x* and *F(q)* the fiber over *q*.

Over every base edge the total edges then form a matching between the two fibers, possibly not perfect. Vertical edges, inside one fiber, do not count.

The projection is injective on the neighbours of *x* outside its fiber. Nothing is said about injectivity inside a fiber.

[InfraFibrationQ]() asks for at least one lift. The two conditions together are [InfraUniqueEdgeLiftingQ]().

A list of fibered graphs gives [True]() when every member satisfies the condition; the empty list gives [False]().

## Basic Examples

Random fibered graphs with two vertices in every fiber and at most one lift of each base edge, over the square grid and the square mesh. Some total vertices have no lift, so they are not fibrations:

```wl
GraphicsRow @ Table[
  With[{g = InfraSubstrate[name, "Small", "KeepCoordinates" -> True]},
    {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
    {fib = RandomInfraFiberedGraph[g, Properties -> {"AtMostOneEdgeLift"}, "VerticalVertexCount" -> {2},
      RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, {}, "BaseVertexCoordinates" -> xy,
      PlotLabel -> {InfraAtMostOneEdgeLiftQ[fib], InfraFibrationQ[fib]}]],
  {name, {"SquareGridGraph", "SquareMeshGraph"}}]
```

The number of lifts over each base neighbour, counted over all total vertices of the first example. Every count is 0 or 1:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"AtMostOneEdgeLift"}, "VerticalVertexCount" -> {2},
    RandomSeeding -> 1]},
  Counts @ Catenate[Values /@ Values @ InfraEdgeLiftMultiplicity[fib]]]
```

## Properties and Relations

A fibration with at most one lift has exactly one. On the catalogue entries over the cycle of length 8, the condition and [InfraFibrationQ]() together give [InfraUniqueEdgeLiftingQ]():

```wl
Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]},
    {InfraFibrationQ[fib], InfraAtMostOneEdgeLiftQ[fib], InfraUniqueEdgeLiftingQ[fib]}],
  {name, {"CycleProductBundle", "MoebiusLadderCover", "BranchedCycleFibration"}}]
```

Vertical edges do not count: the prism has a rung in every fiber and still has at most one lift.

```wl
With[{fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  InfraFiberedGraphHighlight[fib, PlotLabel -> InfraAtMostOneEdgeLiftQ[fib], ImageSize -> Medium]]
```

The displacement bundle of the grid at scale 1 fails the condition. A pair {*p*, *v*} has 4 lifts over *v*, 2 over each base neighbour of *p* across the direction and 1 over the one behind *p*:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]}, {c = First @ GraphCenter[g]},
  {fib = InfraDisplacementBundle[g, 1], v = First @ AdjacencyList[g, c]},
  {InfraAtMostOneEdgeLiftQ[fib], v, InfraEdgeLiftMultiplicity[fib][{c, v}]}]
```
