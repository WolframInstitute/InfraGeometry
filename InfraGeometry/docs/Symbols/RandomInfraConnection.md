---
Template: Symbol
Name: RandomInfraConnection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/RandomInfraConnection
Keywords: [random connection, matching, lift]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHolonomy, RandomInfraFibration, RandomInfraSection]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[RandomInfraConnection]()[*fib*]</code> gives an [InfraConnection]() from a random maximum matching of the total edges over every base edge.

## Details & Options

- [SeedRandom]() in front of the call gives the same connection again.
- Where the maximum matching over a base edge is not perfect on the vertices with a lift, the result is not a connection; [InfraConnectionQ]() tells.

## Basic Examples

Two vertices in every fiber over a hexagon, adjacent fibers joined completely. A random connection picks one of the two matchings over each base edge.

```wl
With[
  {fib = (SeedRandom[3]; RandomInfraFibration[CycleGraph[6], "VerticalVertices" -> 2, "IsomorphicFibers" -> True, "HorizontalEdgesDensity" -> 2])},
  {total = InfraTotalGraph[fib]},
  {conn = (SeedRandom[1]; RandomInfraConnection[fib])},
  {InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ First @ conn, Directive[StandardRed]]],
    InfraConnectionQ[fib, conn], InfraHolonomy[fib, conn, {1, 2, 3, 4, 5, 6, 1}]}]
```

A random connection of the displacement bundle of the grid at scale 2, and its holonomy around a square: a cyclic permutation of the six directions at 6.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {fib = InfraDisplacementBundle[g, 2]},
  {conn = (SeedRandom[1]; RandomInfraConnection[fib])},
  {InfraSubstrateHighlight[g, {InfraWalk[{6, 7, 11, 10, 6}]}], InfraHolonomy[fib, conn, {6, 7, 11, 10, 6}]}]
```
