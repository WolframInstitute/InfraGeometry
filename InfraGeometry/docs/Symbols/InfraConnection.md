---
Template: Symbol
Name: InfraConnection
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnection
Keywords: [connection, horizontal edge, lift, horizontal leaf, inert map]
SeeAlso: [InfraConnectionQ, InfraFlatConnectionQ, RandomInfraConnection, FindInfraLeviCivitaConnection, InfraParallelTransport, InfraHolonomy, FindInfraHorizontalLift]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraConnection]()[*edges*]</code> is a connection: horizontal edges of the total graph chosen as lifts, at most one per fiber vertex and base neighbour, every existing lift chosen.

## Details & Options

- [InfraConnection]() is inert and carries no graph. The fibration is given to each function that reads it.
- An edge is horizontal when its endpoints lie over different base vertices.
- <code>[Graph]()[*total vertices*, *edges*]</code> is the connection graph. Its components are the horizontal leaves.
- [InfraConnectionQ]() checks that *edges* is a connection of a given fibration.

## Basic Examples

The horizontal edges of the prism form a connection: each vertex has one lift of each base edge.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ First @ conn, Directive[StandardRed]]]]
```

The same on the Moebius ladder: one horizontal leaf runs twice around the cycle.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  InfraSubstrateHighlight[total, Prepend[InfraWalk /@ List @@@ First @ conn, Directive[StandardRed]]]]
```

## Properties and Relations

The Levi-Civita connection of the octahedron is an [InfraConnection]() of its displacement bundle.

```wl
With[
  {fib = InfraFiberedSubstrate["OctahedronDisplacementBundle"]},
  {conn = FindInfraLeviCivitaConnection[fib]},
  {Head[conn], Length @ First @ conn, InfraConnectionQ[fib, conn]}]
```
