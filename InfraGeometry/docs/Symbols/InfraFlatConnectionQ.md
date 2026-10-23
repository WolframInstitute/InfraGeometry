---
Template: Symbol
Name: InfraFlatConnectionQ
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraFlatConnectionQ
Keywords: [flat connection, trivial monodromy, holonomy, horizontal leaves, predicate]
SeeAlso: [InfraConnection, InfraConnectionQ, InfraHolonomy, InfraParallelTransport, RandomInfraConnection, InfraFiberBundleQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraFlatConnectionQ]()[*fib*, *conn*]</code> gives `True` if the complete connection *conn* has trivial holonomy around every closed walk of the base.

<code>[InfraFlatConnectionQ]()[*fib*, {*conn1*, *conn2*, …}]</code> gives `True` if every *connᵢ* does.

## Details & Options

The condition is *hol(γ) = id* for every closed base walk *γ*, with *hol* the holonomy of [InfraHolonomy]().

Equivalently, every connected component of the graph of connection edges, a horizontal leaf, meets each fiber at most once. On a connected base each leaf is then a global section, and the connection identifies every fiber with one fixed fiber.

Over a tree every connection is flat. On a connected base with *V* vertices and *E* edges, with fibers of *k* points joined completely, there are *(k!)ᴱ* connections and *(k!)ⱽ⁻¹* of them are flat.

The test covers every component of the base. A graph has no faces, so the test is global and not a curvature measured on faces.

*conn* must be a complete connection, as [InfraConnectionQ]() tests; otherwise the result is `False`. The empty list gives `False`.

## Basic Examples

The prism and the Moebius ladder with their connections. The prism's connection is flat; on the Moebius ladder the transport around the cycle exchanges the two ends of the rung:

```wl
GraphicsRow @ Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
    InfraFiberedGraphHighlight[fib, {conn}, PlotLabel -> InfraFlatConnectionQ[fib, conn]]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

Fibers of two points over the 2 × 3 grid, joined completely. Of the 2⁷ = 128 connections, 2⁵ = 32 are flat:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  {Length[conns], Count[conns, conn_ /; InfraFlatConnectionQ[fib, conn]]}]
```

## Scope

Over a spanning tree of the 3 × 3 grid all 2⁸ = 256 connections are flat:

```wl
With[{fib = RandomInfraFiberedGraph[FindSpanningTree[GridGraph[{3, 3}]], "VerticalVertexCount" -> {2},
    "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  {Length[conns], InfraFlatConnectionQ[fib, conns]}]
```

## Properties and Relations

The horizontal leaves are the components of the connection graph. The prism has two leaves, each meeting every fiber once; the Moebius ladder has one, meeting every fiber twice:

```wl
Table[
  With[{fib = InfraFiberedSubstrate[name, "Small"]}, {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
    Length /@ ConnectedComponents @ Graph[VertexList @ InfraTotalSpace[fib], First @ conn]],
  {name, {"CycleProductBundle", "MoebiusLadderCover"}}]
```

On the grid the two faces decide: a connection is flat exactly when its holonomy around both faces is the identity:

```wl
With[{fib = RandomInfraFiberedGraph[GridGraph[{2, 3}], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {conns = RandomInfraConnection[fib, All]},
  AllTrue[conns, conn |-> InfraFlatConnectionQ[fib, conn] ===
    AllTrue[{{1, 2, 4, 3, 1}, {3, 4, 6, 5, 3}}, InfraHolonomy[fib, conn, #] === Cycles[{}] &]]]
```
