---
Template: Symbol
Name: InfraTrivialMonodromyQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraTrivialMonodromyQ
Keywords: [trivial monodromy, global holonomy, holonomy, horizontal leaves, predicate]
SeeAlso: [InfraFlatConnectionQ, InfraConnection, InfraConnectionQ, InfraHolonomy, InfraParallelTransport, RandomInfraConnection, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraTrivialMonodromyQ]()[*fib*, *conn*]</code> gives `True` if the complete connection *conn* has trivial holonomy around every closed walk of the base.

<code>[InfraTrivialMonodromyQ]()[*fib*, {*conn1*, *conn2*, …}]</code> gives `True` if every *connᵢ* does.

## Details & Options

The condition is *hol(γ) = id* for every closed base walk *γ*, with *hol* the holonomy of [InfraHolonomy]().

Equivalently, every connected component of the graph of connection edges, a horizontal leaf, meets each fiber at most once. On a connected base each leaf is then a global section, and the connection identifies every fiber with one fixed fiber.

Over a tree every complete connection has trivial monodromy. On a connected base with *V* vertices and *E* edges, with fibers of *k* points joined completely, there are *(k!)ᴱ* connections and *(k!)ⱽ⁻¹* of them have trivial monodromy.

The test covers every component of the base.
It tests global path independence, rather than zero curvature on specified faces.
A flat connection can have nontrivial holonomy around a noncontractible loop.
The fibered graph itself carries no distinguished face system.

[InfraFlatConnectionQ]() is the retained compatibility spelling.

*conn* must be a complete connection, as [InfraConnectionQ]() tests; otherwise the result is `False`. The empty list gives `False`.

## Basic Examples

The prism and the Moebius ladder with their connections. The prism's connection has trivial monodromy; on the Moebius ladder the transport around the cycle exchanges the two ends of the rung:

```wl
GraphicsRow @ Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, {conn}, PlotLabel -> InfraTrivialMonodromyQ[fib, conn]]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

Fibers of two points over the 2 × 3 grid, joined completely. Of the 2⁷ = 128 connections, 2⁵ = 32 have trivial monodromy:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  {Length[conns], Count[conns, conn_ /; InfraTrivialMonodromyQ[fib, conn]]}]
```

## Scope

Over a spanning tree of the 3 × 3 grid all 2⁸ = 256 connections have trivial monodromy:

```wl
With[{fib = RandomInfraFiberedGraph[FindSpanningTree[GridGraph[{3, 3}]], "VerticalVertexCount" -> {2},
    "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  {Length[conns], InfraTrivialMonodromyQ[fib, conns]}]
```

## Properties and Relations

The horizontal leaves are the components of the connection graph. The prism has two leaves, each meeting every fiber once; the Moebius ladder has one, meeting every fiber twice:

```wl
Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
    Length /@ ConnectedComponents @ Graph[VertexList @ InfraTotalSpace[fib], First @ conn]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

For this grid, the two square boundaries generate its cycles: a connection has trivial monodromy exactly when its holonomy around both faces is the identity:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  AllTrue[conns, conn |-> InfraTrivialMonodromyQ[fib, conn] ===
    AllTrue[{{1, 2, 4, 3, 1}, {3, 4, 6, 5, 3}}, InfraHolonomy[fib, conn, #] === Cycles[{}] &]]]
```
