---
Template: Symbol
Name: InfraHolonomy
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraHolonomy
Keywords: [holonomy, connection, permutation, loop, Cycles]
SeeAlso: [InfraParallelTransport, InfraHolonomyAngle, InfraConnection, InfraFlatConnectionQ, FindInfraHorizontalLift]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraHolonomy]()[*fib*, *conn*, *loop*]</code> gives the transport around a closed walk as [Cycles]() on the positions of the fiber over its first vertex.

## Details & Options

- The fiber over the first vertex *p* of *loop* is indexed in the order of the total vertices over *p*, the order [InfraFiber]() uses.
- The call stays unevaluated when the transport around *loop* is not a permutation of the fiber: a blocked lift, or a walk that does not close.

## Basic Examples

The holonomy around the cycle: trivial on the prism, the swap of the sheets on the Moebius ladder.

```wl
Table[
  With[
    {fib = InfraFiberedSubstrate[name, "Small"]},
    {conn = InfraConnection @ Select[EdgeList @ InfraTotalGraph[fib], First @ First @ # =!= First @ Last @ # &]},
    {InfraTotalGraph[fib], InfraHolonomy[fib, conn, Append[Range[8], 1]]}],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

A random connection of the grid displacement bundle at scale 2 turns the six directions at 6 cyclically around the square drawn.

```wl
With[
  {g = GridGraph[{4, 4}]},
  {fib = InfraDisplacementBundle[g, 2]},
  {conn = (SeedRandom[1]; RandomInfraConnection[fib])},
  {InfraSubstrateHighlight[g, {InfraWalk[{6, 7, 11, 10, 6}]}], InfraHolonomy[fib, conn, {6, 7, 11, 10, 6}]}]
```

## Properties and Relations

The Levi-Civita connection of the octahedron turns the four directions at a vertex once around a face.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {face = {1, 2, 3, 1}},
  {InfraSubstrateHighlight[First @ fib, {InfraWalk[face]}], InfraHolonomy[fib, FindInfraLeviCivitaConnection[fib], face]}]
```
