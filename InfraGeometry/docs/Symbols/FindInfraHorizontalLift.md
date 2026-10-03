---
Template: Symbol
Name: FindInfraHorizontalLift
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHorizontalLift
Keywords: [horizontal lift, path lifting, connection, walk]
SeeAlso: [InfraConnection, InfraParallelTransport, InfraHolonomy, InfraFlatConnectionQ]
RelatedGuides: [InfraFiberBundles]
---

## Usage

<code>[FindInfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*, *n*]</code> gives *n* lifts of the base walk along the edges of *conn*, each starting at the total vertex *x*.

<code>[FindInfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*, [UpTo]()[*n*]]</code> gives at most *n*, and <code>[FindInfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*, [All]()]</code> gives every one.

## Details & Options

- A lift is a list of total vertices, the *i*-th over the *i*-th vertex of *walk*, consecutive ones joined by an edge of *conn*.
- *x* must lie over the first vertex of *walk*; otherwise there is no lift.
- With an exact count *n*, the result is {} when fewer than *n* lifts exist.

## Basic Examples

The lift of the loop around the cycle on the Moebius ladder, starting on one sheet, ends on the other.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {lift = First @ FindInfraHorizontalLift[fib, conn, {1, 1}, Append[Range[8], 1], 1]},
  {InfraSubstrateHighlight[total, {InfraWalk[lift]}], First @ lift, Last @ lift}]
```

On the prism the same lift closes up.

```wl
With[
  {fib = InfraFiberedSubstrate["CycleProductBundle", "Small"]},
  {total = InfraTotalGraph[fib]},
  {conn = InfraConnection @ Select[EdgeList[total], First @ First @ # =!= First @ Last @ # &]},
  {lift = First @ FindInfraHorizontalLift[fib, conn, {1, 1}, Append[Range[8], 1], 1]},
  {InfraSubstrateHighlight[total, {InfraWalk[lift]}], First @ lift, Last @ lift}]
```

## Properties and Relations

The endpoints of the lifts from every vertex of the first fiber are the parallel transport.

```wl
With[
  {fib = InfraFiberedSubstrate["MoebiusLadderCover", "Small"]},
  {conn = InfraConnection @ Select[EdgeList @ InfraTotalGraph[fib], First @ First @ # =!= First @ Last @ # &]},
  {loop = Append[Range[8], 1]},
  {Last @ First @ FindInfraHorizontalLift[fib, conn, #, loop, 1] & /@ {{1, 1}, {1, 2}}, Normal @ InfraParallelTransport[fib, conn, loop]}]
```
