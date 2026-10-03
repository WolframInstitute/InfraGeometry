---
Template: Symbol
Name: InfraFlatConnectionQ
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFlatConnectionQ
Keywords: [flat connection, holonomy, horizontal leaf, curvature]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHolonomy, InfraParallelTransport, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[InfraFlatConnectionQ]()[*fib*, *conn*]</code> tests whether *conn* is a connection whose horizontal leaves, the components of its edges, each project injectively to the base.

## Details & Options

- A walk in the connection graph projects to a walk of the base with the same transport. So every holonomy is trivial iff no horizontal leaf meets a fiber twice.
- *conn* must first satisfy [InfraConnectionQ]().

## Basic Examples

The horizontal leaves of the prism, each in its own colour: two sheets, each meeting every fiber once. The connection is flat.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {InfraSubstrateHighlight[total, InfraDensity[total, #] & /@ ConnectedComponents @ Graph[VertexList[total], First @ conn]],
    InfraFlatConnectionQ[fib, conn]}]
```

On the Moebius ladder there is one leaf, and it meets every fiber twice. The connection is not flat.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {InfraSubstrateHighlight[total, InfraDensity[total, #] & /@ ConnectedComponents @ Graph[VertexList[total], First @ conn]],
    InfraFlatConnectionQ[fib, conn]}]
```

## Properties and Relations

The holonomy around the cycle is trivial on the prism and swaps the sheets on the Moebius ladder.

```wl
Table[
  With[
    {fib = InfraFiberedSubstrate[name, "Small"]},
    {conn = InfraConnection @ Select[EdgeList @ InfraTotalGraph[fib], First @ First @ # =!= First @ Last @ # &]},
    name -> InfraHolonomy[fib, conn, Append[Range[8], 1]]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```
