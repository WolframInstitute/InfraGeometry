---
Template: Symbol
Name: InfraConnection
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraConnection
Keywords: [connection, perfect matching, horizontal edge, parallel transport, holonomy, horizontal leaf]
SeeAlso: [InfraConnectionQ, RandomInfraConnection, InfraHorizontalLift, InfraParallelTransport, InfraHolonomy, InfraTrivialMonodromyQ]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[InfraConnection]()[*edges*]</code> is a connection given by a list of total edges of a fibered graph: over every base edge they match the two fibers one to one.

## Details & Options

A connection on a fibered graph is a set *H* of total edges such that, over every base edge *{p, q}*, the edges of *H* between *F(p)* and *F(q)* form a perfect matching. It has no vertical edges.

A connection moves each vertex of *F(p)* to one vertex of *F(q)*: following *H* along a base walk gives [InfraHorizontalLift](), [InfraParallelTransport]() and, around a closed walk, [InfraHolonomy]().

A connection exists only if adjacent fibers have the same size and the total edges between them contain a perfect matching. A fibered graph can have many connections; a covering has exactly one, all its edges.

The connected components of *H* are the horizontal leaves. The connection has trivial global monodromy, [InfraTrivialMonodromyQ](), when every leaf meets every fiber at most once.

[InfraConnection]() is a symbolic object: it carries no graph. [InfraConnectionQ]() tests it against a fibered graph, [RandomInfraConnection]() draws one and [InfraFiberedGraphHighlight]() draws it.

## Basic Examples

Two vertices over every vertex of the square grid, and all four total edges over every base edge. A connection takes two of them over each base edge:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  InfraFiberedGraphHighlight[fib, {conn}, "BaseVertexCoordinates" -> xy, PlotLabel -> InfraConnectionQ[fib, conn],
    ImageSize -> Medium]]
```

The holonomy around the four squares at the centre 45. Around the first two the transport exchanges the two vertices of the fiber:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  Table[InfraHolonomy[fib, conn, square],
    {square, {{45, 46, 36, 35, 45}, {45, 35, 34, 44, 45}, {45, 44, 54, 55, 45}, {45, 55, 56, 46, 45}}}]]
```

So the connection is not flat: its edges form a single horizontal leaf, which meets every fiber twice:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All, RandomSeeding -> 1]},
  {conn = RandomInfraConnection[fib, RandomSeeding -> 1]},
  {leaves = ConnectedComponents @ Graph[VertexList @ InfraTotalSpace[fib], First @ conn]},
  {Length[leaves], InfraTrivialMonodromyQ[fib, conn]}]
```

## Properties and Relations

With two vertices in every fiber and all total edges, each base edge carries two matchings. Over the cycle of length 4 there are 2⁴ = 16 connections, and the 8 with an even number of crossings are flat:

```wl
With[{fib = RandomInfraFiberedGraph[CycleGraph[4], "VerticalVertexCount" -> {2}, "HorizontalEdgeCount" -> All,
    RandomSeeding -> 1]},
  {all = RandomInfraConnection[fib, All]},
  {Length[all], Count[InfraTrivialMonodromyQ[fib, #] & /@ all, True]}]
```

A covering has one connection, the set of all its edges:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {all = RandomInfraConnection[fib, All]},
  {Length[all], Sort @ First @ First[all] === Sort @ EdgeList @ InfraTotalSpace[fib]}]
```

## Possible Issues

The displacement bundle of the grid has fibers with 4 vertices inside and 1 at the rim, so it has no connection:

```wl
RandomInfraConnection[InfraDisplacementBundle[InfraSubstrate["SquareGridGraph", "Small"], 1], All]
```
