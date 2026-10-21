---
Template: Symbol
Name: FindInfraHorizontalLift
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraHorizontalLift
Keywords: [horizontal lift, path lifting, connection, walk, counted list]
SeeAlso: [InfraHorizontalLift, InfraConnection, InfraParallelTransport, InfraHolonomy]
RelatedGuides: [InfraFiberBundles]
RelatedTutorials: [InfraBundles]
---

## Usage

<code>[FindInfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*, *n*]</code> gives a list of at most *n* horizontal lifts of the base walk *walk* starting at the total vertex *x*, along the connection *conn*.

## Details & Options

A connection gives one lift of a walk from each start, so the list has at most one member, <code>[InfraHorizontalLift]()[*fib*, *conn*, *x*, *walk*]</code>. [InfraHorizontalLift]() returns that lift directly.

| Count *n* | Result |
|---|---|
| `1`, `UpTo[n]` with *n* ≥ 1, `All` | the list of the one lift |
| `0`, `UpTo[0]` | `{}` |
| *n* ≥ 2 | `{}`: there are not *n* lifts |

*conn* must satisfy [InfraConnectionQ](), *x* must lie over the first vertex of *walk*, and consecutive vertices of *walk* must be adjacent in the base.

## Basic Examples

A double cover of the square grid, and the lift of a square at the centre from sheet 1. It ends on sheet 2:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small", "KeepCoordinates" -> True]},
  {xy = AssociationThread[VertexList[g], GraphEmbedding[g]]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = InfraConnection[EdgeList @ InfraTotalSpace[fib]]},
  {lifts = FindInfraHorizontalLift[fib, conn, {45, 1}, {45, 46, 36, 35, 45}, 1]},
  InfraFiberedGraphHighlight[fib, InfraWalk /@ lifts, "BaseVertexCoordinates" -> xy, PlotLabel -> lifts,
    ImageSize -> Medium]]
```

The counted list holds the lift that [InfraHorizontalLift]() gives, and asking for two lifts gives `{}`:

```wl
With[{g = InfraSubstrate["SquareGridGraph", "Small"]},
  {fib = RandomInfraFiberedGraph[g, Properties -> {"Covering"}, "VerticalVertexCount" -> {2}, RandomSeeding -> 1]},
  {conn = InfraConnection[EdgeList @ InfraTotalSpace[fib]], square = {45, 46, 36, 35, 45}},
  {FindInfraHorizontalLift[fib, conn, {45, 1}, square, All] === {InfraHorizontalLift[fib, conn, {45, 1}, square]},
    FindInfraHorizontalLift[fib, conn, {45, 1}, square, 2]}]
```
